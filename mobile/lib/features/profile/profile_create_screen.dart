import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/network/endpoints.dart';
import '../../core/session/session_controller.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/profile.dart';
import 'profile_form.dart';

/// Creates a profile as a draft, then hands over to its edit screen for
/// photos, prompts and activation.
class ProfileCreateScreen extends ConsumerStatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  ConsumerState<ProfileCreateScreen> createState() =>
      _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends ConsumerState<ProfileCreateScreen> {
  // Parents default to a child's profile -- that's the one introductions
  // need.
  late ProfileType _type =
      ref.read(currentAccountProvider)?.accountType == AccountType.parent
      ? ProfileType.ward
      : ProfileType.self;

  Future<void> _create(Map<String, Object?> fields) async {
    final profile = await ref
        .read(christimonyApiProvider)
        .send(
          Api.createProfile,
          fields: {...fields, 'profile_type': _type.toJson()},
          decode: (json) => Profile.fromJson(json! as Map<String, dynamic>),
        );
    ref.invalidate(myProfilesProvider);
    if (mounted) context.pushReplacement(Routes.editProfile(profile.id));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isParent =
        ref.watch(currentAccountProvider)?.accountType == AccountType.parent;

    return Scaffold(
      appBar: AppBar(title: const Text('New profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: [
          Text(
            _type == ProfileType.ward
                ? "Your child's profile"
                : 'Tell us about yourself',
            style: text.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Start with the essentials. Next you'll add photos and prompts, "
            'then activate it.',
            style: text.bodyMedium?.copyWith(color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 24),
          if (isParent) ...[
            Text('Who is this profile for?', style: text.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<ProfileType>(
              segments: const [
                ButtonSegment(value: ProfileType.ward, label: Text('My child')),
                ButtonSegment(value: ProfileType.self, label: Text('Myself')),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.single),
            ),
            const SizedBox(height: 24),
          ],
          ProfileForm(submitLabel: 'Create profile', onSubmit: _create),
        ],
      ),
    );
  }
}
