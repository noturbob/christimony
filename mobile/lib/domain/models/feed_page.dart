import 'package:freezed_annotation/freezed_annotation.dart';

import 'profile.dart';

part 'feed_page.freezed.dart';
part 'feed_page.g.dart';

/// The ONLY endpoint that paginates. Keyset: pass `nextAfterId` back as
/// `after_id` (via `FeedFilters.afterId`). Likes and passes remove profiles
/// from the result set between requests, which is why this isn't an
/// offset -- an offset would skip that many unseen profiles.
@freezed
abstract class FeedPage with _$FeedPage {
  const factory FeedPage({
    required List<Profile> profiles,
    @JsonKey(name: 'next_after_id') int? nextAfterId,
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
    @JsonKey(name: 'after_id') int? afterId,
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
    if (afterId != null) 'after_id': afterId,
  };
}
