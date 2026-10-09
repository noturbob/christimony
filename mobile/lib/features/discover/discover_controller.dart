import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exception.dart';
import '../../core/network/endpoints.dart';
import '../../data/api/christimony_api.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/denomination.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/feed_page.dart';
import '../../domain/models/match.dart';
import '../../domain/models/profile.dart';

/// The profile picked in the "Browsing as" selector; null = the default
/// [actingProfileProvider].
final browsingAsIdProvider = NotifierProvider<Selection<int>, int?>(
  Selection.new,
);

/// User-chosen feed filters; null = [defaultFilters] for the acting profile.
final feedFiltersProvider =
    NotifierProvider<Selection<FeedFilters>, FeedFilters?>(Selection.new);

class Selection<T> extends Notifier<T?> {
  @override
  T? build() => null;

  // A method, not a setter, so it can be torn off as a callback.
  // ignore: use_setters_to_change_properties
  void set(T? value) => state = value;
}

/// The profile that likes and passes.
final browsingAsProvider = FutureProvider<Profile?>((ref) async {
  final id = ref.watch(browsingAsIdProvider);
  final mine = await ref.watch(myProfilesProvider.future);
  return mine
          .where((p) => p.id == id && p.status == ProfileStatus.active)
          .firstOrNull ??
      await ref.watch(actingProfileProvider.future);
});

final denominationsProvider = FutureProvider<List<Denomination>>(
  (ref) => ref
      .watch(christimonyApiProvider)
      .send(
        Api.denominations,
        decode: (json) => [
          for (final d in json! as List)
            Denomination.fromJson(d as Map<String, dynamic>),
        ],
      ),
  retry: (_, _) => null,
);

/// The feed applies no gender preference of its own, so default to the
/// opposite of the acting profile's gender.
FeedFilters defaultFilters(Profile acting) => FeedFilters(
  gender: switch (acting.gender) {
    Gender.male => 'female',
    Gender.female => 'male',
    _ => null,
  },
);

typedef PassUndo = ({int passId, Profile profile});

class DeckState {
  const DeckState({
    required this.acting,
    required this.filters,
    required this.queue,
    this.nextAfterId,
    this.undo,
  });

  /// Null when the account has no active profile to browse as.
  final Profile? acting;
  final FeedFilters filters;

  /// Remaining cards; `queue.first` is on top.
  final List<Profile> queue;
  final int? nextAfterId;

  /// The last action, if it was a pass (likes can't be undone).
  final PassUndo? undo;

  DeckState copyWith({
    List<Profile>? queue,
    int? Function()? nextAfterId,
    PassUndo? Function()? undo,
  }) => DeckState(
    acting: acting,
    filters: filters,
    queue: queue ?? this.queue,
    nextAfterId: nextAfterId == null ? this.nextAfterId : nextAfterId(),
    undo: undo == null ? this.undo : undo(),
  );
}

final deckProvider = AsyncNotifierProvider<DeckController, DeckState>(
  DeckController.new,
  retry: (_, _) => null,
);

class DeckController extends AsyncNotifier<DeckState> {
  static const prefetchAt = 3;

  bool _fetching = false;

  ChristimonyApi get _api => ref.read(christimonyApiProvider);
  DeckState get _s => state.requireValue;

  @override
  Future<DeckState> build() async {
    _fetching = false;
    final custom = ref.watch(feedFiltersProvider);
    final acting = await ref.watch(browsingAsProvider.future);
    if (acting == null) {
      return const DeckState(acting: null, filters: FeedFilters(), queue: []);
    }
    final filters = custom ?? defaultFilters(acting);
    final page = await _page(filters, null);
    return DeckState(
      acting: acting,
      filters: filters,
      queue: page.profiles,
      nextAfterId: page.nextAfterId,
    );
  }

  Future<FeedPage> _page(FeedFilters filters, int? afterId) => _api.send(
    Api.feed,
    query: filters.copyWith(afterId: afterId).toQuery(),
    decode: (json) => FeedPage.fromJson(json! as Map<String, dynamic>),
  );

