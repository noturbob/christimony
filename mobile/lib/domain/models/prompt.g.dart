// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Prompt _$PromptFromJson(Map<String, dynamic> json) => _Prompt(
  id: (json['id'] as num).toInt(),
  profileId: (json['profile_id'] as num).toInt(),
  question: json['question'] as String,
  answer: json['answer'] as String,
);

Map<String, dynamic> _$PromptToJson(_Prompt instance) => <String, dynamic>{
  'id': instance.id,
  'profile_id': instance.profileId,
  'question': instance.question,
  'answer': instance.answer,
};
