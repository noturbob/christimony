/// Every route path in one place, so `redirect.dart` and the actual
/// `GoRouter` route table can't drift apart.
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const otp = '/verify';

  static const onboarding = '/onboarding';
  static const onboardingFirstStep = '/onboarding/account-type';

  static const discover = '/discover';
  static const matches = '/matches';
  static const messages = '/messages';
  static const family = '/introductions';
  static const profile = '/profile';
}
