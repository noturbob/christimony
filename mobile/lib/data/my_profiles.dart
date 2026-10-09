import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/endpoints.dart';
import '../domain/models/enums.dart';
import '../domain/models/profile.dart';
import 'api/christimony_api.dart';

/// Every profile the signed-in account manages (its own `self` profile and
/// any `ward` profiles), drafts included. Invalidate after creating,
/// editing, or activating one.
final myProfilesProvider = FutureProvider<List<Profile>>((ref) {
  return ref
      .watch(christimonyApiProvider)
      .send(
        Api.myProfiles,
        decode: (json) => [
          for (final p in json! as List)
            Profile.fromJson(p as Map<String, dynamic>),
        ],
      );
});

/// The profile the account acts as when liking, passing, and messaging:
/// its active `self` profile if it has one, else its first active profile.
final actingProfileProvider = FutureProvider<Profile?>((ref) async {
  final profiles = await ref.watch(myProfilesProvider.future);
  final active = profiles.where((p) => p.status == ProfileStatus.active);
  return active.where((p) => p.profileType == ProfileType.self).firstOrNull ??
      active.firstOrNull;
});
