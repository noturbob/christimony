import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/data/my_profiles.dart';
import 'package:christimony/domain/models/profile.dart';
import 'package:christimony/features/discover/discover_controller.dart';
import 'package:christimony/features/discover/discover_screen.dart';
import 'package:christimony/features/discover/profile_detail_screen.dart';
import 'package:christimony/features/discover/swipe_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, Object?> _profile(int id, {String gender = 'female'}) => {
  'id': id,
  'name': 'P$id',
  'profile_type': 'self',
  'status': 'active',
  'gender': gender,
};

Map<String, Object?> _page(Iterable<int> ids, int? next) => {
  'profiles': [for (final id in ids) _profile(id)],
  'next_after_id': next,
};

void main() {
  late DioAdapter adapter;
  late List<String> requests;
  late List<Override> overrides;
  late ProviderContainer container;

  setUp(() {
    requests = [];
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
      ..interceptors.addAll([
        InterceptorsWrapper(
          onRequest: (o, h) {
            final q = o.queryParameters.isEmpty ? '' : '?${o.queryParameters}';
            requests.add('${o.method} ${o.path}$q');
            h.next(o);
          },
        ),
        ErrorInterceptor(),
      ]);
    adapter = DioAdapter(dio: dio);
    final me = Profile.fromJson(_profile(1, gender: 'male'));
    overrides = [
      christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
      myProfilesProvider.overrideWith((_) async => [me]),
    ];
    container = ProviderContainer(overrides: overrides);
  });

  tearDown(() => container.dispose());

  DeckState deck() => container.read(deckProvider).requireValue;
  DeckController controller() => container.read(deckProvider.notifier);

  test(
    'defaults the gender filter to the opposite of the acting profile',
    () async {
      adapter.onGet(
        '/profiles/feed',
        (s) => s.reply(200, _page([10, 11], null)),
        queryParameters: {'gender': 'female'},
      );

      final state = await container.read(deckProvider.future);

      expect(state.filters.gender, 'female');
      expect(state.queue.map((p) => p.id), [10, 11]);
    },
  );

  test(
    'pass removes the card; undo deletes the pass and restores it',
    () async {
      adapter
        ..onGet(
          '/profiles/feed',
          (s) => s.reply(200, _page([10, 11], null)),
          queryParameters: {'gender': 'female'},
        )
        ..onPost(
          '/passes',
          (s) => s.reply(201, {'id': 99}),
          data: {'profile_id': 1, 'passed_profile_id': 10},
        )
        ..onDelete('/passes/99', (s) => s.reply(204, null));
      await container.read(deckProvider.future);

      await controller().pass();
      expect(deck().queue.map((p) => p.id), [11]);
      expect(deck().undo?.passId, 99);

      await controller().undo();
      expect(deck().queue.map((p) => p.id), [10, 11]);
      expect(deck().undo, isNull);
      expect(requests.last, 'DELETE /passes/99');
    },
  );

  test(
    'prefetches with after_id once 3 cards remain, and stops at null',
    () async {
      adapter
        ..onGet(
          '/profiles/feed',
          (s) => s.reply(200, _page([10, 11, 12, 13, 14], 14)),
          queryParameters: {'gender': 'female'},
        )
        ..onGet(
          '/profiles/feed',
          (s) => s.reply(200, _page([15], null)),
          queryParameters: {'gender': 'female', 'after_id': 14},
        );
      for (final id in [10, 11, 12]) {
        adapter.onPost(
          '/passes',
          (s) => s.reply(201, {'id': id}),
          data: {'profile_id': 1, 'passed_profile_id': id},
        );
      }
      await container.read(deckProvider.future);
      int feedCalls() => requests.where((r) => r.contains('/feed')).length;

      await controller().pass(); // 4 left -- no prefetch yet
      expect(feedCalls(), 1);

      await controller().pass(); // 3 left -- prefetch
      await pumpEventQueue();
      expect(requests.where((r) => r.contains('after_id: 14')), hasLength(1));
      expect(deck().queue.map((p) => p.id), [12, 13, 14, 15]);
      expect(deck().nextAfterId, isNull);

      await controller().pass(); // next_after_id is null -- no more pages
      await pumpEventQueue();
      expect(feedCalls(), 2);
    },
  );

  test('like with a mutual match opens the conversation', () async {
    adapter
      ..onGet(
        '/profiles/feed',
        (s) => s.reply(200, _page([10], null)),
        queryParameters: {'gender': 'female'},
      )
      ..onPost(
        '/interests',
        (s) => s.reply(201, {
          'interest': {
            'id': 3,
            'sender_profile_id': 1,
            'receiver_profile_id': 10,
            'status': 'accepted',
          },
          'match': {
            'id': 5,
            'profile_a_id': 1,
            'profile_b_id': 10,
            'match_type': 'direct',
          },
        }),
        data: {'sender_profile_id': 1, 'receiver_profile_id': 10},
      )
      ..onPost(
        '/conversations',
        (s) => s.reply(201, {'id': 77}),
        data: {'match_id': 5},
      );
    await container.read(deckProvider.future);

    final match = await controller().like();

    expect(match?.conversationId, 77);
    expect(match?.profile.id, 10);
    expect(requests.skip(1), ['POST /interests', 'POST /conversations']);
    expect(deck().queue, isEmpty);
    expect(deck().undo, isNull);
  });

  testWidgets('a 404 profile shows the unavailable state', (tester) async {
    adapter.onGet('/profiles/5', (s) => s.reply(404, {'error': 'Not found'}));

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: ProfileDetailScreen(profileId: 5)),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text("This profile isn't available"), findsOneWidget);
    expect(find.text('Like'), findsNothing);
  });

  testWidgets('dragging the card past the threshold likes it', (tester) async {
    adapter
      ..onGet(
        '/profiles/feed',
        (s) => s.reply(200, _page([10, 11], null)),
        queryParameters: {'gender': 'female'},
      )
      ..onPost(
        '/interests',
        (s) => s.reply(201, {
          'interest': {
            'id': 3,
            'sender_profile_id': 1,
            'receiver_profile_id': 10,
            'status': 'pending',
          },
          'match': null,
        }),
        data: {'sender_profile_id': 1, 'receiver_profile_id': 10},
      );
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(home: DiscoverScreen()),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('P10'), findsWidgets);

    await tester.drag(find.byType(SwipeCard), const Offset(200, 0));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(requests, contains('POST /interests'));
    expect(find.text('P10'), findsNothing);
    expect(find.text('P11'), findsWidgets);
  });
}
