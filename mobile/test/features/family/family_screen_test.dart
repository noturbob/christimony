import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/core/session/session_controller.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/domain/models/account.dart';
import 'package:christimony/domain/models/enums.dart';
import 'package:christimony/domain/models/introduction.dart';
import 'package:christimony/features/family/family_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, Object> _intro(String status) => {
  'id': 5,
  'parent_match_id': 1,
  'status': status,
  'ward_a': {'id': 11, 'name': 'Anna', 'city': 'Kochi'},
  'ward_b': {'id': 22, 'name': 'Ben', 'city': 'Pune'},
};

Map<String, Object> _profile(int id, String type) => {
  'id': id,
  'name': 'P$id',
  'profile_type': type,
  'status': 'active',
};

void main() {
  group('introductionStatusLabel', () {
    String label(String status, int myWard) =>
        introductionStatusLabel(Introduction.fromJson(_intro(status)), myWard);

    test('resolved and both-pending states read the same from either side', () {
      for (final side in [11, 22]) {
        expect(label('accepted', side), 'Both accepted — check Matches');
        expect(label('declined', side), 'Declined');
        expect(
          label('pending_both', side),
          'Awaiting a response from both sides',
        );
      }
    });

    test('pending_a waits on ward A', () {
      expect(label('pending_a', 11), 'Waiting on you');
      expect(label('pending_a', 22), 'Waiting on the other family');
    });

    test('pending_b waits on ward B', () {
      expect(label('pending_b', 22), 'Waiting on you');
      expect(label('pending_b', 11), 'Waiting on the other family');
    });

    test('myWardIn picks the side we manage', () {
      final intro = Introduction.fromJson(_intro('pending_both'));
      expect(myWardIn(intro, {22}).id, 22);
      expect(myWardIn(intro, {11, 3}).id, 11);
    });
  });

  group('FamilyScreen', () {
    late DioAdapter adapter;
    late Dio dio;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
        ..interceptors.add(ErrorInterceptor());
      adapter = DioAdapter(dio: dio);
    });

    Future<void> pump(
      WidgetTester tester, {
      required String accountType,
      required List<Map<String, Object>> profiles,
      List<Map<String, Object>> intros = const [],
    }) async {
      adapter
        ..onGet('/profiles', (s) => s.reply(200, profiles))
        ..onGet('/introductions', (s) => s.reply(200, intros));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
            currentAccountProvider.overrideWithValue(
              Account(id: 1, accountType: AccountType.fromJson(accountType)),
            ),
          ],
          child: const MaterialApp(home: FamilyScreen()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('ward banner shows for a parent with no ward profile', (
      tester,
    ) async {
      await pump(
        tester,
        accountType: 'parent',
        profiles: [_profile(3, 'self')],
      );
      expect(find.byType(WardBanner), findsOneWidget);
    });

    testWidgets('no ward banner for a parent who has a ward', (tester) async {
      await pump(
        tester,
        accountType: 'parent',
        profiles: [_profile(3, 'self'), _profile(11, 'ward')],
      );
      expect(find.byType(WardBanner), findsNothing);
    });

    testWidgets('no ward banner for an individual account', (tester) async {
      await pump(
        tester,
        accountType: 'individual',
        profiles: [_profile(3, 'self')],
      );
      expect(find.byType(WardBanner), findsNothing);
      expect(find.textContaining('Family is for parents'), findsOneWidget);
    });

    testWidgets('accept posts our ward id and shows the new status', (
      tester,
    ) async {
      adapter.onPost(
        '/introductions/5/accept',
        (s) => s.reply(200, _intro('pending_a')),
        data: {'ward_profile_id': 22},
      );
      await pump(
        tester,
        accountType: 'parent',
        profiles: [_profile(22, 'ward')],
        intros: [_intro('pending_both')],
      );

      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      expect(find.text('Waiting on the other family'), findsOneWidget);
      expect(find.text('Accept'), findsNothing);
    });

    testWidgets('decline confirms, then posts our ward id', (tester) async {
      adapter.onPost(
        '/introductions/5/decline',
        (s) => s.reply(200, _intro('declined')),
        data: {'ward_profile_id': 11},
      );
      await pump(
        tester,
        accountType: 'parent',
        profiles: [_profile(11, 'ward')],
        intros: [_intro('pending_a')],
      );

      await tester.tap(find.text('Decline'));
      await tester.pumpAndSettle();
      expect(find.text('Decline this introduction?'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Decline').last);
      await tester.pumpAndSettle();

      expect(find.text('Declined'), findsOneWidget);
      expect(find.text('Accept'), findsNothing);
    });
  });
}
