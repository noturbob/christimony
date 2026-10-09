import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../ui/cta_button.dart';
import 'discover_controller.dart';

Future<void> showMatchSheet(BuildContext context, Matched match) {
  final router = GoRouter.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    builder: (sheet) {
      final text = Theme.of(sheet).textTheme;
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, size: 56, color: AppColors.primary),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: "It's a ",
                  children: [
                    TextSpan(
                      text: 'match.',
                      style: AppTypography.serifItalic(44)
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: text.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'You and ${match.profile.name} liked each other.',
                textAlign: TextAlign.center,
                style: text.bodyLarge?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 32),
              CtaButton(
                label: 'Say hello',
                onPressed: () {
                  Navigator.pop(sheet);
                  final id = match.conversationId;
                  router.go(id == null ? Routes.matches : Routes.thread(id));
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(sheet),
                child: const Text('Keep browsing'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
