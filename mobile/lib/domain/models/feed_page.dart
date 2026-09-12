import 'package:freezed_annotation/freezed_annotation.dart';

import 'profile.dart';

part 'feed_page.freezed.dart';
part 'feed_page.g.dart';

/// The ONLY endpoint that paginates. See `docs/mobile-v1-plan.md` §4.6.4:
/// `already_interested_ids` is rebuilt per request and offset pagination
/// applied on top, so every like shrinks the result set and page 2
/// silently skips as many profiles as were liked on page 1. The deck
/// controller's `seenIds` dedupe (see `DeckController`) stops duplicate
/// *cards* but cannot recover profiles skipped this way.
@freezed
abstract class FeedPage with _$FeedPage {
  const factory FeedPage({
    required List<Profile> profiles,
    @JsonKey(name: 'next_page') int? nextPage,
  }) = _FeedPage;

  factory FeedPage.fromJson(Map<String, dynamic> json) =>
      _$FeedPageFromJson(json);
}

/// All optional — combined with AND server-side. `gender` intentionally
/// has NO default: the feed applies no gender preference of its own, so
/// the deck controller must default this to the opposite gender of the
/// acting profile or same-gender profiles appear from the first swipe
/// (plan, Phase 6).
@freezed
abstract class FeedFilters with _$FeedFilters {
  const factory FeedFilters({
    String? city,
    @JsonKey(name: 'denomination_id') int? denominationId,
    String? gender,
    @JsonKey(name: 'min_age') int? minAge,
    @JsonKey(name: 'max_age') int? maxAge,
    @Default(1) int page,
  }) = _FeedFilters;

  factory FeedFilters.fromJson(Map<String, dynamic> json) =>
      _$FeedFiltersFromJson(json);
}

extension FeedFiltersQuery on FeedFilters {
  /// Rails' feed endpoint reads these as plain query params.
  Map<String, Object?> toQuery() => {
    if (city != null && city!.isNotEmpty) 'city': city,
    if (denominationId != null) 'denomination_id': denominationId,
    if (gender != null) 'gender': gender,
    if (minAge != null) 'min_age': minAge,
    if (maxAge != null) 'max_age': maxAge,
    'page': page,
  };
}
