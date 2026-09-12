import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Breaks the circular dependency between Dio (needs a token on every
/// request) and the session controller (needs Dio to call `/me`).
///
/// This is a mutable holder with STABLE IDENTITY — `dioProvider` watches
/// the provider that exposes this object, not its field values, so Dio is
/// constructed exactly once for the app's lifetime. If `dioProvider`
/// instead watched session state directly, every login/logout would
/// rebuild Dio and orphan in-flight requests and their `CancelToken`s.
/// See `docs/mobile-v1-plan.md` §4.2.
class AuthTokenHolder {
  String? token;

  /// Invoked by `AuthInterceptor` at most once per session when a
  /// non-public request comes back `Unauthorized`. Wired by
  /// `SessionController` to its force-logout path. No navigation happens
  /// here — the router's redirect guard reacts to the resulting session
  /// state change, mirroring how the web's `apiFetch` does a hard
  /// navigation on 401 rather than a soft push.
  void Function()? onUnauthenticated;
}

final authTokenHolderProvider = Provider<AuthTokenHolder>((ref) {
  return AuthTokenHolder();
});
