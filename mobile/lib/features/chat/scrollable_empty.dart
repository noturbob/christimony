import 'package:flutter/material.dart';

/// Lets an empty state sit inside a `RefreshIndicator` and still be pulled.
class ScrollableEmpty extends StatelessWidget {
  const ScrollableEmpty({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: box.maxHeight),
        child: Center(child: child),
      ),
    ),
  );
}
