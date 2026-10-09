import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/error_text.dart';
import '../../core/session/session_controller.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../data/api/christimony_api.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/introduction.dart';
import '../../domain/models/profile.dart';
import '../../ui/avatar.dart';
import '../../ui/cta_button.dart';
import '../../ui/states.dart';

final introductionsProvider = FutureProvider<List<Introduction>>((ref) {
  return ref
      .watch(christimonyApiProvider)
      .send(
        Api.listIntroductions,
        decode: (json) => [
          for (final i in json! as List)
            Introduction.fromJson(i as Map<String, dynamic>),
        ],
      );
});

/// The ward on our side of [intro] -- the one we answer for.
WardSummary myWardIn(Introduction intro, Set<int> myProfileIds) =>
    myProfileIds.contains(intro.wardA.id) ? intro.wardA : intro.wardB;

String introductionStatusLabel(Introduction intro, int myWardId) =>
    switch (intro.status) {
      IntroductionStatus.accepted => 'Both accepted — check Matches',
      IntroductionStatus.declined => 'Declined',
      IntroductionStatus.pendingBoth => 'Awaiting a response from both sides',
      IntroductionStatus.pendingA =>
        myWardId == intro.wardA.id
            ? 'Waiting on you'
            : 'Waiting on the other family',
      IntroductionStatus.pendingB =>
        myWardId == intro.wardB.id
            ? 'Waiting on you'
            : 'Waiting on the other family',
      IntroductionStatus.unknown => '',
    };

bool canRespond(Introduction intro, int myWardId) => switch (intro.status) {
  IntroductionStatus.pendingBoth => true,
  IntroductionStatus.pendingA => myWardId == intro.wardA.id,
  IntroductionStatus.pendingB => myWardId == intro.wardB.id,
  _ => false,
};

/// A parent match only becomes an introduction when both parents have a
/// ward profile -- without one, nothing ever shows up here, silently.
bool needsWardProfile(AccountType? type, List<Profile>? profiles) =>
    type == AccountType.parent &&
    profiles != null &&
    !profiles.any((p) => p.profileType == ProfileType.ward);

class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final accountType = ref.watch(currentAccountProvider)?.accountType;
    final profiles = ref.watch(myProfilesProvider);
    final intros = ref.watch(introductionsProvider);

    Future<void> refresh() => Future.wait([
      ref.refresh(introductionsProvider.future),
      ref.refresh(myProfilesProvider.future),
    ]);

    final Widget body;
    if (intros.hasError || profiles.hasError) {
      body = ErrorView(
        error: (intros.error ?? profiles.error)!,
        onRetry: () => ref
          ..invalidate(introductionsProvider)
          ..invalidate(myProfilesProvider),
      );
    } else if (!intros.hasValue || !profiles.hasValue) {
      body = const Padding(padding: EdgeInsets.all(32), child: LoadingView());
    } else if (intros.requireValue.isEmpty) {
      body = EmptyView(
        title: 'No introductions yet',
        message: accountType == AccountType.parent
            ? 'They appear here when you and another parent both express interest.'
            : 'Family is for parents finding a match for their child. When '
                  "two parents' profiles match, their children are "
                  'introduced here.',
      );
    } else {
      final myIds = {for (final p in profiles.requireValue) p.id};
      body = Column(
        children: [
          for (final intro in intros.requireValue)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IntroductionCard(
                key: ValueKey(intro.id),
                intro: intro,
                myProfileIds: myIds,
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Family')),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text.rich(
              TextSpan(
                text: 'Your ',
                children: [
                  TextSpan(
                    text: 'introductions',
                    style: AppTypography.serifItalic(30)
                        .copyWith(color: AppColors.blush),
                  ),
                ],
              ),
              style: text.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'When you and another parent both express interest, your '
              'children are introduced here — nothing opens between them '
              'until they each say yes.',
              style: text.bodyLarge?.copyWith(color: AppColors.mutedForeground),
            ),
            const SizedBox(height: 24),
            if (needsWardProfile(accountType, profiles.value)) ...[
              const WardBanner(),
              const SizedBox(height: 24),
            ],
            body,
          ],
        ),
      ),
    );
  }
}

class WardBanner extends StatelessWidget {
  const WardBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.blush.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadii.xl3),
        border: Border.all(color: AppColors.blush.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
              style: text.bodyMedium?.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            CtaButton(
              label: "Create your child's profile",
              onPressed: () => context.push(Routes.newProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroductionCard extends ConsumerStatefulWidget {
  const IntroductionCard({
    required this.intro,
    required this.myProfileIds,
    super.key,
  });

  final Introduction intro;
  final Set<int> myProfileIds;

  @override
  ConsumerState<IntroductionCard> createState() => _IntroductionCardState();
}

class _IntroductionCardState extends ConsumerState<IntroductionCard> {
  late Introduction _intro = widget.intro;
  bool _busy = false;

  @override
  void didUpdateWidget(IntroductionCard old) {
    super.didUpdateWidget(old);
    if (old.intro != widget.intro) _intro = widget.intro;
  }

  Future<void> _respond(Endpoint endpoint, int wardId) async {
    setState(() => _busy = true);
    try {
      final updated = await ref
          .read(christimonyApiProvider)
          .send(
            endpoint,
            pathArgs: {'id': _intro.id},
            fields: {'ward_profile_id': wardId},
            decode: (json) =>
                Introduction.fromJson(json! as Map<String, dynamic>),
          );
      if (mounted) setState(() => _intro = updated);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorText(e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _decline(int wardId, String otherName) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline this introduction?'),
        content: Text(
          "This can't be undone — you won't be introduced to $otherName "
          'again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
    if (ok ?? false) await _respond(Api.declineIntroduction, wardId);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final mine = myWardIn(_intro, widget.myProfileIds);
    final other = mine.id == _intro.wardA.id ? _intro.wardB : _intro.wardA;
    final respond = canRespond(_intro, mine.id);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Avatar(name: other.name),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(other.name, style: text.titleMedium),
                      Text(
                        [?other.city, 'For ${mine.name}'].join(' · '),
                        style: text.bodySmall?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              introductionStatusLabel(_intro, mine.id),
              style: text.bodyMedium?.copyWith(
                color: _intro.status == IntroductionStatus.accepted
                    ? AppColors.blush
                    : AppColors.mutedForeground,
              ),
            ),
            if (respond) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 48),
                      side: const BorderSide(color: AppColors.blush),
                    ),
                    onPressed: _busy
                        ? null
                        : () => _respond(Api.acceptIntroduction, mine.id),
                    child: const Text('Accept'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(96, 48),
                      foregroundColor: AppColors.mutedForeground,
                    ),
                    onPressed: _busy
                        ? null
                        : () => _decline(mine.id, other.name),
                    child: const Text('Decline'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
