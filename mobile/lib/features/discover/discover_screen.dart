import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/network/error_text.dart';
import '../../core/theme/tokens.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/feed_page.dart';
import '../../domain/models/profile.dart';
import '../../ui/cta_button.dart';
import '../../ui/states.dart';
import 'discover_controller.dart';
import 'match_sheet.dart';
import 'profile_card.dart';
import 'swipe_card.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deck = ref.watch(deckProvider);
    final filters = deck.value?.filters;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Discover',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Filters',
                    icon: const Icon(Icons.tune),
                    onPressed: filters == null
                        ? null
                        : () => _openFilters(context, ref, filters),
                  ),
                ],
              ),
            ),
            const _BrowsingAs(),
            Expanded(
              child: switch (deck) {
                AsyncData(:final value) => _Deck(state: value),
                AsyncError(:final error) => ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(deckProvider),
                ),
                _ => const LoadingView(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _openFilters(
  BuildContext context,
  WidgetRef ref,
  FeedFilters current,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _FiltersSheet(
    initial: current,
    onApply: ref.read(feedFiltersProvider.notifier).set,
  ),
);

/// "Browsing as …" -- only when the account manages more than one active
/// profile.
class _BrowsingAs extends ConsumerWidget {
  const _BrowsingAs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = [
      for (final p in ref.watch(myProfilesProvider).value ?? <Profile>[])
        if (p.status == ProfileStatus.active) p,
    ];
    final current = ref.watch(browsingAsProvider).value;
    if (active.length < 2 || current == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: PopupMenuButton<int>(
          tooltip: 'Choose who you browse as',
          onSelected: ref.read(browsingAsIdProvider.notifier).set,
          itemBuilder: (_) => [
            for (final p in active)
              CheckedPopupMenuItem(
                value: p.id,
                checked: p.id == current.id,
                child: Text(p.name),
              ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              'Browsing as ${current.name} ▾',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.mutedForeground),
            ),
          ),
        ),
      ),
    );
  }
}

class _Deck extends ConsumerWidget {
  const _Deck({required this.state});

