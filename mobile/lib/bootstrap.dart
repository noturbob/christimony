import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/theme/theme_mode_controller.dart';

/// Preloads everything that must be synchronous by the time the widget
/// tree builds (see `docs/mobile-v1-plan.md` §3.6 and §4.4):
///
/// - [AppConfig.assertConfigured] fails loudly here rather than at the
///   first network request.
/// - `SharedPreferences` is awaited once and injected as an override, so
///   [ThemeModeController] and the onboarding draft never need an async
///   `build()` and the first frame never flashes the wrong theme.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.assertConfigured();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const ChristimonyApp(),
    ),
  );
}
