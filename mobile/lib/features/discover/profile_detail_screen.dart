import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/error_text.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../data/my_profiles.dart';
import '../../domain/models/profile.dart';
import '../../ui/cta_button.dart';
import '../../ui/states.dart';
import 'discover_controller.dart';
import 'match_sheet.dart';
import 'profile_card.dart';

final FutureProviderFamily<Profile, int> profileDetailProvider = FutureProvider
    .autoDispose
    .family<Profile, int>(
      (ref, id) => ref
          .watch(christimonyApiProvider)
          .send(
            Api.showProfile,
            pathArgs: {'id': id},
            decode: (json) => Profile.fromJson(json! as Map<String, dynamic>),
          ),
      retry: (_, _) => null,
    );

const _reportReasons = {
  'spam': 'Spam',
  'inappropriate': 'Inappropriate content',
  'fake_profile': 'Fake profile',
  'harassment': 'Harassment',
  'underage': 'Underage',
  'other': 'Something else',
};

enum _Menu { report, block }

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({required this.profileId, super.key});
  final int profileId;

  @override
  ConsumerState<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  bool _busy = false;
  bool _liked = false;

  void _snack(Object error) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorText(error))));

  /// Keeps the Discover deck in step with what happened here.
  void _dropFromDeck() {
    if (ref.exists(deckProvider)) {
      ref.read(deckProvider.notifier).remove(widget.profileId);
    }
  }

  Future<void> _like(Profile acting, Profile target) async {
    setState(() => _busy = true);
    try {
      final match = await sendLike(
        ref.read(christimonyApiProvider),
        from: acting.id,
        to: target,
      );
      _dropFromDeck();
      if (!mounted) return;
      setState(() => _liked = true);
      if (match != null) await showMatchSheet(context, match);
    } on Object catch (e) {
      if (mounted) _snack(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _report(Profile p) async {
    final thenBlock = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ReportSheet(profile: p),
    );
    if ((thenBlock ?? false) && mounted) await _block(p);
  }

  Future<void> _block(Profile p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text('Block ${p.name}?'),
        content: const Text(
          "You won't see each other anywhere on Christimony, and any "
          'conversation disappears. You can unblock later from your Profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Block'),
          ),
        ],
      ),
    );
    if (!(confirmed ?? false) || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(christimonyApiProvider)
          .send(
            Api.createBlock,
            fields: {'blocked_profile_id': p.id},
            decode: (_) {},
          );
      _dropFromDeck();
      if (!mounted) return;
      context.canPop() ? context.pop() : context.go(Routes.discover);
    } on Object catch (e) {
      if (mounted) {
        _snack(e);
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(profileDetailProvider(widget.profileId));
    final mine = ref.watch(myProfilesProvider).value;
    final acting = ref.watch(browsingAsProvider).value;
    final profile = detail.value;
    final isOwn = mine?.any((p) => p.id == widget.profileId) ?? true;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (profile != null && !isOwn)
            PopupMenuButton<_Menu>(
              tooltip: 'More options',
              enabled: !_busy,
              onSelected: (m) =>
                  m == _Menu.report ? _report(profile) : _block(profile),
              itemBuilder: (_) => const [
                PopupMenuItem(value: _Menu.report, child: Text('Report')),
                PopupMenuItem(value: _Menu.block, child: Text('Block')),
              ],
            ),
        ],
      ),
      body: switch (detail) {
        AsyncData(:final value) => _Body(profile: value),
        AsyncError(error: NotFound()) => EmptyView(
          title: "This profile isn't available",
          message: 'It may have been hidden or removed.',
          action: OutlinedButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(Routes.discover),
            child: const Text('Back'),
          ),
        ),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () =>
              ref.invalidate(profileDetailProvider(widget.profileId)),
        ),
        _ => const LoadingView(),
      },
      bottomNavigationBar: profile == null || isOwn || acting == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: CtaButton(
                label: _liked ? 'Liked' : 'Like',
                onPressed: _liked || _busy
                    ? null
                    : () => _like(acting, profile),
              ),
            ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final gender = p.gender?.toJson();
    return ListView(
      children: [
        PhotoCarousel(photos: p.photos, name: p.name),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              ProfileHeading(profile: p),
              if (p.bio case final bio? when bio.isNotEmpty)
                SectionBlock(label: 'About', text: bio),
              for (final prompt in p.prompts)
                SectionBlock(
                  label: prompt.question,
                  text: prompt.answer,
                  emphasis: true,
                ),
              if (p.education case final edu? when edu.isNotEmpty)
                SectionBlock(label: 'Education', text: edu),
              if (gender != null)
                SectionBlock(
                  label: 'Gender',
                  text: gender[0].toUpperCase() + gender.substring(1),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.profile});

  final Profile profile;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

/// Pops `true` if the user chose to block after reporting.
class _ReportSheetState extends ConsumerState<_ReportSheet> {
  final _details = TextEditingController();
  String? _reason;
  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final details = _details.text.trim();
      await ref
          .read(christimonyApiProvider)
          .send(
            Api.createReport,
            fields: {
              'reported_profile_id': widget.profile.id,
              'reason': _reason,
              if (details.isNotEmpty) 'details': details,
            },
            decode: (_) {},
          );
      if (mounted) setState(() => _sent = true);
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final name = widget.profile.name;
    final muted = text.bodyMedium?.copyWith(color: AppColors.mutedForeground);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: _sent
            ? [
                Text('Thanks for telling us.', style: text.headlineMedium),
                Text(
                  "Our team will review it. Reporting doesn't block them, so "
                  "block them too if you'd rather not see them.",
                  style: muted,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.destructive,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Block $name'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Done'),
                ),
              ]
            : [
                Text('Report $name', style: text.headlineMedium),
                Text(
                  "Reports are private. They won't know it was you.",
                  style: muted,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final MapEntry(:key, :value) in _reportReasons.entries)
                      ChoiceChip(
                        label: Text(value),
                        selected: _reason == key,
                        onSelected: (_) => setState(() => _reason = key),
                      ),
                  ],
                ),
                TextField(
                  controller: _details,
                  maxLength: 1000,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Anything else we should know? (optional)',
                  ),
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: text.bodyMedium?.copyWith(
                      color: AppColors.destructive,
                    ),
                  ),
                CtaButton(
                  label: _sending ? 'Sending…' : 'Send report',
                  onPressed: _reason == null || _sending ? null : _send,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ],
      ),
    );
  }
}
