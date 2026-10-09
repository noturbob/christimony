import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/session_controller.dart';
import '../../dev/design_gallery.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/chat/inbox_screen.dart';
import '../../features/chat/matches_screen.dart';
import '../../features/chat/thread_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/discover/profile_detail_screen.dart';
import '../../features/family/family_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/blocked_screen.dart';
import '../../features/profile/profile_create_screen.dart';
import '../../features/profile/profile_edit_screen.dart';
import '../../features/profile/profile_hub_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/profile/subscription_screen.dart';
import '../../features/profile/verification_screen.dart';
import '../shell.dart';
import '../splash_screen.dart';
import 'redirect.dart';
import 'routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

int _id(GoRouterState s, [String name = 'id']) =>
    int.parse(s.pathParameters[name]!);

final routerProvider = Provider<GoRouter>((ref) {
  // The guard re-runs whenever the session changes (login, logout,
  // onboarding completed), so navigation follows auth state on its own.
  final sessionChanged = ValueNotifier(0);
  ref.listen(sessionProvider, (_, _) => sessionChanged.value++);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: sessionChanged,
    redirect: (_, state) =>
        resolveRedirect(ref.read(sessionProvider), state.uri.path),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: Routes.otp,
        builder: (_, s) =>
            OtpScreen(phone: s.uri.queryParameters['phone'] ?? ''),
      ),
      GoRoute(
        path: Routes.onboarding,
        redirect: (_, _) => Routes.onboardingFirstStep,
      ),
      GoRoute(
        path: '${Routes.onboarding}/:step',
        builder: (_, s) => OnboardingScreen(step: s.pathParameters['step']!),
      ),
      GoRoute(
        path: '/profiles/:id',
        builder: (_, s) => ProfileDetailScreen(profileId: _id(s)),
      ),
      if (kDebugMode)
        GoRoute(
          path: Routes.gallery,
          builder: (_, _) => const DesignGalleryScreen(),
        ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          _tab(Routes.discover, const DiscoverScreen()),
          _tab(Routes.matches, const MatchesScreen()),
          _tab(
            Routes.messages,
            const InboxScreen(),
            routes: [_page(':id', (s) => ThreadScreen(conversationId: _id(s)))],
          ),
          _tab(Routes.family, const FamilyScreen()),
          _tab(
            Routes.profile,
            const ProfileHubScreen(),
            routes: [
              _page('edit/:id', (s) => ProfileEditScreen(profileId: _id(s))),
              _page('new', (_) => const ProfileCreateScreen()),
              _page(
                'settings',
                (_) => const SettingsScreen(),
                routes: [_page('blocked', (_) => const BlockedScreen())],
              ),
              _page('verification', (_) => const VerificationScreen()),
              _page('subscription', (_) => const SubscriptionScreen()),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    sessionChanged.dispose();
    router.dispose();
  });
  return router;
});

StatefulShellBranch _tab(
  String path,
  Widget screen, {
  List<RouteBase> routes = const [],
}) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (_, _) => screen, routes: routes)],
);

/// A full-screen page over the tab bar.
GoRoute _page(
  String path,
  Widget Function(GoRouterState) build, {
  List<RouteBase> routes = const [],
}) => GoRoute(
  path: path,
  parentNavigatorKey: rootNavigatorKey,
  builder: (_, s) => build(s),
  routes: routes,
);
