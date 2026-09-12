// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhotoRef _$PhotoRefFromJson(Map<String, dynamic> json) => _PhotoRef(
  id: (json['id'] as num).toInt(),
  url: json['url'] as String,
  thumbUrl: json['thumb_url'] as String,
  position: (json['position'] as num).toInt(),
);

Map<String, dynamic> _$PhotoRefToJson(_PhotoRef instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'thumb_url': instance.thumbUrl,
  'position': instance.position,
};
