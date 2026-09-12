// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchSummary _$MatchSummaryFromJson(
  Map<String, dynamic> json,
) => _MatchSummary(
  id: (json['id'] as num).toInt(),
  profileA: ProfileSummary.fromJson(json['profile_a'] as Map<String, dynamic>),
  profileB: ProfileSummary.fromJson(json['profile_b'] as Map<String, dynamic>),
  myProfileId: (json['my_profile_id'] as num).toInt(),
  matchType: MatchType.fromJson(json['match_type'] as String?),
  matchedAt: json['matched_at'] as String,
);

Map<String, dynamic> _$MatchSummaryToJson(_MatchSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_a': instance.profileA,
      'profile_b': instance.profileB,
      'my_profile_id': instance.myProfileId,
      'match_type': _$MatchTypeEnumMap[instance.matchType]!,
      'matched_at': instance.matchedAt,
    };

const _$MatchTypeEnumMap = {
  MatchType.direct: 'direct',
  MatchType.parent: 'parent',
  MatchType.unknown: 'unknown',
};

_NewMatch _$NewMatchFromJson(Map<String, dynamic> json) => _NewMatch(
  id: (json['id'] as num).toInt(),
  profileAId: (json['profile_a_id'] as num).toInt(),
  profileBId: (json['profile_b_id'] as num).toInt(),
  matchType: MatchType.fromJson(json['match_type'] as String?),
);

Map<String, dynamic> _$NewMatchToJson(_NewMatch instance) => <String, dynamic>{
  'id': instance.id,
  'profile_a_id': instance.profileAId,
  'profile_b_id': instance.profileBId,
  'match_type': _$MatchTypeEnumMap[instance.matchType]!,
};

_InterestResult _$InterestResultFromJson(Map<String, dynamic> json) =>
    _InterestResult(
      interest: Interest.fromJson(json['interest'] as Map<String, dynamic>),
      match: json['match'] == null
          ? null
          : NewMatch.fromJson(json['match'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InterestResultToJson(_InterestResult instance) =>
    <String, dynamic>{'interest': instance.interest, 'match': instance.match};
