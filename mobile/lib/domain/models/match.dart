import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';
import 'interest.dart';
import 'profile.dart';

part 'match.freezed.dart';
part 'match.g.dart';

/// Matches `MatchesController#index`. NOTE: this does not carry a
/// `conversation_id` — a mutual match creates only the `Match` row
/// server-side (`InterestsController#check_for_mutual_match`), so the
/// client must follow up with `POST /conversations {match_id}` before it
/// can open a thread. See plan §4.6.7.
@freezed
abstract class MatchSummary with _$MatchSummary {
  const factory MatchSummary({
    required int id,
    @JsonKey(name: 'profile_a') required ProfileSummary profileA,
    @JsonKey(name: 'profile_b') required ProfileSummary profileB,
    @JsonKey(name: 'my_profile_id') required int myProfileId,
    @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)
    required MatchType matchType,
    @JsonKey(name: 'matched_at') required String matchedAt,
  }) = _MatchSummary;

  factory MatchSummary.fromJson(Map<String, dynamic> json) =>
      _$MatchSummaryFromJson(json);
}

extension MatchSummaryX on MatchSummary {
  /// The other person in this match, regardless of which side I'm on.
  ProfileSummary get other => myProfileId == profileA.id ? profileB : profileA;
}

/// The lightweight `match` object embedded in `POST /interests`'
/// response — a DIFFERENT, smaller shape than [MatchSummary]: raw
/// profile ids rather than embedded [ProfileSummary]s, and no
/// `matched_at`/`my_profile_id`. Fetch `GET /matches` afterward for the
/// full summary, or use these ids directly to call
/// `POST /conversations {match_id}`.
@freezed
abstract class NewMatch with _$NewMatch {
  const factory NewMatch({
    required int id,
    @JsonKey(name: 'profile_a_id') required int profileAId,
    @JsonKey(name: 'profile_b_id') required int profileBId,
    @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)
    required MatchType matchType,
  }) = _NewMatch;

  factory NewMatch.fromJson(Map<String, dynamic> json) =>
      _$NewMatchFromJson(json);
}

/// The `{interest, match}` response from `POST /interests`. [match] is
/// null unless the like created a reciprocal, mutual match.
@freezed
abstract class InterestResult with _$InterestResult {
  const factory InterestResult({required Interest interest, NewMatch? match}) =
      _InterestResult;

  factory InterestResult.fromJson(Map<String, dynamic> json) =>
      _$InterestResultFromJson(json);
}
