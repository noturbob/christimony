import 'package:flutter/material.dart';

import '../core/network/error_text.dart';
import '../core/theme/tokens.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
  );
}

/// A failed load with a way to try again.
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _Centered(
    children: [
      Text(
        errorText(error),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      const SizedBox(height: 16),
      OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
    ],
  );
}

/// Nothing to show yet, with an optional next step.
class EmptyView extends StatelessWidget {
  const EmptyView({required this.title, this.message, this.action, super.key});

  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return _Centered(
      children: [
        Text(title, textAlign: TextAlign.center, style: text.headlineSmall),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
        if (action != null) ...[const SizedBox(height: 20), action!],
      ],
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    ),
  );
}
