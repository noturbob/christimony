import 'package:flutter/material.dart';

import '../ui/logo_mark.dart';

/// Shown only while the session restores on launch.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: LogoMark(size: 72)));
}
