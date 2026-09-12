import '../../domain/models/account.dart';
import 'routes.dart';

/// The app's session states, as seen by the router guard.
///
/// Deliberately app-local (not the full `SessionController` state) so
/// this file has zero Flutter imports and [resolveRedirect] can be
/// exhaustively unit-tested as a pure truth table.
sealed class Session {
  const Session();
}

class SessionLoading extends Session {
  const SessionLoading();
}

class Unauthenticated extends Session {
  const Unauthenticated();
}

class Authenticated extends Session {
  const Authenticated(this.account);
  final Account account;
}

/// The mobile equivalent of `web/proxy.ts`, plus the onboarding branch the
/// web guard can't do (it only checks cookie *presence*; this has the
/// account in memory and can decide the whole thing in one place). See
/// `docs/mobile-v1-plan.md` §4.3.
///
/// Returns the path to redirect to, or null to allow navigation to
/// [location] as requested.
String? resolveRedirect(Session session, String location) {
  final isAuthRoute = location == Routes.login || location == Routes.otp;
  final isOnboardingRoute = location.startsWith(Routes.onboarding);
  final isSplash = location == Routes.splash;

  return switch (session) {
    SessionLoading() => isSplash ? null : Routes.splash,
    Unauthenticated() =>
      isAuthRoute
          ? null
          : '${Routes.login}?next=${Uri.encodeComponent(location)}',
    Authenticated(:final account) => _resolveAuthenticated(
      account,
      location,
      isSplash: isSplash,
      isAuthRoute: isAuthRoute,
      isOnboardingRoute: isOnboardingRoute,
    ),
  };
}

String? _resolveAuthenticated(
  Account account,
  String location, {
  required bool isSplash,
  required bool isAuthRoute,
  required bool isOnboardingRoute,
}) {
  final onboardingComplete = account.onboarding?.complete ?? false;

  if (isSplash) {
    return onboardingComplete ? Routes.discover : Routes.onboardingFirstStep;
  }
  if (!onboardingComplete) {
    return isOnboardingRoute ? null : Routes.onboardingFirstStep;
  }
  if (isAuthRoute || isOnboardingRoute) return Routes.discover;
  return null;
}
