import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/endpoints.dart';
import '../../core/session/session_controller.dart';
import '../../data/api/christimony_api.dart';
import '../../data/api/upload.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/denomination.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/photo.dart';
import 'onboarding_draft.dart';

final denominationsProvider = FutureProvider<List<Denomination>>(
  (ref) => ref
      .watch(christimonyApiProvider)
      .send(
        Api.denominations,
        decode: (json) => [
          for (final d in json! as List)
            Denomination.fromJson(d as Map<String, dynamic>),
        ],
      ),
);

final promptQuestionsProvider = FutureProvider<List<String>>(
  (ref) => ref
      .watch(christimonyApiProvider)
      .send(
        Api.promptQuestions,
        decode: (json) => [for (final q in json! as List) q as String],
      ),
);

final onboardingProvider =
    AsyncNotifierProvider<OnboardingController, OnboardingDraft>(
      OnboardingController.new,
    );

/// The wizard's draft plus every server call the web wizard makes, in the
/// same places. Each action throws an `ApiException` for the screen to show.
class OnboardingController extends AsyncNotifier<OnboardingDraft> {
  late String _key;
  bool _resumeOffered = false;

  ChristimonyApi get _api => ref.read(christimonyApiProvider);
  OnboardingDraft get _draft => state.requireValue;
  int get _profileId => _draft.profileId!;

  @override
  Future<OnboardingDraft> build() async {
    final accountId = ref.watch(currentAccountProvider.select((a) => a?.id));
    final isParent =
        ref.read(currentAccountProvider)?.accountType == AccountType.parent;
    _key = 'onboarding-draft-$accountId';
    _resumeOffered = false;

    final raw = (await SharedPreferences.getInstance()).getString(_key);
    if (raw != null) {
      try {
        return OnboardingDraft.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } on Object {
        // An unreadable draft just means starting over.
      }
    }
    return OnboardingDraft(accountType: isParent ? 'parent' : 'individual');
  }

  void edit(OnboardingDraft Function(OnboardingDraft) change) {
    final next = change(_draft);
    state = AsyncData(next);
    unawaited(
      SharedPreferences.getInstance().then(
        (p) => p.setString(_key, jsonEncode(next.toJson())),
      ),
    );
  }

  /// The saved step to jump to, once, when a relaunch lands on [current]
  /// (the guard always sends an unfinished account to the first step).
  String? takeResumeStep(String current) {
    if (_resumeOffered) return null;
    _resumeOffered = true;
    final saved = _draft.step;
    return current == onboardingSteps.first &&
            saved != current &&
            onboardingSteps.contains(saved)
        ? saved
        : null;
  }

  void toggleQuestion(String question) => edit((d) {
    final answers = {...d.answers};
    if (answers.remove(question) == null) {
      if (answers.length >= requiredPrompts) return d;
      answers[question] = '';
    }
    return d.copyWith(answers: answers);
  });

  /// The web never sent this answer anywhere; the account type decides
  /// whether the profile is the user's own or their child's.
  Future<void> saveAccountType() async {
    final current = ref.read(currentAccountProvider)?.accountType.name;
    if (current == _draft.accountType) return;
    await _api.send<void>(
      Api.updateMe,
      fields: {'account_type': _draft.accountType},
      decode: (_) {},
    );
    await ref.read(sessionProvider.notifier).refreshAccount();
  }

  /// Leaving `education`: creates the draft profile, or -- when one exists
  /// (resumed, or the user came back to edit) -- updates it.
  Future<void> saveBasics() async {
    final d = _draft;
    final fields = <String, Object?>{
      'name': d.name.trim(),
      'dob': d.dob,
      'gender': d.gender,
      'city': d.city.trim(),
      'denomination_id': d.denominationId,
      'education': d.education.trim(),
      'profession': d.profession.trim(),
    };
    if (d.profileId != null) {
      await _api.send<void>(
        Api.updateProfile,
        pathArgs: {'id': d.profileId!},
        fields: fields,
        decode: (_) {},
      );
      return;
    }
    final id = await _api.send(
      Api.createProfile,
      fields: {...fields, 'profile_type': d.forChild ? 'ward' : 'self'},
      decode: (json) => (json! as Map<String, dynamic>)['id'] as int,
    );
    edit((d) => d.copyWith(profileId: id));
  }

  Future<void> addPhoto(List<int> jpeg) async {
    final photo = await _api.send(
      Api.createPhoto,
      pathArgs: {'pid': _profileId},
      form: jpegUpload('image', jpeg),
      decode: (json) => PhotoRef.fromJson(json! as Map<String, dynamic>),
    );
    edit((d) => d.copyWith(photos: [...d.photos, photo]));
  }

  Future<void> removePhoto(PhotoRef photo) async {
    await _api.send<void>(
      Api.deletePhoto,
      pathArgs: {'pid': _profileId, 'id': photo.id},
      decode: (_) {},
    );
    edit(
      (d) => d.copyWith(photos: [...d.photos.where((p) => p.id != photo.id)]),
    );
  }

  Future<void> savePrompts() async {
    final d = _draft;
    final saved = {...d.savedPrompts};
    try {
      for (final question in [...saved.keys]) {
        if (d.answers.containsKey(question)) continue;
        await _api.send<void>(
          Api.deletePrompt,
          pathArgs: {'pid': _profileId, 'id': saved[question]!},
          decode: (_) {},
        );
        saved.remove(question);
      }
      for (final MapEntry(key: question, value: answer) in d.answers.entries) {
        final id = saved[question];
        if (id != null) {
          await _api.send<void>(
            Api.updatePrompt,
            pathArgs: {'pid': _profileId, 'id': id},
            fields: {'answer': answer.trim()},
            decode: (_) {},
          );
        } else {
          saved[question] = await _api.send(
            Api.createPrompt,
            pathArgs: {'pid': _profileId},
            fields: {'question': question, 'answer': answer.trim()},
            decode: (json) => (json! as Map<String, dynamic>)['id'] as int,
          );
        }
      }
    } finally {
      edit((d) => d.copyWith(savedPrompts: saved));
    }
  }

  Future<void> saveBio() => _api.send<void>(
    Api.updateProfile,
    pathArgs: {'id': _profileId},
    fields: {'bio': _draft.bio.trim()},
    decode: (_) {},
  );

  /// Activates the profile; the refreshed account then satisfies the
  /// router guard, which moves the user on to Discover.
  Future<void> finish() async {
    await _api.send<void>(
      Api.updateProfile,
      pathArgs: {'id': _profileId},
      fields: {'status': 'active'},
      decode: (_) {},
    );
    await (await SharedPreferences.getInstance()).remove(_key);
    ref.invalidate(myProfilesProvider);
    await ref.read(sessionProvider.notifier).refreshAccount();
    ref.invalidateSelf();
  }
}
