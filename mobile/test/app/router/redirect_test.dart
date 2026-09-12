import 'package:christimony/app/router/redirect.dart';
import 'package:christimony/app/router/routes.dart';
import 'package:christimony/domain/models/account.dart';
import 'package:christimony/domain/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

Account _account({required bool onboardingComplete}) {
  return Account(
    id: 1,
    accountType: AccountType.individual,
    onboarding: OnboardingStatus(complete: onboardingComplete),
  );
}

void main() {
  group('resolveRedirect', () {
    // --- SessionLoading: only the splash screen is allowed. ---
    test('loading + splash -> stays', () {
      expect(resolveRedirect(const SessionLoading(), Routes.splash), isNull);
    });

    test('loading + any other route -> splash', () {
      expect(
        resolveRedirect(const SessionLoading(), Routes.discover),
        Routes.splash,
      );
    });

    // --- Unauthenticated: only login/otp are allowed. ---
    test('unauthenticated + login -> stays', () {
      expect(resolveRedirect(const Unauthenticated(), Routes.login), isNull);
    });

    test('unauthenticated + otp -> stays', () {
      expect(resolveRedirect(const Unauthenticated(), Routes.otp), isNull);
    });

    test('unauthenticated + app route -> login with next param', () {
      final result = resolveRedirect(const Unauthenticated(), Routes.discover);
      expect(result, '${Routes.login}?next=%2Fdiscover');
    });

    test('unauthenticated + onboarding route -> login with next param', () {
      final result = resolveRedirect(
        const Unauthenticated(),
        Routes.onboardingFirstStep,
      );
      expect(result, isNotNull);
      expect(result, startsWith(Routes.login));
    });

    // --- Authenticated + splash: route by onboarding completeness. ---
    test('authenticated (complete) + splash -> discover', () {
      final session = Authenticated(_account(onboardingComplete: true));
      expect(resolveRedirect(session, Routes.splash), Routes.discover);
    });

    test('authenticated (incomplete) + splash -> onboarding first step', () {
      final session = Authenticated(_account(onboardingComplete: false));
      expect(
        resolveRedirect(session, Routes.splash),
        Routes.onboardingFirstStep,
      );
    });

    // --- Authenticated + incomplete onboarding: locked to onboarding. ---
    test('authenticated (incomplete) + onboarding route -> stays', () {
      final session = Authenticated(_account(onboardingComplete: false));
      expect(resolveRedirect(session, '/onboarding/photos'), isNull);
    });

    test('authenticated (incomplete) + app route -> onboarding first step', () {
      final session = Authenticated(_account(onboardingComplete: false));
      expect(
        resolveRedirect(session, Routes.discover),
        Routes.onboardingFirstStep,
      );
    });

    test('authenticated (incomplete) + login -> onboarding first step', () {
      final session = Authenticated(_account(onboardingComplete: false));
      expect(
        resolveRedirect(session, Routes.login),
        Routes.onboardingFirstStep,
      );
    });

    // --- Authenticated + complete onboarding: normal app navigation. ---
    test('authenticated (complete) + app route -> stays', () {
      final session = Authenticated(_account(onboardingComplete: true));
      expect(resolveRedirect(session, Routes.discover), isNull);
      expect(resolveRedirect(session, Routes.matches), isNull);
      expect(resolveRedirect(session, Routes.messages), isNull);
      expect(resolveRedirect(session, Routes.family), isNull);
      expect(resolveRedirect(session, Routes.profile), isNull);
    });

    test('authenticated (complete) + login -> discover (bounced away)', () {
      final session = Authenticated(_account(onboardingComplete: true));
      expect(resolveRedirect(session, Routes.login), Routes.discover);
    });

    test('authenticated (complete) + otp -> discover (bounced away)', () {
      final session = Authenticated(_account(onboardingComplete: true));
      expect(resolveRedirect(session, Routes.otp), Routes.discover);
    });

    test('authenticated (complete) + onboarding route -> discover '
        '(bounced away, cannot redo onboarding)', () {
      final session = Authenticated(_account(onboardingComplete: true));
      expect(
        resolveRedirect(session, Routes.onboardingFirstStep),
        Routes.discover,
      );
    });

    // --- Treat missing onboarding info defensively as incomplete. ---
    test('authenticated with null onboarding -> treated as incomplete', () {
      const account = Account(id: 1, accountType: AccountType.individual);
      const session = Authenticated(account);
      expect(
        resolveRedirect(session, Routes.discover),
        Routes.onboardingFirstStep,
      );
    });
  });
}
