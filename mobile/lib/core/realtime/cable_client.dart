import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'cable_protocol.dart';

/// A hand-rolled ActionCable client subscribed to `AccountChannel`
/// (plan §4.5): reconnects with jittered backoff, treats two missed pings
/// as a dead socket, and stops for good on an `unauthorized` disconnect.
class CableClient {
  CableClient({
    required this.url,
    required this.token,
    this.onUnauthorized,
    WebSocketChannel Function(Uri)? connect,
    Random? random,
  }) : _connect = connect ?? WebSocketChannel.connect,
       _random = random ?? Random();

  final Uri url;
  final String? Function() token;
  final VoidCallback? onUnauthorized;
  final WebSocketChannel Function(Uri) _connect;
  final Random _random;

  static const _watchdogEvery = Duration(seconds: 3);
  static const _staleAfter = Duration(seconds: 6);

  final _events = StreamController<Map<String, dynamic>>.broadcast();

  /// Decoded `AccountChannel` broadcasts (`{"type": "message", ...}`).
  Stream<Map<String, dynamic>> get events => _events.stream;

  /// True only while subscribed -- consumers poll whenever this is false.
  final ValueNotifier<bool> live = ValueNotifier(false);

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _retry;
  Timer? _watchdog;
  var _attempt = 0;
  var _running = false;
  var _lastFrame = DateTime.now();

  void start() {
    if (_running) return;
    _running = true;
    _open();
  }

  void stop() {
    _running = false;
    _teardown();
  }

  void dispose() {
    stop();
    unawaited(_events.close());
    live.dispose();
  }

  void _open() {
    final jwt = token();
    if (jwt == null) return stop();

    final channel = _connect(
      url.replace(queryParameters: {...url.queryParameters, 'token': jwt}),
    );
    _channel = channel;
    _lastFrame = DateTime.now();
    // A failed handshake also errors the stream; this just keeps the
    // `ready` future's error from going unhandled.
    unawaited(channel.ready.then((_) {}, onError: (_) {}));
    _sub = channel.stream.listen(
      _onFrame,
      onError: (_) => _dropped(),
      onDone: _dropped,
    );
    _watchdog = Timer.periodic(_watchdogEvery, (_) {
      if (DateTime.now().difference(_lastFrame) > _staleAfter) _dropped();
    });
  }

  void _onFrame(dynamic raw) {
    _lastFrame = DateTime.now();
    switch (parseCableFrame(raw)) {
      case CableWelcome():
        _attempt = 0;
        _channel?.sink.add(subscribeCommand(accountChannelIdentifier));
      case CableConfirmed(:final identifier)
          when identifier == accountChannelIdentifier:
        live.value = true;
      case CableMessage(:final identifier, :final message)
          when identifier == accountChannelIdentifier:
        _events.add(message);
      case CableRejected():
        stop();
      case CableDisconnect(:final reason, :final reconnect):
        if (reason == 'unauthorized') {
          stop();
          onUnauthorized?.call();
        } else if (reconnect) {
          _dropped();
        } else {
          stop();
        }
      case _:
        break;
    }
  }

  void _dropped() {
    _teardown();
    if (!_running) return;
    _retry = Timer(cableBackoff(_attempt++, _random.nextDouble()), _open);
  }

  void _teardown() {
    live.value = false;
    _retry?.cancel();
    _watchdog?.cancel();
    unawaited(_sub?.cancel());
    unawaited(_channel?.sink.close());
    _sub = null;
    _channel = null;
  }
}
