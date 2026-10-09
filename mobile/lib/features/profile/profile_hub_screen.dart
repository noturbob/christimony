import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/session/session_controller.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/profile.dart';
import '../../ui/avatar.dart';
import '../../ui/cta_button.dart';
import '../../ui/states.dart';
import 'widgets.dart';

class ProfileHubScreen extends ConsumerWidget {
  const ProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final account = ref.watch(currentAccountProvider);
    final profiles = ref.watch(myProfilesProvider);
    final isParent = account?.accountType == AccountType.parent;
    final needsWard =
        isParent &&
        profiles.hasValue &&
        !profiles.requireValue.any((p) => p.profileType == ProfileType.ward);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(myProfilesProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            if (needsWard) const _WardCallout(),
            SectionLabel(
              'Your profiles',
              trailing: isParent
                  ? null
                  : TextButton(
                      onPressed: () => context.push(Routes.newProfile),
                      child: const Text('+ New'),
                    ),
            ),
            ...switch (profiles) {
              AsyncValue(:final error?) => [
                ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(myProfilesProvider),
                ),
              ],
              AsyncValue(:final value?) when value.isEmpty => [
                EmptyView(
                  title: 'No profiles yet',
                  message: isParent
                      ? 'Create a profile for yourself, or on behalf of your child.'
                      : 'Create your profile to start browsing.',
                  action: CtaButton(
                    label: 'Create a profile',
                    onPressed: () => context.push(Routes.newProfile),
                  ),
                ),
              ],
              AsyncValue(:final value?) => [
                for (final p in value) _ProfileTile(p),
              ],
              _ => [
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: LoadingView(),
                ),
              ],
            },
            if (isParent)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: OutlinedButton.icon(
                  onPressed: () => context.push(Routes.newProfile),
                  icon: const Icon(Icons.add),
                  label: const Text("Add a child's profile"),
                ),
              ),
            const SectionLabel('Account'),
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: Text(account?.email ?? account?.phone ?? ''),
                subtitle: Text(
                  isParent ? 'Parent account' : 'Individual account',
                  style: text.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ),
            ),
            NavTile(
              title: 'Verification',
              leading: const Icon(Icons.verified_outlined),
              onTap: () => context.push(Routes.verification),
            ),
            NavTile(
              title: 'Membership',
              leading: const Icon(Icons.workspace_premium_outlined),
              onTap: () => context.push(Routes.subscription),
            ),
            NavTile(
              title: 'Settings',
              leading: const Icon(Icons.settings_outlined),
              onTap: () => context.push(Routes.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile(this.profile);
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final photos = [...p.photos]
      ..sort((a, b) => a.position.compareTo(b.position));
    return NavTile(
      title: p.name,
      leading: Avatar(name: p.name, url: photos.firstOrNull?.thumbUrl),
      subtitle: Text(
        [
          if (p.profileType == ProfileType.ward)
            "Child's profile"
          else
            'Your profile',
          ?p.city,
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusBadge(p.status),
          const Icon(Icons.chevron_right, color: AppColors.mutedForeground),
        ],
      ),
      onTap: () => context.push(Routes.editProfile(p.id)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);
  final ProfileStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ProfileStatus.active => ('Active', AppColors.primary),
      ProfileStatus.draft => ('Draft', AppColors.accent),
      ProfileStatus.paused => ('Paused', AppColors.mutedForeground),
      ProfileStatus.banned => ('Suspended', AppColors.destructive),
      ProfileStatus.unknown => ('', AppColors.mutedForeground),
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.xl4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _WardCallout extends StatelessWidget {
  const _WardCallout();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blush.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadii.xl3),
        border: Border.all(color: AppColors.blush.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Add your ',
              children: [
                TextSpan(
                  text: "child's",
                  style: AppTypography.serifItalic(22)
                      .copyWith(color: AppColors.blush),
                ),
                const TextSpan(text: ' profile'),
              ],
            ),
            style: text.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'When you match with another parent, we only introduce your '
            'children if both families have a profile for their child.',
            style: text.bodyMedium?.copyWith(color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 16),
          CtaButton(
            label: "Create your child's profile",
            onPressed: () => context.push(Routes.newProfile),
          ),
        ],
      ),
    );
  }
}
