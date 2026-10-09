import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/dates.dart';
import '../../domain/models/photo.dart';

part 'onboarding_draft.freezed.dart';
part 'onboarding_draft.g.dart';

/// Ported from `web/lib/onboarding.ts`.
const onboardingSteps = [
  'account-type',
  'name',
  'dob',
  'gender',
  'denomination',
  'city',
  'education',
  'photos',
  'prompts',
  'bio',
  'review',
];

const minPhotos = 2;
const requiredPrompts = 3;

/// Everything the wizard has collected, persisted so a killed app resumes
/// where it left off. [profileId] is set once the draft profile exists
/// server-side, so resuming never creates a second one.
@freezed
abstract class OnboardingDraft with _$OnboardingDraft {
  const factory OnboardingDraft({
    @Default('individual') String accountType,
    @Default('') String name,

    /// Civil date, `YYYY-MM-DD`.
    @Default('') String dob,
    @Default('') String gender,
    int? denominationId,
    @Default('') String denominationName,
    @Default('') String city,
    @Default('') String education,
    @Default('') String profession,
    @Default('') String bio,
    int? profileId,
    @Default([]) List<PhotoRef> photos,

    /// Selected prompt questions, in the order picked, to their answers.
    @Default({}) Map<String, String> answers,

    /// Prompt ids already on the server, by question -- so leaving the
    /// prompts step twice updates instead of duplicating.
    @Default({}) Map<String, int> savedPrompts,

    /// The last step the user moved to.
    @Default('account-type') String step,
  }) = _OnboardingDraft;

  const OnboardingDraft._();

  factory OnboardingDraft.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDraftFromJson(json);

  bool get forChild => accountType == 'parent';
}

bool isAdult(String dob, {DateTime? now}) {
  if (dob.isEmpty) return false;
  final today = now ?? DateTime.now();
  final DateTime birth;
  try {
    birth = parseCivilDate(dob);
  } on Object {
    return false;
  }
  return !birth.isAfter(DateTime(today.year - 18, today.month, today.day));
}

bool canContinue(String step, OnboardingDraft d) => switch (step) {
  'name' => d.name.trim().isNotEmpty,
  'dob' => isAdult(d.dob),
  'gender' => d.gender.isNotEmpty,
  'city' => d.city.trim().isNotEmpty,
  'photos' => d.photos.length >= minPhotos,
  'prompts' =>
    d.answers.length == requiredPrompts &&
        d.answers.values.every((a) => a.trim().isNotEmpty),
  _ => onboardingSteps.contains(step),
};
