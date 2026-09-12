// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Denomination _$DenominationFromJson(Map<String, dynamic> json) =>
    _Denomination(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$DenominationToJson(_Denomination instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
