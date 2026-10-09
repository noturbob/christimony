import 'package:flutter/material.dart';

import '../../ui/states.dart';

// Placeholder -- replaced by the discover feature.
class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({required this.profileId, super.key});
  final int profileId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: const EmptyView(title: 'Coming soon'),
  );
}
