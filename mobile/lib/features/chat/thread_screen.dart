import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/session/session_controller.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/message.dart';
import '../../domain/models/profile.dart';
import '../../ui/avatar.dart';
import '../../ui/states.dart';
import 'chat_data.dart';
import 'chat_format.dart';
import 'safety_dialogs.dart';
import 'thread_controller.dart';

class ThreadScreen extends ConsumerWidget {
  const ThreadScreen({required this.conversationId, super.key});
  final int conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final header = ref.watch(threadConversationProvider(conversationId));
    if (header case AsyncData(value: null)) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyView(
          title: "This conversation isn't available.",
          action: OutlinedButton(
            onPressed: () => context.go(Routes.messages),
            child: const Text('Back to Messages'),
          ),
        ),
      );
    }

    final other = header.value?.otherProfile;
    final loaded = ref.watch(threadProvider(conversationId)).hasValue;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: other == null ? null : _Title(other),
        actions: [if (other != null) _Menu(other)],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(child: _Messages(conversationId)),
            _Composer(conversationId, enabled: loaded),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.other);
  final ProfileSummary other;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push(Routes.profileDetail(other.id)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Avatar(name: other.name, url: other.coverPhotoUrl, size: 36),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              other.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

enum _Action { profile, report, block }

class _Menu extends ConsumerWidget {
  const _Menu(this.other);
  final ProfileSummary other;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void blocked() {
      ref.read(conversationsProvider.notifier).refreshInBackground();
      if (context.mounted) context.go(Routes.messages);
    }

    return PopupMenuButton<_Action>(
      tooltip: 'More options',
      onSelected: (action) async {
        switch (action) {
          case _Action.profile:
            unawaited(context.push(Routes.profileDetail(other.id)));
          case _Action.report:
            if (await showReport(context, other)) blocked();
          case _Action.block:
            if (await confirmBlock(context, other)) blocked();
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: _Action.profile, child: Text('View profile')),
        PopupMenuItem(value: _Action.report, child: Text('Report')),
        PopupMenuItem(value: _Action.block, child: Text('Block')),
      ],
    );
  }
}

class _Messages extends ConsumerWidget {
  const _Messages(this.conversationId);
  final int conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = threadProvider(conversationId);
    final me = ref.watch(currentAccountProvider)?.id;

    return ref
        .watch(provider)
        .when(
          loading: () => const LoadingView(),
          error: (e, _) =>
              ErrorView(error: e, onRetry: () => ref.invalidate(provider)),
          data: (s) {
            if (s.messages.isEmpty && s.pending.isEmpty) {
              return const EmptyView(
                title: 'Say hello',
                message: 'This is the start of your conversation.',
              );
            }
            final items = _items(s, me, ref.read(provider.notifier));
            final top = s.hasEarlier ? 1 : 0;
            return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: items.length + top,
              itemBuilder: (_, i) => i == items.length
                  ? _Earlier(s, ref.read(provider.notifier).loadEarlier)
                  : items[items.length - 1 - i],
            );
          },
        );
  }

  /// Oldest first; the list renders it reversed so it sticks to the bottom.
  static List<Widget> _items(ThreadState s, int? me, ThreadController c) {
    final items = <Widget>[];
    final lastMine = s.messages.lastIndexWhere((m) => m.senderAccountId == me);
    DateTime? previous;
    for (final (i, m) in s.messages.indexed) {
      final sent = parseInstant(m.sentAt);
      if (previous == null || !sameDay(previous, sent)) {
        items.add(_DaySeparator(dayLabel(sent)));
      }
      previous = sent;
      items.add(_Bubble.sent(m, mine: m.senderAccountId == me));
      if (i == lastMine && m.readAt != null) items.add(const _ReadMark());
    }
    if (s.pending.isNotEmpty &&
        (previous == null || !sameDay(previous, DateTime.now()))) {
      items.add(_DaySeparator(dayLabel(DateTime.now())));
    }
    for (final p in s.pending) {
      items.add(_Bubble.pending(p, onRetry: () => c.retry(p)));
    }
    return items;
  }
}

/// Sits at the top of the history; loads the previous page as soon as it's
/// built (i.e. scrolled near), or offers a retry if that failed.
class _Earlier extends StatelessWidget {
  const _Earlier(this.state, this.load);
  final ThreadState state;
  final Future<void> Function() load;

  @override
  Widget build(BuildContext context) {
    if (state.earlierFailed) {
      return Center(
        child: TextButton(
          onPressed: load,
          child: const Text('Load earlier messages'),
        ),
      );
    }
    if (!state.loadingEarlier) {
      WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(load()));
    }
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      label.toUpperCase(),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: AppColors.mutedForeground, letterSpacing: 0.6),
    ),
  );
}

class _ReadMark extends StatelessWidget {
  const _ReadMark();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 2, right: 4),
    child: Text(
      'Read',
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: AppColors.mutedForeground),
    ),
  );
}

class _Bubble extends StatelessWidget {
  _Bubble.sent(Message m, {required this.mine})
    : body = m.body,
      meta = timeLabel(parseInstant(m.sentAt)),
      failed = false,
      sending = false,
      onRetry = null;

  _Bubble.pending(PendingMessage p, {required this.onRetry})
    : body = p.body,
      meta = p.failed ? null : 'Sending...',
      mine = true,
      failed = p.failed,
      sending = !p.failed;

  static const _radius = Radius.circular(21.6);
  static const _tail = Radius.circular(7.2);

  final String body;
  final String? meta;
  final bool mine;
  final bool failed;
  final bool sending;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final fg = mine ? AppColors.primaryForeground : AppColors.foreground;
    Widget bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: mine ? AppColors.primary : AppColors.secondary,
        borderRadius: BorderRadius.only(
          topLeft: _radius,
          topRight: _radius,
          bottomLeft: mine ? _radius : _tail,
          bottomRight: mine ? _tail : _radius,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            widthFactor: 1,
            child: Text(body, style: text.bodyMedium?.copyWith(color: fg)),
          ),
          if (meta != null) ...[
            const SizedBox(height: 2),
            Text(
              meta!,
              style: text.labelSmall?.copyWith(
                fontSize: 10,
                color: fg.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
    if (sending || failed) bubble = Opacity(opacity: 0.6, child: bubble);
    if (failed) {
      bubble = Semantics(
        button: true,
        label: 'Message not sent. Tap to retry.',
        child: InkWell(
          onTap: onRetry,
          borderRadius: const BorderRadius.all(_radius),
          child: bubble,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: mine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          bubble,
          if (failed)
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 4),
              child: Text(
                'Not sent · Tap to retry',
                style: text.labelSmall?.copyWith(color: AppColors.destructive),
              ),
            ),
        ],
      ),
    );
  }
}

class _Composer extends ConsumerStatefulWidget {
  const _Composer(this.conversationId, {required this.enabled});
  final int conversationId;
  final bool enabled;

  @override
  ConsumerState<_Composer> createState() => _ComposerState();
}

class _ComposerState extends ConsumerState<_Composer> {
  final _draft = TextEditingController();

  @override
  void initState() {
    super.initState();
    _draft.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  void _send() {
    final text = _draft.text;
    _draft.clear();
    unawaited(
      ref.read(threadProvider(widget.conversationId).notifier).send(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSend = widget.enabled && _draft.text.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _draft,
              maxLength: maxMessageLength,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Write a message...',
                counterText: '',
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Send',
            onPressed: canSend ? _send : null,
            color: AppColors.primary,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
