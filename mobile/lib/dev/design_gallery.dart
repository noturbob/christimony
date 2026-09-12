import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/motion.dart';
import '../core/theme/theme_mode_controller.dart';
import '../core/theme/tokens.dart';

/// Debug-only screen rendering every design-system token and a first
/// pass at the component kit, with a light/dark switch. This is the
/// Phase 2 review surface described in `docs/mobile-v1-plan.md` §3.4,
/// and the fixture set golden tests will render against once
/// `lib/ui/` grows real components.
class DesignGalleryScreen extends ConsumerWidget {
  const DesignGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final c = context.c;
    final r = context.r;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Gallery'),
        actions: [
          IconButton(
            icon: Icon(switch (themeMode) {
              ThemeMode.light => Icons.light_mode,
              ThemeMode.dark => Icons.dark_mode,
              ThemeMode.system => Icons.brightness_auto,
            }),
            tooltip: 'Cycle theme mode',
            onPressed: () async {
              final next = switch (themeMode) {
                ThemeMode.system => ThemeMode.light,
                ThemeMode.light => ThemeMode.dark,
                ThemeMode.dark => ThemeMode.system,
              };
              await ref.read(themeModeControllerProvider.notifier).set(next);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Theme mode: ${themeMode.name}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Typography'),
          Text('Display', style: Theme.of(context).textTheme.displayMedium),
          Text('Headline', style: Theme.of(context).textTheme.headlineMedium),
          Text('Title', style: Theme.of(context).textTheme.titleLarge),
          Text('Body', style: Theme.of(context).textTheme.bodyLarge),
          Text('Label', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 24),
          const _SectionLabel('Colors'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Swatch('background', c.background),
              _Swatch('foreground', c.foreground),
              _Swatch('card', c.card),
              _Swatch('primary', c.primary),
              _Swatch('secondary', c.secondary),
              _Swatch('muted', c.muted),
              _Swatch('accent', c.accent),
              _Swatch('destructive', c.destructive),
              _Swatch('celebration', c.celebration),
              _Swatch('peach', c.peach),
              _Swatch('blush', c.blush),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Radii'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _RadiusBox('sm', r.sm, c),
              _RadiusBox('md', r.md, c),
              _RadiusBox('lg', r.lg, c),
              _RadiusBox('xl', r.xl, c),
              _RadiusBox('2xl', r.xl2, c),
              _RadiusBox('3xl', r.xl3, c),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Buttons'),
          FilledButton(onPressed: () {}, child: const Text('Primary')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () {}, child: const Text('Outline')),
          const SizedBox(height: 8),
          TextButton(onPressed: () {}, child: const Text('Link')),
          const SizedBox(height: 8),
          const FilledButton(onPressed: null, child: Text('Disabled')),
          const SizedBox(height: 24),
          const _SectionLabel('Cards'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'AppCard — radius 21.6, 1px border, card fill.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.secondary.withValues(alpha: 0.4),
              borderRadius: r.xl2Radius,
            ),
            child: Text(
              'SectionBlock — secondary @40%, used for prompt/About/'
              ' Education blocks on the profile card.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Match celebration overlay'),
          AnimatedContainer(
            duration: Motion.base,
            height: 160,
            decoration: BoxDecoration(
              color: c.celebration,
              borderRadius: r.xl2Radius,
            ),
            alignment: Alignment.center,
            child: Text(
              "It's a match!",
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: c.onCelebration),
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
            ?.copyWith(color: context.c.mutedForeground, letterSpacing: 0.5),
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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.c.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _RadiusBox extends StatelessWidget {
  const _RadiusBox(this.label, this.radius, this.colors);
  final String label;
  final double radius;
  final ChristimonyColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
