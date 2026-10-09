import 'dart:convert';

import 'package:christimony/core/network/interceptors/error_interceptor.dart';
import 'package:christimony/core/session/session_controller.dart';
import 'package:christimony/core/theme/theme.dart';
import 'package:christimony/data/api/christimony_api.dart';
import 'package:christimony/domain/models/account.dart';
import 'package:christimony/domain/models/enums.dart';
import 'package:christimony/features/onboarding/onboarding_controller.dart';
import 'package:christimony/features/onboarding/onboarding_draft.dart';
import 'package:christimony/features/onboarding/onboarding_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('every step renders, parent copy included, at 2x text', (
    tester,
  ) async {
    const draft = OnboardingDraft(
      accountType: 'parent',
      profileId: 1,
      name: 'Asha',
      city: 'Chennai',
      bio: 'Loves music.',
      step: 'name',
    );
    SharedPreferences.setMockInitialValues({
      'onboarding-draft-7': jsonEncode(draft.toJson()),
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
    DioAdapter(dio: dio)
      ..onGet(
        '/denominations',
        (s) => s.reply(200, [
          {'id': 1, 'name': 'Catholic'},
        ]),
      )
      ..onGet('/prompt_questions', (s) => s.reply(200, ['Family means…']));

    for (final step in onboardingSteps.skip(1)) {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
            currentAccountProvider.overrideWithValue(
              const Account(id: 7, accountType: AccountType.parent),
            ),
          ],
          child: MaterialApp(
            theme: buildTheme(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: OnboardingScreen(step: step),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: step);
    }
    expect(find.text('Ready to go'), findsOneWidget);
    expect(
      find.text("Here's what other families will see first."),
      findsOneWidget,
    );
  });

  test('steps run in the web wizard order', () {
    expect(onboardingSteps, [
      'account-type',
      'name',
      'dob',
      'gender',
      'denomination',
      'city',
      'education',
      'photos',
      'prompts',
      'bio',
      'review',
    ]);
  });

  group('validation', () {
    const d = OnboardingDraft();
    final now = DateTime(2026, 10, 9);

    test('name and city must be non-blank; denomination is optional', () {
      expect(canContinue('name', d.copyWith(name: '  ')), isFalse);
      expect(canContinue('name', d.copyWith(name: 'Asha')), isTrue);
      expect(canContinue('city', d), isFalse);
      expect(canContinue('denomination', d), isTrue);
      expect(canContinue('gender', d), isFalse);
      expect(canContinue('nonsense', d), isFalse);
    });

    test('dob must be 18 or more years ago, to the day', () {
      expect(isAdult('2008-10-09', now: now), isTrue);
      expect(isAdult('2008-10-10', now: now), isFalse);
      expect(isAdult('', now: now), isFalse);
    });

    test('prompts need exactly 3, all answered', () {
      final two = d.copyWith(answers: {'a': 'x', 'b': 'y'});
      expect(canContinue('prompts', two), isFalse);
      expect(
        canContinue('prompts', d.copyWith(answers: {...two.answers, 'c': ''})),
        isFalse,
      );
      expect(
        canContinue('prompts', d.copyWith(answers: {...two.answers, 'c': 'z'})),
        isTrue,
      );
    });
  });

  group('controller', () {
    late DioAdapter adapter;
    late ProviderContainer container;

    ProviderContainer build(AccountType type) {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'))
        ..interceptors.add(ErrorInterceptor());
      adapter = DioAdapter(dio: dio);
      return container = ProviderContainer(
        overrides: [
          christimonyApiProvider.overrideWithValue(ChristimonyApi(dio)),
          currentAccountProvider.overrideWithValue(
            Account(id: 7, accountType: type),
          ),
        ],
      );
    }

    tearDown(() => container.dispose());

    test('resuming with a saved profileId updates it, never POSTs', () async {
      const saved = OnboardingDraft(
        profileId: 42,
        name: 'Asha',
        dob: '1998-04-02',
        gender: 'female',
        city: 'Chennai',
        step: 'photos',
      );
      SharedPreferences.setMockInitialValues({
        'onboarding-draft-7': jsonEncode(saved.toJson()),
      });
      build(AccountType.individual);
      adapter
        ..onPatch(
          '/profiles/42',
          (s) => s.reply(200, {'id': 42}),
          data: Matchers.any,
        )
        ..onPost(
          '/profiles',
          (s) => s.reply(201, {'id': 99}),
          data: Matchers.any,
        );

      final draft = await container.read(onboardingProvider.future);
      expect(draft.profileId, 42);
      final controller = container.read(onboardingProvider.notifier);
      expect(controller.takeResumeStep('account-type'), 'photos');
      expect(controller.takeResumeStep('account-type'), isNull);

      await controller.saveBasics();
      expect(container.read(onboardingProvider).value!.profileId, 42);
    });

    test("a parent's fresh draft creates the child's ward profile", () async {
      SharedPreferences.setMockInitialValues({});
      build(AccountType.parent);
      adapter.onPost(
        '/profiles',
        (s) => s.reply(201, {'id': 5}),
        data: {
          'profile': {
            'name': 'Asha',
            'dob': '1998-04-02',
            'gender': 'female',
            'city': 'Chennai',
            'denomination_id': null,
            'education': '',
            'profession': '',
            'profile_type': 'ward',
          },
        },
      );

      final draft = await container.read(onboardingProvider.future);
      expect(draft.forChild, isTrue);
      container
          .read(onboardingProvider.notifier)
          .edit(
            (d) => d.copyWith(
              name: ' Asha ',
              dob: '1998-04-02',
              gender: 'female',
              city: 'Chennai',
            ),
          );
      await container.read(onboardingProvider.notifier).saveBasics();

      expect(container.read(onboardingProvider).value!.profileId, 5);
      final prefs = await SharedPreferences.getInstance();
      final persisted = OnboardingDraft.fromJson(
        jsonDecode(prefs.getString('onboarding-draft-7')!)
            as Map<String, dynamic>,
      );
      expect(persisted.profileId, 5);
    });
  });
}
