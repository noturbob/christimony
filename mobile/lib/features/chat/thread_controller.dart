import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../core/network/endpoints.dart';
import '../../core/realtime/realtime.dart';
import '../../core/session/session_controller.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/message.dart';
import 'chat_data.dart';

const messagesPageSize = 30;
const maxMessageLength = 2000;

/// Merge by id, so polling, realtime, "load earlier" and send responses can
/// overlap freely: no duplicates, and a re-fetched copy (say, now with
/// `read_at`) replaces the stale one.
List<Message> mergeMessages(List<Message> current, Iterable<Message> incoming) {
  final byId = {for (final m in current) m.id: m};
  for (final m in incoming) {
    byId[m.id] = m;
  }
  return byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
}

/// An optimistic bubble: sending until the server confirms it, then
/// replaced by the real [Message].
class PendingMessage {
  const PendingMessage({
    required this.localId,
    required this.body,
    this.failed = false,
  });

  final int localId;
  final String body;
  final bool failed;
}

class ThreadState {
  const ThreadState({
    this.messages = const [],
    this.pending = const [],
    this.hasEarlier = false,
    this.loadingEarlier = false,
    this.earlierFailed = false,
  });

  /// Confirmed messages, ascending by id.
  final List<Message> messages;
  final List<PendingMessage> pending;
  final bool hasEarlier;
  final bool loadingEarlier;
  final bool earlierFailed;

  ThreadState copyWith({
    List<Message>? messages,
    List<PendingMessage>? pending,
    bool? hasEarlier,
    bool? loadingEarlier,
    bool? earlierFailed,
  }) => ThreadState(
    messages: messages ?? this.messages,
    pending: pending ?? this.pending,
    hasEarlier: hasEarlier ?? this.hasEarlier,
    loadingEarlier: loadingEarlier ?? this.loadingEarlier,
    earlierFailed: earlierFailed ?? this.earlierFailed,
  );
}

final AsyncNotifierProviderFamily<ThreadController, ThreadState, int>
threadProvider = AsyncNotifierProvider.autoDispose
    .family<ThreadController, ThreadState, int>(ThreadController.new);

/// One open thread. New messages arrive by realtime events when the cable
/// is live, else by polling every 5s; either way they fold through
/// [mergeMessages]. On (re)connect or resume it re-fetches from the newest
/// page back to what it already has, so a dropped socket leaves no gap.
class ThreadController extends AsyncNotifier<ThreadState> {
  ThreadController(this.conversationId);

  final int conversationId;

  static const pollEvery = Duration(seconds: 5);

  /// While the cable is live, still poll this often (in ticks) -- the
  /// cable carries no read-receipt event.
  static const _liveReceiptTicks = 6;

  var _nextLocalId = 0;
  var _ticks = 0;
  var _catchingUp = false;

  ChristimonyApi get _api => ref.read(christimonyApiProvider);
  int? get _me => ref.read(currentAccountProvider)?.id;
  bool get _foreground => ref.read(appForegroundProvider);

  @override
  Future<ThreadState> build() async {
    final feed = ref.watch(realtimeProvider);
    final sub = feed.events
        .where((e) => e['type'] == 'message')
        .map((e) => Message.fromJson(e['message'] as Map<String, dynamic>))
        .where((m) => m.conversationId == conversationId)
        .listen((m) => _receive([m]));
    void onLive() {
      if (feed.live.value) unawaited(_catchUp());
    }

    feed.live.addListener(onLive);
    final timer = Timer.periodic(pollEvery, (_) {
      _ticks++;
      if (_foreground &&
          (!feed.live.value || _ticks % _liveReceiptTicks == 0)) {
        unawaited(_catchUp());
      }
    });
    ref
      ..listen(appForegroundProvider, (_, foreground) {
        if (foreground) unawaited(_catchUp());
      })
      ..onDispose(() {
        unawaited(sub.cancel());
        feed.live.removeListener(onLive);
        timer.cancel();
      });

    final page = await _page();
    _markReadIfNeeded(page);
    return ThreadState(
      messages: page,
      hasEarlier: page.length == messagesPageSize,
    );
  }

