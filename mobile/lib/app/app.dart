import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
import '../dev/design_gallery.dart';

/// Root widget. The full `go_router` + session-gated route table
/// (`docs/mobile-v1-plan.md` §4.3) lands in a later pass -- for now this
/// renders the Design Gallery.
class ChristimonyApp extends StatelessWidget {
  const ChristimonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Christimony',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const DesignGalleryScreen(),
    );
  }
}