  /// Takes the top card off the deck (optimistically -- [_restore] puts it
  /// back if the request fails) and tops the queue up when it runs low.
  Profile _take() {
    final s = _s;
    state = AsyncData(s.copyWith(queue: s.queue.sublist(1), undo: () => null));
    unawaited(_prefetch());
    return s.queue.first;
  }

  void _restore(Profile p) {
    if (!ref.mounted) return;
    state = AsyncData(_s.copyWith(queue: [p, ..._s.queue]));
  }

  Future<void> _prefetch() async {
    final s = _s;
    if (_fetching || s.queue.length > prefetchAt || s.nextAfterId == null) {
      return;
    }
    _fetching = true;
    try {
      final page = await _page(s.filters, s.nextAfterId);
      if (!ref.mounted) return;
      final seen = {for (final p in _s.queue) p.id};
      state = AsyncData(
        _s.copyWith(
          queue: [
            ..._s.queue,
            ...page.profiles.where((p) => !seen.contains(p.id)),
          ],
          nextAfterId: () => page.nextAfterId,
        ),
      );
    } on Object catch (e, st) {
      // A failed top-up is retried by the next swipe -- unless the deck is
      // already empty, when there's no next swipe.
      if (ref.mounted && _s.queue.isEmpty) state = AsyncError(e, st);
    } finally {
      _fetching = false;
    }
  }

  /// Likes the top card. Returns null when there's no mutual match yet.
  Future<Matched?> like() async {
    final acting = _s.acting!;
    final target = _take();
    try {
      return await sendLike(_api, from: acting.id, to: target);
    } catch (_) {
      _restore(target);
      rethrow;
    }
  }

  Future<void> pass() async {
    final acting = _s.acting!;
    final target = _take();
    try {
      final passId = await _api.send(
        Api.createPass,
        fields: {'profile_id': acting.id, 'passed_profile_id': target.id},
        decode: (json) => (json! as Map)['id'] as int,
      );
      if (ref.mounted) {
        state = AsyncData(
          _s.copyWith(undo: () => (passId: passId, profile: target)),
        );
      }
    } catch (_) {
      _restore(target);
      rethrow;
    }
  }

  Future<void> undo() async {
    final undo = _s.undo;
    if (undo == null) return;
    state = AsyncData(
      _s.copyWith(queue: [undo.profile, ..._s.queue], undo: () => null),
    );
    try {
      await _api.send(
        Api.deletePass,
        pathArgs: {'id': undo.passId},
        decode: (_) {},
      );
    } catch (_) {
      if (ref.mounted) {
        state = AsyncData(
          _s.copyWith(
            queue: _s.queue.where((p) => p.id != undo.profile.id).toList(),
            undo: () => undo,
          ),
        );
      }
      rethrow;
    }
  }

  /// Drops a profile liked or blocked from the detail screen.
  void remove(int profileId) {
    final s = state.value;
    if (s == null) return;
    state = AsyncData(
      s.copyWith(
        queue: s.queue.where((p) => p.id != profileId).toList(),
        undo: s.undo?.profile.id == profileId ? () => null : null,
      ),
    );
    unawaited(_prefetch());
  }
}

class Matched {
  const Matched(this.profile, this.conversationId);
  final Profile profile;

  /// Null if opening the conversation failed -- the match still exists.
  final int? conversationId;
}

/// `POST /interests`, and on a mutual match `POST /conversations` -- a
/// match doesn't open a conversation by itself.
Future<Matched?> sendLike(
  ChristimonyApi api, {
  required int from,
  required Profile to,
}) async {
  final result = await api.send(
    Api.createInterest,
    fields: {'sender_profile_id': from, 'receiver_profile_id': to.id},
    decode: (json) => InterestResult.fromJson(json! as Map<String, dynamic>),
  );
  final match = result.match;
  if (match == null) return null;
  try {
    final conversationId = await api.send(
      Api.createConversation,
      fields: {'match_id': match.id},
      decode: (json) => (json! as Map)['id'] as int,
    );
    return Matched(to, conversationId);
  } on ApiException {
    return Matched(to, null);
  }
}
