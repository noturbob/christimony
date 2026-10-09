import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exception.dart';
import '../../core/network/endpoints.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/profile.dart';
import '../../ui/states.dart';
import 'photo_strip.dart';
import 'profile_form.dart';
import 'prompt_editor.dart';
import 'widgets.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({required this.profileId, super.key});
  final int profileId;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  Profile? _profile;
  Object? _error;
  bool _statusBusy = false;

  ChristimonyApi get _api => ref.read(christimonyApiProvider);

  Profile _decode(Object? json) =>
      Profile.fromJson(json! as Map<String, dynamic>);

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final profile = await _api.send(
        Api.showProfile,
        pathArgs: {'id': widget.profileId},
        decode: _decode,
      );
      if (mounted) setState(() => _profile = profile);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _changed(Profile profile) {
    if (!mounted) return;
    setState(() => _profile = profile);
    ref.invalidate(myProfilesProvider);
  }

  Future<void> _save(Map<String, Object?> fields) async {
    final updated = await _api.send(
      Api.updateProfile,
      pathArgs: {'id': widget.profileId},
      fields: fields,
      decode: _decode,
    );
    if (!mounted) return;
    _changed(updated);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved.')));
  }

  Future<void> _setStatus(ProfileStatus status) async {
    setState(() => _statusBusy = true);
    await runWithSnack(context, () async {
      final updated = await _api.send(
        Api.updateProfile,
        pathArgs: {'id': widget.profileId},
        fields: {'status': status.toJson()},
        decode: _decode,
      );
      if (mounted) _changed(updated);
    });
    if (mounted) setState(() => _statusBusy = false);
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : profile == null
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              children: [
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                _StatusCard(
                  profile: profile,
                  busy: _statusBusy,
                  onSetStatus: _setStatus,
                ),
                SectionLabel(
                  'Photos',
                  trailing: _Count(profile.photos.length, maxPhotos),
                ),
                PhotoStrip(
                  profileId: profile.id,
                  photos: [...profile.photos]
                    ..sort((a, b) => a.position.compareTo(b.position)),
                  isActive: profile.status == ProfileStatus.active,
                  onChanged: (photos) =>
                      _changed(profile.copyWith(photos: photos)),
                ),
                SectionLabel(
                  'Prompts',
                  trailing: _Count(profile.prompts.length, promptCount),
                ),
                PromptEditor(
                  profileId: profile.id,
                  prompts: profile.prompts,
                  isActive: profile.status == ProfileStatus.active,
                  onChanged: (prompts) =>
                      _changed(profile.copyWith(prompts: prompts)),
                ),
                const SectionLabel('Details'),
                ProfileForm(
                  initial: profile,
                  submitLabel: 'Save changes',
                  onSubmit: _save,
                ),
              ],
            ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count(this.n, this.of);
  final int n;
  final int of;

  @override
  Widget build(BuildContext context) => Text(
    '$n of $of',
    style: Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: AppColors.mutedForeground),
  );
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.profile,
    required this.busy,
    required this.onSetStatus,
  });

  final Profile profile;
  final bool busy;
  final ValueChanged<ProfileStatus> onSetStatus;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final photos = profile.photos.length;
    final prompts = profile.prompts.length;
    final ready = photos >= minActivePhotos && prompts == promptCount;
    final active = profile.status == ProfileStatus.active;

    final (title, message) = switch (profile.status) {
      ProfileStatus.active => (
        'Active',
        'Visible in Discover. Pause to hide it without losing anything.',
      ),
      ProfileStatus.paused => (
        'Paused',
        'Hidden from Discover until you activate it again.',
      ),
      ProfileStatus.banned => (
        'Suspended',
        'This profile has been suspended and is hidden from everyone.',
      ),
      _ => (
        'Draft',
        "It won't show up in anyone's feed until you activate it.",
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: active ? 0.06 : 0.03),
        borderRadius: BorderRadius.circular(AppRadii.xl2),
        border: Border.all(
          color: active
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.titleLarge),
            const SizedBox(height: 4),
            Text(
              message,
              style: text.bodyMedium?.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            if (!active && !ready) ...[
              const SizedBox(height: 8),
              if (photos < minActivePhotos)
                Text(
                  '• Add at least $minActivePhotos photos ($photos so far)',
                  style: text.bodySmall,
                ),
              if (prompts != promptCount)
                Text(
                  '• Answer exactly $promptCount prompts ($prompts so far)',
                  style: text.bodySmall,
                ),
            ],
            if (profile.status != ProfileStatus.banned) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: busy || (!active && !ready)
                    ? null
                    : () => onSetStatus(
                        active ? ProfileStatus.paused : ProfileStatus.active,
                      ),
                child: Text(active ? 'Pause profile' : 'Activate profile'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
