import 'dart:async';
import 'dart:convert';

import 'package:christimony/core/realtime/cable_client.dart';
import 'package:christimony/core/realtime/cable_protocol.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class _FakeSink implements WebSocketSink {
  final List<Object?> sent = [];
  bool closed = false;

  @override
  void add(Object? data) => sent.add(data);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async =>
      closed = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeChannel implements WebSocketChannel {
  final server = StreamController<Object?>();
  final fakeSink = _FakeSink();

  @override
  WebSocketSink get sink => fakeSink;

  @override
  Stream<Object?> get stream => server.stream;

  @override
  Future<void> get ready => Future.value();

  void receive(Map<String, Object?> frame) => server.add(jsonEncode(frame));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const identifier = '{"channel":"AccountChannel"}';

  group('protocol', () {
    test('subscribe command carries the identifier as a JSON string', () {
      expect(accountChannelIdentifier, identifier);
      expect(
        subscribeCommand(accountChannelIdentifier),
        r'{"command":"subscribe","identifier":"{\"channel\":\"AccountChannel\"}"}',
      );
    });

    test('parses each server frame', () {
      CableFrame parse(Object frame) => parseCableFrame(jsonEncode(frame));

      expect(parse({'type': 'welcome'}), isA<CableWelcome>());
      expect(parse({'type': 'ping', 'message': 1}), isA<CablePing>());
      expect(
        parse({'type': 'confirm_subscription', 'identifier': identifier}),
        isA<CableConfirmed>().having((f) => f.identifier, 'id', identifier),
      );
      expect(
        parse({'type': 'reject_subscription', 'identifier': identifier}),
        isA<CableRejected>(),
      );
      expect(
        parse({
          'type': 'disconnect',
          'reason': 'unauthorized',
          'reconnect': false,
        }),
        isA<CableDisconnect>()
            .having((f) => f.reason, 'reason', 'unauthorized')
            .having((f) => f.reconnect, 'reconnect', false),
      );
      expect(
        parse({
          'identifier': identifier,
          'message': {'type': 'match', 'match_id': 3},
        }),
        isA<CableMessage>().having((f) => f.message['match_id'], 'id', 3),
      );
      expect(parseCableFrame('not json'), isA<CableIgnored>());
      expect(parse([1, 2]), isA<CableIgnored>());
    });

    test('backoff doubles from 500ms, caps at 30s, jitters ±30%', () {
      expect(cableBackoff(0, 0.5), const Duration(milliseconds: 500));
      expect(cableBackoff(3, 0.5), const Duration(milliseconds: 4000));
      expect(cableBackoff(20, 0.5), const Duration(seconds: 30));
      expect(cableBackoff(0, 0), const Duration(milliseconds: 350));
      expect(cableBackoff(20, 0.999).inMilliseconds, lessThan(39000));
    });
  });

  group('client', () {
    late List<_FakeChannel> channels;
    late List<Uri> urls;
    late int unauthorized;
    late CableClient client;

    setUp(() {
      channels = [];
      urls = [];
      unauthorized = 0;
      client = CableClient(
        url: Uri.parse('wss://example.test/cable'),
        token: () => 'jwt',
        onUnauthorized: () => unauthorized++,
        connect: (url) {
          urls.add(url);
          return (channels..add(_FakeChannel())).last;
        },
      )..start();
    });

    tearDown(() => client.dispose());

    test('welcome -> subscribe; confirm -> live; messages -> events', () async {
      expect(urls.single.queryParameters['token'], 'jwt');
      final events = <Map<String, dynamic>>[];
      client.events.listen(events.add);
      final ch = channels.single..receive({'type': 'welcome'});
      await pumpEventQueue();
      expect(ch.fakeSink.sent, [subscribeCommand(identifier)]);
      expect(client.live.value, isFalse);

      ch.receive({'type': 'confirm_subscription', 'identifier': identifier});
      await pumpEventQueue();
      expect(client.live.value, isTrue);

      ch
        ..receive({
          'identifier': identifier,
          'message': {'type': 'match', 'match_id': 4},
        })
        ..receive({
          'identifier': '{"channel":"Other"}',
          'message': {'type': 'match', 'match_id': 5},
        });
      await pumpEventQueue();
      expect(events, [
        {'type': 'match', 'match_id': 4},
      ]);
    });

    test('unauthorized disconnect stops for good and reports it', () async {
      channels.single.receive({
        'type': 'disconnect',
        'reason': 'unauthorized',
        'reconnect': false,
      });
      await pumpEventQueue();
      expect(unauthorized, 1);
      expect(channels.single.fakeSink.closed, isTrue);
      expect(client.live.value, isFalse);
    });

    test('a dropped socket goes un-live and reconnects', () async {
      final ch = channels.single
        ..receive({'type': 'welcome'})
        ..receive({'type': 'confirm_subscription', 'identifier': identifier});
      await pumpEventQueue();
      expect(client.live.value, isTrue);

      await ch.server.close();
      await pumpEventQueue();
      expect(client.live.value, isFalse);
      // Attempt 0 waits at most 650ms.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      expect(channels, hasLength(2));
    });
  });
}
