import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/tokens.dart';
import '../features/chat/chat_data.dart';

/// The five-tab bottom navigation. Each tab keeps its own navigation stack.
class AppShell extends ConsumerWidget {
  const AppShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadTotalProvider);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) {
          if (i == _messagesTab) {
            ref.read(conversationsProvider.notifier).refreshInBackground();
          }
          shell.goBranch(i, initialLocation: i == shell.currentIndex);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Discover',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: _unreadBadge(unread, const Icon(Icons.chat_bubble_outline)),
            selectedIcon: _unreadBadge(unread, const Icon(Icons.chat_bubble)),
            label: 'Messages',
            tooltip: unread > 0 ? 'Messages, $unread unread' : 'Messages',
          ),
          const NavigationDestination(
            icon: Icon(Icons.diversity_1_outlined),
            selectedIcon: Icon(Icons.diversity_1),
            label: 'Family',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static const _messagesTab = 2;

  static Widget _unreadBadge(int count, Widget icon) => Badge.count(
    count: count,
    isLabelVisible: count > 0,
    backgroundColor: AppColors.accent,
    textColor: AppColors.accentForeground,
    child: icon,
  );
}
