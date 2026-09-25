import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';

/// [AppConfig.assertConfigured] fails loudly here rather than at the first
/// network request.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.assertConfigured();

  runApp(const ProviderScope(child: ChristimonyApp()));
}
