import 'package:flutter/material.dart';

import '../../ui/states.dart';

// Placeholder -- replaced by the chat feature.
class ThreadScreen extends StatelessWidget {
  const ThreadScreen({required this.conversationId, super.key});
  final int conversationId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: const EmptyView(title: 'Coming soon'),
  );
}
