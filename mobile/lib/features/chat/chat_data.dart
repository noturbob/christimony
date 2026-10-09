import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../core/network/endpoints.dart';
import '../../core/realtime/realtime.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/conversation.dart';
import '../../domain/models/match.dart';

List<T> _list<T>(Object? json, T Function(Map<String, dynamic>) from) => [
  for (final item in json! as List) from(item as Map<String, dynamic>),
];

final FutureProvider<List<MatchSummary>> matchesProvider =
    FutureProvider.autoDispose<List<MatchSummary>>((ref) {
      final sub = ref
          .watch(realtimeProvider)
          .events
          .where((e) => e['type'] == 'match')
          .listen((_) => ref.invalidateSelf());
      ref.onDispose(sub.cancel);
      return ref
          .read(christimonyApiProvider)
          .send(
            Api.listMatches,
            decode: (json) => _list(json, MatchSummary.fromJson),
          );
    });

/// `POST /conversations` is idempotent: returns the match's conversation,
/// creating it on first use.
Future<int> openConversation(ChristimonyApi api, int matchId) => api.send(
  Api.createConversation,
  fields: {'match_id': matchId},
  decode: (json) => (json! as Map<String, dynamic>)['id'] as int,
);

final AsyncNotifierProvider<ConversationsController, List<ConversationSummary>>
conversationsProvider =
    AsyncNotifierProvider.autoDispose<
      ConversationsController,
      List<ConversationSummary>
    >(ConversationsController.new);

/// The inbox list, also the source of the Messages tab badge. Refreshes on
/// realtime message/match events, on resume and cable reconnect, and polls
/// every 15s while the app is foregrounded and the cable isn't live.
class ConversationsController extends AsyncNotifier<List<ConversationSummary>> {
  static const pollEvery = Duration(seconds: 15);

  @override
  Future<List<ConversationSummary>> build() {
    final feed = ref.watch(realtimeProvider);
    final sub = feed.events
        .where((e) => e['type'] == 'message' || e['type'] == 'match')
        .listen((_) => refreshInBackground());
    void onLive() {
      if (feed.live.value) refreshInBackground();
    }

    feed.live.addListener(onLive);
    final timer = Timer.periodic(pollEvery, (_) {
      if (!feed.live.value && ref.read(appForegroundProvider)) {
        refreshInBackground();
      }
    });
    ref
      ..listen(appForegroundProvider, (_, foreground) {
        if (foreground) refreshInBackground();
      })
      ..onDispose(() {
        unawaited(sub.cancel());
        feed.live.removeListener(onLive);
        timer.cancel();
      });
    return _fetch();
  }

  Future<List<ConversationSummary>> _fetch() => ref
      .read(christimonyApiProvider)
      .send(
        Api.listConversations,
        decode: (json) => _list(json, ConversationSummary.fromJson),
      );

  /// Replaces the list; rethrows if there was already a list to keep
  /// showing (so a pull-to-refresh can say it failed).
  Future<void> refresh() async {
    try {
      final fresh = await _fetch();
      if (ref.mounted) state = AsyncData(fresh);
    } on Object catch (e, st) {
      if (!ref.mounted) return;
      if (state.hasValue) rethrow;
      state = AsyncError(e, st);
    }
  }

  void refreshInBackground() => unawaited(refresh().catchError((Object _) {}));
}

final Provider<int> unreadTotalProvider = Provider.autoDispose<int>(
  (ref) =>
      ref
          .watch(conversationsProvider)
          .value
          ?.fold<int>(0, (sum, c) => sum + c.unreadCount) ??
      0,
);

/// The header for one thread. There's no `GET /conversations/:id`; the
/// list is also how a blocked or deleted conversation shows up as gone
/// (null).
final FutureProviderFamily<ConversationSummary?, int>
threadConversationProvider = FutureProvider.autoDispose
    .family<ConversationSummary?, int>((ref, id) async {
      final all = await ref
          .read(christimonyApiProvider)
          .send(
            Api.listConversations,
            decode: (json) => _list(json, ConversationSummary.fromJson),
          );
      return all.where((c) => c.id == id).firstOrNull;
    });

enum ReportReason {
  spam('Spam'),
  inappropriate('Inappropriate content'),
  fakeProfile('Fake profile'),
  harassment('Harassment'),
  underage('Underage'),
  other('Something else');

  ReportReason(this.label);
  final String label;

  String get wire => switch (this) {
    fakeProfile => 'fake_profile',
    _ => name,
  };
}

Future<void> reportProfile(
  ChristimonyApi api,
  int profileId,
  ReportReason reason,
  String details,
) => api.send(
  Api.createReport,
  fields: {
    'reported_profile_id': profileId,
    'reason': reason.wire,
    if (details.isNotEmpty) 'details': details,
  },
  decode: (_) {},
);

Future<void> blockProfile(ChristimonyApi api, int profileId) => api.send(
  Api.createBlock,
  fields: {'blocked_profile_id': profileId},
  decode: (_) {},
);
