import 'dart:async';

import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/core/realtime/realtime.dart';
import 'package:christimony/core/session/session_controller.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/domain/models/account.dart';
import 'package:christimony/domain/models/enums.dart';
import 'package:christimony/domain/models/message.dart';
import 'package:christimony/features/chat/thread_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

const _me = 7;
const _them = 9;
const _cid = 1;
const _path = '/conversations/$_cid/messages';

Map<String, Object?> _msg(int id, {int sender = _them, String? readAt}) => {
  'id': id,
  'conversation_id': _cid,
  'sender_account_id': sender,
  'body': 'm$id',
  'sent_at': '2026-10-09T10:00:00Z',
  'read_at': readAt,
};

List<Map<String, Object?>> _range(int from, int to) => [
  for (var id = from; id <= to; id++) _msg(id, readAt: 'x'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DioAdapter adapter;
  late List<RequestOptions> requests;
  late StreamController<Map<String, dynamic>> events;
  late ValueNotifier<bool> live;
  late ProviderContainer container;

  setUp(() {
    requests = [];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
      ..interceptors.addAll([
        InterceptorsWrapper(
          onRequest: (o, h) {
            requests.add(o);
            h.next(o);
          },
        ),
        ErrorInterceptor(),
      ]);
    adapter = DioAdapter(dio: dio);
    events = StreamController.broadcast();
    live = ValueNotifier(false);
    container = ProviderContainer(
      overrides: [
        christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
        realtimeProvider.overrideWithValue(
          RealtimeFeed(events: events.stream, live: live),
        ),
        currentAccountProvider.overrideWithValue(
          const Account(id: _me, accountType: AccountType.individual),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<ThreadState> open() async {
    container.listen(threadProvider(_cid), (_, _) {});
    return await container.read(threadProvider(_cid).future);
  }

  ThreadState state() => container.read(threadProvider(_cid)).requireValue;
  ThreadController controller() =>
      container.read(threadProvider(_cid).notifier);
  Iterable<String> paths() => requests.map((r) => '${r.method} ${r.uri.path}');

  test('mergeMessages dedupes by id, prefers the newer copy, sorts', () {
    final a = Message.fromJson(_msg(1));
    final b = Message.fromJson(_msg(2));
    final bRead = Message.fromJson(_msg(2, readAt: 'now'));
    final merged = mergeMessages([b, a], [bRead, a]);
    expect(merged.map((m) => m.id), [1, 2]);
    expect(merged.last.readAt, 'now');
  });

  test('opening loads the newest page and marks read', () async {
    adapter
      ..onGet(
        _path,
        (s) => s.reply(200, [_msg(5)]),
        queryParameters: {'limit': 30},
      )
      ..onPost('/conversations/$_cid/read', (s) => s.reply(204, null));

    final s = await open();
    await pumpEventQueue();

    expect(s.messages.map((m) => m.id), [5]);
    expect(s.hasEarlier, isFalse);
    expect(paths(), contains('POST /api/v1/conversations/$_cid/read'));
  });

  test('nothing unread -> no read call', () async {
    adapter.onGet(
      _path,
      (s) => s.reply(200, [_msg(5, readAt: 'x')]),
      queryParameters: {'limit': 30},
    );
    await open();
    await pumpEventQueue();
    expect(paths().where((p) => p.endsWith('/read')), isEmpty);
  });

  test('load earlier pages with before_id = oldest loaded id', () async {
    adapter
      ..onGet(
        _path,
        (s) => s.reply(200, _range(31, 60)),
        queryParameters: {'limit': 30},
      )
      ..onGet(
        _path,
        (s) => s.reply(200, _range(21, 30)),
        queryParameters: {'limit': 30, 'before_id': 31},
      );

    expect((await open()).hasEarlier, isTrue);
    await controller().loadEarlier();

    expect(requests.last.queryParameters['before_id'], 31);
    expect(state().messages.first.id, 21);
    expect(state().messages, hasLength(40));
    expect(state().hasEarlier, isFalse);
  });

  test('optimistic send: pending, then replaced by the server copy', () async {
    adapter
      ..onGet(
        _path,
        (s) => s.reply(200, <Object>[]),
        queryParameters: {'limit': 30},
      )
      ..onPost(
        _path,
        (s) => s.reply(201, _msg(10, sender: _me)),
        data: {'body': 'hello'},
      );
    await open();

    final sending = controller().send('  hello ');
    expect(state().pending.single.body, 'hello');
    expect(state().pending.single.failed, isFalse);
    await sending;

    expect(state().pending, isEmpty);
    expect(state().messages.single.id, 10);
  });

  test('failed send is marked failed, and retry delivers it', () async {
    adapter
      ..onGet(
        _path,
        (s) => s.reply(200, <Object>[]),
        queryParameters: {'limit': 30},
      )
      ..onPost(
        _path,
        (s) => s.reply(422, {
          'errors': ['nope'],
        }),
        data: {'body': 'hi'},
      );
    await open();

    await controller().send('hi');
    final failed = state().pending.single;
    expect(failed.failed, isTrue);

    adapter.onPost(
      _path,
      (s) => s.reply(201, _msg(11, sender: _me)),
      data: {'body': 'hi'},
    );
    await controller().retry(failed);
    expect(state().pending, isEmpty);
    expect(state().messages.single.id, 11);
  });

  test('realtime echo of my send never duplicates the bubble', () async {
    final reply = Completer<void>();
    adapter
      ..onGet(
        _path,
        (s) => s.reply(200, <Object>[]),
        queryParameters: {'limit': 30},
      )
      ..onPost(_path, (s) async {
        await reply.future;
        return s.reply(201, _msg(12, sender: _me));
      }, data: {'body': 'm12'});
    await open();

    final sending = controller().send('m12');
    events.add({'type': 'message', 'message': _msg(12, sender: _me)});
    await pumpEventQueue();
    expect(state().pending, isEmpty);
    expect(state().messages.single.id, 12);

    reply.complete();
    await sending;
    expect(state().messages.single.id, 12);
    expect(state().pending, isEmpty);
  });

  test('reconnect re-fetches back to the last known id: no gap', () async {
    adapter.onGet(
      _path,
      (s) => s.reply(200, _range(1, 5)),
      queryParameters: {'limit': 30},
    );
    await open();

    // 40 messages arrived while the socket was down: two pages to close.
    adapter
      ..onGet(
        _path,
        (s) => s.reply(200, _range(16, 45)),
        queryParameters: {'limit': 30},
      )
      ..onGet(
        _path,
        (s) => s.reply(200, _range(1, 15)),
        queryParameters: {'limit': 30, 'before_id': 16},
      );
    live.value = true;
    await pumpEventQueue();

    expect(state().messages.map((m) => m.id), [
      for (var i = 1; i <= 45; i++) i,
    ]);
  });
}
