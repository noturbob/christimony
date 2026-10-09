import 'package:flutter/material.dart';

import '../../ui/states.dart';

// Placeholder -- replaced by the onboarding feature.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({required this.step, super.key});
  final String step;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: const EmptyView(title: 'Coming soon'),
  );
}
