import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../session/session.dart';
import '../session/session_controller.dart';
import '../storage/auth_token_holder.dart';
import 'cable_client.dart';

/// The seam screens depend on: server events plus whether they're arriving
/// live. When [live] is false (cable disabled, connecting, or dropped)
/// consumers poll instead, so they behave the same on either transport.
class RealtimeFeed {
  RealtimeFeed({required this.events, required this.live});

  RealtimeFeed.offline()
    : events = const Stream.empty(),
      live = ValueNotifier(false);

  /// `{"type": "message" | "match" | "introduction", ...}` per the contract.
  final Stream<Map<String, dynamic>> events;
  final ValueListenable<bool> live;
}

/// Whether the app is in the foreground (false from `paused` until
/// `resumed`).
final appForegroundProvider = NotifierProvider<AppForeground, bool>(
  AppForeground.new,
);

class AppForeground extends Notifier<bool> {
  @override
  bool build() {
    final listener = AppLifecycleListener(
      onPause: () => state = false,
      onResume: () => state = true,
    );
    ref.onDispose(listener.dispose);
    return true;
  }
}

/// The `AccountChannel` feed for the signed-in account. Connects only
/// while authenticated and foregrounded; logout tears it down.
final realtimeProvider = Provider<RealtimeFeed>((ref) {
  final signedIn = ref.watch(sessionProvider.select((s) => s is Authenticated));
  if (!AppConfig.cableEnabled || !signedIn) return RealtimeFeed.offline();

  final holder = ref.read(authTokenHolderProvider);
  final client = CableClient(
    url: Uri.parse(AppConfig.cableUrl),
    token: () => holder.token,
    onUnauthorized: () => holder.onUnauthenticated?.call(),
  );
  ref
    ..listen(
      appForegroundProvider,
      (_, foreground) => foreground ? client.start() : client.stop(),
      fireImmediately: true,
    )
    ..onDispose(client.dispose);
  return RealtimeFeed(events: client.events, live: client.live);
});
