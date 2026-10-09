import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router/routes.dart';
import '../../core/network/error_text.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/dates.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/match.dart';
import '../../ui/avatar.dart';
import '../../ui/cta_button.dart';
import '../../ui/states.dart';
import 'chat_data.dart';
import 'scrollable_empty.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(matchesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Your matches')),
      body: matches.when(
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView(error: e, onRetry: () => ref.invalidate(matchesProvider)),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(matchesProvider.future),
          child: list.isEmpty
              ? ScrollableEmpty(
                  child: EmptyView(
                    title: 'No matches yet',
                    message: 'Keep browsing — people who like you back show up here.',
                    action: CtaButton(
                      label: 'Browse profiles',
                      onPressed: () => context.go(Routes.discover),
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) => _MatchRow(match: list[i]),
                ),
        ),
      ),
    );
  }
}

class _MatchRow extends ConsumerStatefulWidget {
  const _MatchRow({required this.match});
  final MatchSummary match;

  @override
  ConsumerState<_MatchRow> createState() => _MatchRowState();
}

class _MatchRowState extends ConsumerState<_MatchRow> {
  var _opening = false;

  Future<void> _message() async {
    setState(() => _opening = true);
    try {
      final id = await openConversation(
        ref.read(christimonyApiProvider),
        widget.match.id,
      );
      if (mounted) context.go(Routes.thread(id));
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorText(e))));
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final other = widget.match.other;
    final matched = DateFormat.yMMMd().format(
      parseInstant(widget.match.matchedAt),
    );
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Avatar(name: other.name, url: other.coverPhotoUrl),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(other.name, style: text.titleMedium),
                Text(
                  [
                    if (other.city != null) other.city,
                    'Matched $matched',
                  ].join(' · '),
                  style: text.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: _opening ? null : _message,
            child: Text(_opening ? 'Opening...' : 'Message'),
          ),
        ],
      ),
    );
  }
}
