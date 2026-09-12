/// Compile-time app configuration, injected via
/// `--dart-define-from-file=config/<flavor>.json`.
///
/// `String.fromEnvironment`/`bool.fromEnvironment` are `const`, so values
/// are compile-time-folded (dead branches tree-shake) and there is no
/// async init to infect `dioProvider`. This is why the app does NOT use
/// `flutter_dotenv` (which ships the env file as an extractable asset
/// inside the APK and forces async init) — see plan §9.
abstract final class AppConfig {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const cableUrl = String.fromEnvironment('CABLE_URL');

  static const cableEnabled = bool.fromEnvironment('CABLE_ENABLED');
  static const refreshEnabled = bool.fromEnvironment('REFRESH_ENABLED');

  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
  static const googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );

  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  /// Fail loudly at startup rather than at the first request. Call this
  /// from `bootstrap.dart` before `runApp`.
  static void assertConfigured() {
    assert(
      apiBaseUrl.isNotEmpty,
      'API_BASE_URL is not set — pass '
      '--dart-define-from-file=config/<flavor>.json',
    );
  }
}
