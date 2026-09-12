// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: (json['id'] as num).toInt(),
  conversationId: (json['conversation_id'] as num).toInt(),
  senderAccountId: (json['sender_account_id'] as num).toInt(),
  body: json['body'] as String,
  sentAt: json['sent_at'] as String,
  readAt: json['read_at'] as String?,
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'conversation_id': instance.conversationId,
  'sender_account_id': instance.senderAccountId,
  'body': instance.body,
  'sent_at': instance.sentAt,
  'read_at': instance.readAt,
};
