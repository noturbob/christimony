/// Every route path in one place, so `redirect.dart` and the `GoRouter`
/// table in `router.dart` can't drift apart.
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';

  /// `?phone=<E.164 or as typed>`
  static const otp = '/verify';

  static const onboarding = '/onboarding';
  static const onboardingFirstStep = '/onboarding/account-type';
  static String onboardingStep(String step) => '$onboarding/$step';

  // Bottom-nav tabs.
  static const discover = '/discover';
  static const matches = '/matches';
  static const messages = '/messages';
  static const family = '/introductions';
  static const profile = '/profile';

  // Full-screen pages pushed over the tabs.
  static String thread(int conversationId) => '$messages/$conversationId';
  static String profileDetail(int profileId) => '/profiles/$profileId';
  static String editProfile(int profileId) => '$profile/edit/$profileId';
  static const newProfile = '$profile/new';
  static const settings = '$profile/settings';
  static const blocked = '$profile/settings/blocked';
  static const verification = '$profile/verification';
  static const subscription = '$profile/subscription';
  static const gallery = '/dev/gallery';
}
