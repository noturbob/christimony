import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme.dart';
import '../core/theme/theme_mode_controller.dart';
import '../dev/design_gallery.dart';

/// Root widget. The full `go_router` + session-gated route table
/// (`docs/mobile-v1-plan.md` §4.3) lands in a later pass — for now this
/// wires the theme system end-to-end against the Design Gallery so
/// Phase 2 has a genuinely runnable review surface.
class ChristimonyApp extends ConsumerWidget {
  const ChristimonyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp(
      title: 'Christimony',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      home: const DesignGalleryScreen(),
    );
  }
}
