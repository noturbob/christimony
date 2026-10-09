import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/endpoints.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/verification.dart';
import '../../ui/states.dart';
import 'widgets.dart';

final verificationsProvider = FutureProvider<List<Verification>>((ref) {
  return ref
      .watch(christimonyApiProvider)
      .send(
        Api.listVerifications,
        decode: (json) => [
          for (final v in json! as List)
            Verification.fromJson(v as Map<String, dynamic>),
        ],
      );
});

// Phone OTP is verified automatically at sign-in, so it isn't offered.
const List<(VerificationType, String, String)> _types = [
  (
    VerificationType.governmentId,
    'Government ID',
    'A government-issued photo ID.',
  ),
  (
    VerificationType.selfieLiveness,
    'Selfie check',
    "A quick photo to confirm you're a real person.",
  ),
  (VerificationType.videoKyc, 'Video call', 'A short call with our team.'),
  (VerificationType.emailOtp, 'Email address', 'Confirm your email address.'),
];

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final verifications = ref.watch(verificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(verificationsProvider.future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
          children: [
            Text(
              'Verified accounts are trusted more, and matched more often.',
              style: text.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Requests are reviewed by hand for now — in-app capture is '
              "coming soon. We'll mark each one verified once it's reviewed.",
              style: text.bodyMedium?.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            ...switch (verifications) {
              AsyncValue(:final error?) => [
                ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(verificationsProvider),
                ),
              ],
              AsyncValue(:final value?) => [
                for (final (type, title, description) in _types)
                  _VerificationTile(
                    type: type,
                    title: title,
                    description: description,
                    current: _latest(value, type),
                  ),
              ],
              _ => [const LoadingView()],
            },
          ],
        ),
      ),
    );
  }

  /// A verified record wins; otherwise the most recent request.
  static Verification? _latest(List<Verification> all, VerificationType t) {
    final mine = all.where((v) => v.verificationType == t).toList();
    return mine
            .where((v) => v.status == VerificationStatus.verified)
            .firstOrNull ??
        mine.lastOrNull;
  }
}

class _VerificationTile extends ConsumerStatefulWidget {
  const _VerificationTile({
    required this.type,
    required this.title,
    required this.description,
    required this.current,
  });

  final VerificationType type;
  final String title;
  final String description;
  final Verification? current;

  @override
  ConsumerState<_VerificationTile> createState() => _VerificationTileState();
}

class _VerificationTileState extends ConsumerState<_VerificationTile> {
  bool _busy = false;

  Future<void> _request() async {
    setState(() => _busy = true);
    await runWithSnack(context, () async {
      await ref
          .read(christimonyApiProvider)
          .send<void>(
            Api.createVerification,
            fields: {'verification_type': widget.type.toJson()},
            decode: (_) {},
          );
      ref.invalidate(verificationsProvider);
      await ref.read(verificationsProvider.future);
    });
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final status = widget.current?.status;
    final trailing = switch (status) {
      VerificationStatus.verified => Text(
        'Verified',
        style: text.labelLarge?.copyWith(color: AppColors.primary),
      ),
      VerificationStatus.pending => Text(
        'In review',
        style: text.labelLarge?.copyWith(color: AppColors.mutedForeground),
      ),
      _ => OutlinedButton(
        style: OutlinedButton.styleFrom(minimumSize: const Size(96, 48)),
        onPressed: _busy ? null : _request,
        child: Text(
          status == VerificationStatus.rejected ? 'Try again' : 'Request',
        ),
      ),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    status == VerificationStatus.rejected
                        ? 'Not approved last time. You can ask again.'
                        : widget.description,
                    style: text.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}
