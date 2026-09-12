// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WardSummary _$WardSummaryFromJson(Map<String, dynamic> json) => _WardSummary(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  city: json['city'] as String?,
);

Map<String, dynamic> _$WardSummaryToJson(_WardSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
    };

_Introduction _$IntroductionFromJson(Map<String, dynamic> json) =>
    _Introduction(
      id: (json['id'] as num).toInt(),
      parentMatchId: (json['parent_match_id'] as num).toInt(),
      status: IntroductionStatus.fromJson(json['status'] as String?),
      wardA: WardSummary.fromJson(json['ward_a'] as Map<String, dynamic>),
      wardB: WardSummary.fromJson(json['ward_b'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IntroductionToJson(_Introduction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_match_id': instance.parentMatchId,
      'status': _$IntroductionStatusEnumMap[instance.status]!,
      'ward_a': instance.wardA,
      'ward_b': instance.wardB,
    };

const _$IntroductionStatusEnumMap = {
  IntroductionStatus.pendingBoth: 'pendingBoth',
  IntroductionStatus.pendingA: 'pendingA',
  IntroductionStatus.pendingB: 'pendingB',
  IntroductionStatus.accepted: 'accepted',
  IntroductionStatus.declined: 'declined',
  IntroductionStatus.unknown: 'unknown',
};
