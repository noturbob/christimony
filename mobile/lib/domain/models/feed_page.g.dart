// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedPage _$FeedPageFromJson(Map<String, dynamic> json) => _FeedPage(
  profiles: (json['profiles'] as List<dynamic>)
      .map((e) => Profile.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextAfterId: (json['next_after_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$FeedPageToJson(_FeedPage instance) => <String, dynamic>{
  'profiles': instance.profiles,
  'next_after_id': instance.nextAfterId,
};

_FeedFilters _$FeedFiltersFromJson(Map<String, dynamic> json) => _FeedFilters(
  city: json['city'] as String?,
  denominationId: (json['denomination_id'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  minAge: (json['min_age'] as num?)?.toInt(),
  maxAge: (json['max_age'] as num?)?.toInt(),
  afterId: (json['after_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$FeedFiltersToJson(_FeedFilters instance) =>
    <String, dynamic>{
      'city': instance.city,
      'denomination_id': instance.denominationId,
      'gender': instance.gender,
      'min_age': instance.minAge,
      'max_age': instance.maxAge,
      'after_id': instance.afterId,
    };
