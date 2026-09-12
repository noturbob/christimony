// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedPage _$FeedPageFromJson(Map<String, dynamic> json) => _FeedPage(
  profiles: (json['profiles'] as List<dynamic>)
      .map((e) => Profile.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextPage: (json['next_page'] as num?)?.toInt(),
);

Map<String, dynamic> _$FeedPageToJson(_FeedPage instance) => <String, dynamic>{
  'profiles': instance.profiles,
  'next_page': instance.nextPage,
};

_FeedFilters _$FeedFiltersFromJson(Map<String, dynamic> json) => _FeedFilters(
  city: json['city'] as String?,
  denominationId: (json['denomination_id'] as num?)?.toInt(),
  gender: json['gender'] as String?,
  minAge: (json['min_age'] as num?)?.toInt(),
  maxAge: (json['max_age'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$FeedFiltersToJson(_FeedFilters instance) =>
    <String, dynamic>{
      'city': instance.city,
      'denomination_id': instance.denominationId,
      'gender': instance.gender,
      'min_age': instance.minAge,
      'max_age': instance.maxAge,
      'page': instance.page,
    };
