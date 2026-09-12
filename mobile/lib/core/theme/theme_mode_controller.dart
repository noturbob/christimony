import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'theme_mode';

/// Preloaded in `bootstrap.dart` and overridden on the [ProviderScope] so
/// [ThemeModeController] can read it synchronously — otherwise the first
/// frame flashes the wrong theme while prefs load asynchronously.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() after '
    'SharedPreferences.getInstance() resolves.',
  );
});

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

/// Persists the user's theme choice (System/Light/Dark) across restarts.
/// Defaults to [ThemeMode.system] so the app follows the OS setting,
/// including live toggles, until the user picks one explicitly from
/// Settings.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final stored = ref.read(sharedPreferencesProvider).getString(_prefsKey);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_prefsKey, mode.name);
  }
}
