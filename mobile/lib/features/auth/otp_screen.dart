import 'package:flutter/material.dart';

import '../../ui/states.dart';

// Placeholder -- replaced by the auth feature.
class OtpScreen extends StatelessWidget {
  const OtpScreen({required this.phone, super.key});
  final String phone;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: const EmptyView(title: 'Coming soon'),
  );
}
