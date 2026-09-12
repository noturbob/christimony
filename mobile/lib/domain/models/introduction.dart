import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'introduction.freezed.dart';
part 'introduction.g.dart';

@freezed
abstract class WardSummary with _$WardSummary {
  const factory WardSummary({
    required int id,
    required String name,
    String? city,
  }) = _WardSummary;

  factory WardSummary.fromJson(Map<String, dynamic> json) =>
      _$WardSummaryFromJson(json);
}

/// The consent model at the heart of the parent/ward feature. See plan
/// §4.6.8: `Introduction#accept!` is NOT idempotent — calling accept
/// again on an already-`accepted` record creates a duplicate `Match`
/// every time, and accepting from the wrong side is a silent 200 no-op.
/// The UI must disable controls once resolved and never allow a
/// re-submit. `decline!` is terminal for both wards with no reopen path.
@freezed
abstract class Introduction with _$Introduction {
  const factory Introduction({
    required int id,
    @JsonKey(name: 'parent_match_id') required int parentMatchId,
    @JsonKey(fromJson: IntroductionStatus.fromJson)
    required IntroductionStatus status,
    @JsonKey(name: 'ward_a') required WardSummary wardA,
    @JsonKey(name: 'ward_b') required WardSummary wardB,
  }) = _Introduction;

  factory Introduction.fromJson(Map<String, dynamic> json) =>
      _$IntroductionFromJson(json);
}
