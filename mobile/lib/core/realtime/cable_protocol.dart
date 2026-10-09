import 'dart:convert';
import 'dart:math';

/// The ActionCable wire protocol, kept pure so it's unit-testable without
/// a socket. See `docs/mobile-v1-plan.md` §4.5.

/// Rails echoes `identifier` back byte-for-byte as the routing key, so it
/// is built once and compared as a string, never rebuilt ad hoc.
final String accountChannelIdentifier = jsonEncode({
  'channel': 'AccountChannel',
});

String subscribeCommand(String identifier) =>
    jsonEncode({'command': 'subscribe', 'identifier': identifier});

sealed class CableFrame {
  const CableFrame();
}

class CableWelcome extends CableFrame {
  const CableWelcome();
}

class CablePing extends CableFrame {
  const CablePing();
}

class CableConfirmed extends CableFrame {
  const CableConfirmed(this.identifier);
  final String identifier;
}

class CableRejected extends CableFrame {
  const CableRejected(this.identifier);
  final String identifier;
}

class CableDisconnect extends CableFrame {
  const CableDisconnect({required this.reason, required this.reconnect});
  final String? reason;
  final bool reconnect;
}

class CableMessage extends CableFrame {
  const CableMessage(this.identifier, this.message);
  final String identifier;
  final Map<String, dynamic> message;
}

/// Anything unparseable or not worth acting on.
class CableIgnored extends CableFrame {
  const CableIgnored();
}

CableFrame parseCableFrame(Object? raw) {
  final Object? json;
  try {
    json = raw is String ? jsonDecode(raw) : null;
  } on FormatException {
    return const CableIgnored();
  }
  if (json is! Map<String, dynamic>) return const CableIgnored();

  final identifier = json['identifier'];
  return switch (json['type']) {
    'welcome' => const CableWelcome(),
    'ping' => const CablePing(),
    'confirm_subscription' when identifier is String => CableConfirmed(
      identifier,
    ),
    'reject_subscription' when identifier is String => CableRejected(
      identifier,
    ),
    'disconnect' => CableDisconnect(
      reason: json['reason'] as String?,
      reconnect: json['reconnect'] != false,
    ),
    null when identifier is String && json['message'] is Map<String, dynamic> =>
      CableMessage(identifier, json['message'] as Map<String, dynamic>),
    _ => const CableIgnored(),
  };
}

/// `min(30s, 500ms · 2^attempt)` with ±30% jitter, so a server restart
/// doesn't get every client back in the same instant. [jitter] is in [0, 1).
Duration cableBackoff(int attempt, double jitter) {
  final base = min(30000, 500 * pow(2, min(attempt, 10)));
  return Duration(milliseconds: (base * (0.7 + 0.6 * jitter)).round());
}
