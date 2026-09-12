import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt.freezed.dart';
part 'prompt.g.dart';

/// NOTE: prompts are keyed by [question] TEXT, not a stable id from the
/// question bank (`prompt_questions` is a bare array of strings with no
/// ids) — editing the wording server-side orphans existing answers. See
/// plan §4.6.11.
@freezed
abstract class Prompt with _$Prompt {
  const factory Prompt({
    required int id,
    @JsonKey(name: 'profile_id') required int profileId,
    required String question,
    required String answer,
  }) = _Prompt;

  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);
}