  final DeckState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.acting == null) {
      return EmptyView(
        title: 'One step first',
        message: 'Finish an active profile before you start browsing.',
        action: OutlinedButton(
          onPressed: () => context.go(Routes.profile),
          child: const Text('Go to Profile'),
        ),
      );
    }
    final queue = state.queue;
    if (queue.isEmpty) {
      if (state.nextAfterId != null) return const LoadingView();
      return EmptyView(
        title: "That's everyone for now",
        message: 'Check back soon, or try widening your filters.',
        action: OutlinedButton(
          onPressed: () => _openFilters(context, ref, state.filters),
          child: const Text('Adjust filters'),
        ),
      );
    }

    final top = queue.first;
    final topKey = GlobalObjectKey<SwipeCardState>(top);

    Future<void> onSwiped(Swipe direction) async {
      final deck = ref.read(deckProvider.notifier);
      final messenger = ScaffoldMessenger.of(context);
      try {
        if (direction == Swipe.pass) {
          await deck.pass();
        } else if (await deck.like() case final match? when context.mounted) {
          await showMatchSheet(context, match);
        }
      } on Object catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(errorText(e))));
      }
    }

    Future<void> undo() async {
      try {
        await ref.read(deckProvider.notifier).undo();
      } on Object catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorText(e))));
        }
      }
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (queue.length > 1)
                  IgnorePointer(
                    child: ExcludeSemantics(
                      child: Transform.translate(
                        offset: const Offset(0, 8), // Tailwind translate-y-2
                        child: Transform.scale(
                          scale: 0.96,
                          child: Opacity(
                            opacity: 0.7,
                            child: _CardFrame(
                              child: ProfileCardBody(profile: queue[1]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SwipeCard(
                  key: topKey,
                  onSwiped: onSwiped,
                  child: _CardFrame(
                    child: ProfileCardBody(
                      profile: top,
                      onOpen: () => context.push(Routes.profileDetail(top.id)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              if (state.undo != null)
                IconButton.outlined(
                  tooltip: 'Undo pass',
                  onPressed: undo,
                  icon: const Icon(Icons.undo),
                ),
              _RoundButton(
                tooltip: 'Pass',
                icon: Icons.close,
                onPressed: () => topKey.currentState?.swipe(Swipe.pass),
              ),
              _RoundButton(
                tooltip: 'Like',
                icon: Icons.favorite,
                gradient: true,
                onPressed: () => topKey.currentState?.swipe(Swipe.like),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardFrame extends StatelessWidget {
  const _CardFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.card,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(AppRadii.xl3 + 6),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.xl3 + 5),
      child: Material(type: MaterialType.transparency, child: child),
    ),
  );
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.gradient = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool gradient;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Semantics(
      button: true,
      label: tooltip,
      excludeSemantics: true,
      child: Material(
        shape: CircleBorder(
          side: gradient
              ? BorderSide.none
              : BorderSide(color: AppColors.foreground.withValues(alpha: 0.4)),
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: Ink(
          decoration: gradient
              ? const BoxDecoration(gradient: brandGradient)
              : null,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 64,
              child: Icon(
                icon,
                size: 26,
                color: gradient
                    ? AppColors.primaryForeground
                    : AppColors.mutedForeground,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet({required this.initial, required this.onApply});

  final FeedFilters initial;

  /// null = back to the defaults.
  final ValueChanged<FeedFilters?> onApply;

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  static const _minAge = 18.0;
  static const _maxAge = 70.0;

  late final _city = TextEditingController(text: widget.initial.city);
  late int? _denominationId = widget.initial.denominationId;
  late String _gender = widget.initial.gender ?? 'any';
  late RangeValues _ages = RangeValues(
    (widget.initial.minAge ?? _minAge).toDouble(),
    (widget.initial.maxAge ?? _maxAge).toDouble(),
  );

  @override
  void dispose() {
    _city.dispose();
    super.dispose();
  }

  void _apply() {
    widget.onApply(
      FeedFilters(
        city: _city.text.trim().isEmpty ? null : _city.text.trim(),
        denominationId: _denominationId,
        gender: _gender == 'any' ? null : _gender,
        minAge: _ages.start > _minAge ? _ages.start.round() : null,
        maxAge: _ages.end < _maxAge ? _ages.end.round() : null,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final denominations = ref.watch(denominationsProvider).value ?? [];
    final ages = _ages.start <= _minAge && _ages.end >= _maxAge
        ? 'Any age'
        : '${_ages.start.round()}–${_ages.end.round()}';
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Text('Filters', style: text.headlineMedium),
          TextField(
            controller: _city,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'City'),
          ),
          DropdownButtonFormField<int?>(
            initialValue: denominations.any((d) => d.id == _denominationId)
                ? _denominationId
                : null,
            decoration: const InputDecoration(labelText: 'Denomination'),
            isExpanded: true,
            items: [
              const DropdownMenuItem(child: Text('Any denomination')),
              for (final d in denominations)
                DropdownMenuItem(value: d.id, child: Text(d.name)),
            ],
            onChanged: (v) => setState(() => _denominationId = v),
          ),
          Text('Show me', style: text.titleSmall),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'female', label: Text('Women')),
              ButtonSegment(value: 'male', label: Text('Men')),
              ButtonSegment(value: 'any', label: Text('Everyone')),
            ],
            selected: {_gender},
            onSelectionChanged: (s) => setState(() => _gender = s.first),
          ),
          Text('Age · $ages', style: text.titleSmall),
          RangeSlider(
            values: _ages,
            min: _minAge,
            max: _maxAge,
            divisions: (_maxAge - _minAge).round(),
            labels: RangeLabels(
              '${_ages.start.round()}',
              '${_ages.end.round()}',
            ),
            onChanged: (v) => setState(() => _ages = v),
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onApply(null);
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
              ),
              Expanded(
                child: CtaButton(label: 'Apply', onPressed: _apply),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
