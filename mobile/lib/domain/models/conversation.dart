import 'package:freezed_annotation/freezed_annotation.dart';

import 'profile.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
abstract class LastMessagePreview with _$LastMessagePreview {
  const factory LastMessagePreview({
    required String body,
    @JsonKey(name: 'sent_at') required String sentAt,
  }) = _LastMessagePreview;

  factory LastMessagePreview.fromJson(Map<String, dynamic> json) =>
      _$LastMessagePreviewFromJson(json);
}

/// NOTE: `unread_count` ignores which of the caller's profiles is being
/// asked about — for a parent managing a ward it aggregates unread
/// messages across both. Cosmetic; see plan §6 (Risks).
@freezed
abstract class ConversationSummary with _$ConversationSummary {
  const factory ConversationSummary({
    required int id,
    @JsonKey(name: 'match_id') required int matchId,
    @JsonKey(name: 'other_profile') required ProfileSummary otherProfile,
    @JsonKey(name: 'last_message') LastMessagePreview? lastMessage,
    @JsonKey(name: 'unread_count') required int unreadCount,
  }) = _ConversationSummary;

  factory ConversationSummary.fromJson(Map<String, dynamic> json) =>
      _$ConversationSummaryFromJson(json);
}
