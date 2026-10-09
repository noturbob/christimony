import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/network/error_text.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/conversation.dart';
import '../../ui/avatar.dart';
import '../../ui/cta_button.dart';
import '../../ui/states.dart';
import 'chat_data.dart';
import 'chat_format.dart';
import 'scrollable_empty.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider);

    Future<void> refresh() async {
      try {
        await ref.read(conversationsProvider.notifier).refresh();
      } on Object catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorText(e))));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: conversations.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(conversationsProvider),
        ),
        data: (list) => RefreshIndicator(
          onRefresh: refresh,
          child: list.isEmpty
              ? ScrollableEmpty(
                  child: EmptyView(
                    title: 'No conversations yet',
                    message: 'They start once you match with someone.',
                    action: CtaButton(
                      label: 'See your matches',
                      onPressed: () => context.go(Routes.matches),
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) => _ConversationRow(list[i]),
                ),
        ),
      ),
    );
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow(this.conversation);
  final ConversationSummary conversation;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final unread = c.unreadCount > 0;
    final text = Theme.of(context).textTheme;
    final last = c.lastMessage;

    return InkWell(
      onTap: () => context.go(Routes.thread(c.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Avatar(
                  name: c.otherProfile.name,
                  url: c.otherProfile.coverPhotoUrl,
                ),
                if (unread)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.otherProfile.name,
                    style: text.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    last?.body ?? 'Say hello 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: unread
                        ? text.bodyMedium?.copyWith(
                            color: AppColors.foreground,
                            fontWeight: FontWeight.w600,
                          )
                        : text.bodyMedium?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (last != null)
                  Text(
                    inboxTime(parseInstant(last.sentAt)),
                    style: text.labelSmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                if (unread) ...[
                  const SizedBox(height: 4),
                  Semantics(
                    label: '${c.unreadCount} unread',
                    child: ExcludeSemantics(
                      child: Badge.count(
                        count: c.unreadCount,
                        backgroundColor: AppColors.accent,
                        textColor: AppColors.accentForeground,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
