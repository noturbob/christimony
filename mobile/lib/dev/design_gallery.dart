import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../core/theme/typography.dart';
import '../ui/cta_button.dart';
import '../ui/logo_mark.dart';

/// Debug-only screen rendering every design token and the component kit
/// so far -- the review surface for `docs/mobile-v1-plan.md` Phase 2.
class DesignGalleryScreen extends StatelessWidget {
  const DesignGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            LogoMark(size: 28),
            SizedBox(width: 10),
            Text('Design Gallery'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionLabel('Typography'),
          Text('Display', style: text.displayMedium),
          Text('Headline', style: text.headlineMedium),
          Text('Title', style: text.titleLarge),
          Text('Body', style: text.bodyLarge),
          Text('Label', style: text.labelLarge),
          Text('Serif italic accent', style: AppTypography.serifItalic(22)),
          const SizedBox(height: 24),
          const _SectionLabel('Colours'),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Swatch('background', AppColors.background),
              _Swatch('card', AppColors.card),
              _Swatch('secondary', AppColors.secondary),
              _Swatch('border', AppColors.border),
              _Swatch('foreground', AppColors.foreground),
              _Swatch('muted fg', AppColors.mutedForeground),
              _Swatch('sage', AppColors.sage),
              _Swatch('gold', AppColors.gold),
              _Swatch('lilac', AppColors.lilac),
              _Swatch('blush', AppColors.blush),
              _Swatch('destructive', AppColors.destructive),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Radii'),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _RadiusBox('sm', AppRadii.sm),
              _RadiusBox('md', AppRadii.md),
              _RadiusBox('lg', AppRadii.lg),
              _RadiusBox('xl', AppRadii.xl),
              _RadiusBox('2xl', AppRadii.xl2),
              _RadiusBox('3xl', AppRadii.xl3),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Buttons'),
          CtaButton(label: 'Primary', onPressed: () {}),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () {}, child: const Text('Outline')),
          const SizedBox(height: 8),
          TextButton(onPressed: () {}, child: const Text('Link')),
          const SizedBox(height: 8),
          const CtaButton(label: 'Disabled', onPressed: null),
          const SizedBox(height: 24),
          const _SectionLabel('Card'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Card: 1px border, card fill, 2xl radius.',
                style: text.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Match celebration'),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      text: "It's a ",
                      children: [
                        TextSpan(
                          text: 'match.',
                          style: AppTypography.serifItalic(36)
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    style: text.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You and Anna liked each other.',
                    style: text.bodyMedium?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: AppColors.mutedForeground, letterSpacing: 0.5),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _RadiusBox extends StatelessWidget {
  const _RadiusBox(this.label, this.radius);
  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