  Future<List<Message>> _page({int? beforeId}) => _api.send(
    Api.listMessages,
    pathArgs: {'cid': conversationId},
    query: {'limit': messagesPageSize, 'before_id': ?beforeId},
    decode: (json) => [
      for (final m in json! as List)
        Message.fromJson(m as Map<String, dynamic>),
    ],
  );

  void _update(ThreadState Function(ThreadState) change) {
    final current = state.value;
    if (ref.mounted && current != null) state = AsyncData(change(current));
  }

  Future<void> _catchUp() async {
    final known = state.value?.messages.lastOrNull?.id;
    if (state.value == null || _catchingUp) return;
    _catchingUp = true;
    try {
      var page = await _page();
      final fetched = [...page];
      while (known != null &&
          page.length == messagesPageSize &&
          page.first.id > known) {
        page = await _page(beforeId: page.first.id);
        fetched.addAll(page);
      }
      if (ref.mounted) _receive(fetched);
    } on Object {
      // The next tick or reconnect tries again.
    } finally {
      _catchingUp = false;
    }
  }

  void _receive(List<Message> incoming) {
    _update((s) {
      // My own message can come back (realtime echo, or a poll) before the
      // send response: retire the matching optimistic bubble now.
      final pending = [...s.pending];
      final known = {for (final m in s.messages) m.id};
      for (final m in incoming) {
        if (m.senderAccountId != _me || known.contains(m.id)) continue;
        final i = pending.indexWhere((p) => !p.failed && p.body == m.body);
        if (i >= 0) pending.removeAt(i);
      }
      return s.copyWith(
        messages: mergeMessages(s.messages, incoming),
        pending: pending,
      );
    });
    _markReadIfNeeded(incoming);
  }

  void _markReadIfNeeded(List<Message> batch) {
    final me = _me;
    if (!_foreground ||
        !batch.any((m) => m.senderAccountId != me && m.readAt == null)) {
      return;
    }
    unawaited(
      _api
          .send<void>(
            Api.markRead,
            pathArgs: {'cid': conversationId},
            decode: (_) {},
          )
          .then((_) {
            // Refresh the inbox/badge if it's alive; never create it here.
            if (ref.mounted && ref.exists(conversationsProvider)) {
              ref.read(conversationsProvider.notifier).refreshInBackground();
            }
          })
          .catchError((Object _) {}),
    );
  }

  Future<void> loadEarlier() async {
    final s = state.value;
    if (s == null || !s.hasEarlier || s.loadingEarlier || s.messages.isEmpty) {
      return;
    }
    _update((s) => s.copyWith(loadingEarlier: true, earlierFailed: false));
    try {
      final older = await _page(beforeId: s.messages.first.id);
      _update(
        (s) => s.copyWith(
          messages: mergeMessages(s.messages, older),
          hasEarlier: older.length == messagesPageSize,
          loadingEarlier: false,
        ),
      );
    } on Object {
      _update((s) => s.copyWith(loadingEarlier: false, earlierFailed: true));
    }
  }

  Future<void> send(String text) async {
    final body = text.trim();
    if (body.isEmpty || body.length > maxMessageLength) return;
    final pending = PendingMessage(localId: _nextLocalId++, body: body);
    _update((s) => s.copyWith(pending: [...s.pending, pending]));
    await _post(pending);
  }

  Future<void> retry(PendingMessage failed) async {
    final again = PendingMessage(localId: failed.localId, body: failed.body);
    _swapPending(again);
    await _post(again);
  }

  void _swapPending(PendingMessage replacement) => _update(
    (s) => s.copyWith(
      pending: [
        for (final p in s.pending)
          if (p.localId == replacement.localId) replacement else p,
      ],
    ),
  );

  Future<void> _post(PendingMessage p) async {
    try {
      final message = await _api.send(
        Api.createMessage,
        pathArgs: {'cid': conversationId},
        fields: {'body': p.body},
        decode: (json) => Message.fromJson(json! as Map<String, dynamic>),
      );
      _update(
        (s) => s.copyWith(
          messages: mergeMessages(s.messages, [message]),
          pending: s.pending.where((x) => x.localId != p.localId).toList(),
        ),
      );
    } on Object {
      _swapPending(
        PendingMessage(localId: p.localId, body: p.body, failed: true),
      );
    }
  }
}
