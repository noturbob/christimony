import 'package:flutter/material.dart';

import '../../ui/states.dart';

// Placeholder -- replaced by the profile feature.
class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({required this.profileId, super.key});
  final int profileId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: const EmptyView(title: 'Coming soon'),
  );
}
