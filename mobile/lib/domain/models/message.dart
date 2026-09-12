import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// `sender_account_id` is an ACCOUNT id, not a profile id — compare
/// against `/me`'s `id` to render own-vs-other bubbles, never against a
/// profile id. See plan §4.6.6.
@freezed
abstract class Message with _$Message {
  const factory Message({
    required int id,
    @JsonKey(name: 'conversation_id') required int conversationId,
    @JsonKey(name: 'sender_account_id') required int senderAccountId,
    required String body,
    @JsonKey(name: 'sent_at') required String sentAt,
    @JsonKey(name: 'read_at') String? readAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
