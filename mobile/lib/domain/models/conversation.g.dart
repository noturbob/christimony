// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LastMessagePreview _$LastMessagePreviewFromJson(Map<String, dynamic> json) =>
    _LastMessagePreview(
      body: json['body'] as String,
      sentAt: json['sent_at'] as String,
    );

Map<String, dynamic> _$LastMessagePreviewToJson(_LastMessagePreview instance) =>
    <String, dynamic>{'body': instance.body, 'sent_at': instance.sentAt};

_ConversationSummary _$ConversationSummaryFromJson(Map<String, dynamic> json) =>
    _ConversationSummary(
      id: (json['id'] as num).toInt(),
      matchId: (json['match_id'] as num).toInt(),
      otherProfile: ProfileSummary.fromJson(
        json['other_profile'] as Map<String, dynamic>,
      ),
      lastMessage: json['last_message'] == null
          ? null
          : LastMessagePreview.fromJson(
              json['last_message'] as Map<String, dynamic>,
            ),
      unreadCount: (json['unread_count'] as num).toInt(),
    );

Map<String, dynamic> _$ConversationSummaryToJson(
  _ConversationSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'match_id': instance.matchId,
  'other_profile': instance.otherProfile,
  'last_message': instance.lastMessage,
  'unread_count': instance.unreadCount,
};
