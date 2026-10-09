import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/error_text.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/profile.dart';
import 'chat_data.dart';

/// Confirms, then blocks. Resolves true once blocked.
Future<bool> confirmBlock(BuildContext context, ProfileSummary profile) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => _BlockDialog(profile),
    ) ??
    false;

/// Reports (which doesn't block). Resolves true if the user then chose to
/// block too, and that went through.
Future<bool> showReport(BuildContext context, ProfileSummary profile) async {
  final blockNext = await showDialog<bool>(
    context: context,
    builder: (_) => _ReportDialog(profile),
  );
  if (blockNext != true || !context.mounted) return false;
  return await confirmBlock(context, profile);
}

class _BlockDialog extends ConsumerStatefulWidget {
  const _BlockDialog(this.profile);
  final ProfileSummary profile;

  @override
  ConsumerState<_BlockDialog> createState() => _BlockDialogState();
}

class _BlockDialogState extends ConsumerState<_BlockDialog> {
  var _busy = false;
  String? _error;

  Future<void> _block() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await blockProfile(ref.read(christimonyApiProvider), widget.profile.id);
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorText(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Block ${widget.profile.name}?'),
    content: Text(
      _error ??
          "You won't see each other anywhere on Christimony, and any "
              'conversation disappears. You can unblock later from your '
              'Profile.',
      style: _error == null
          ? null
          : const TextStyle(color: AppColors.destructive),
    ),
    actions: [
      TextButton(
        onPressed: _busy ? null : () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: _busy ? null : _block,
        style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
        child: Text(_busy ? 'Blocking...' : 'Block'),
      ),
    ],
  );
}

class _ReportDialog extends ConsumerStatefulWidget {
  const _ReportDialog(this.profile);
  final ProfileSummary profile;

  @override
  ConsumerState<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<_ReportDialog> {
  final _details = TextEditingController();
  ReportReason? _reason;
  var _busy = false;
  var _sent = false;
  String? _error;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await reportProfile(
        ref.read(christimonyApiProvider),
        widget.profile.id,
        _reason!,
        _details.text.trim(),
      );
      if (mounted) setState(() => _sent = true);
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.profile.name;
    if (_sent) {
      return AlertDialog(
        title: const Text('Thanks for telling us.'),
        content: const Text(
          "Our team will review it. Reporting doesn't block them, so block "
          "them too if you'd rather not see them.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
            child: Text('Block $name'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text('Report $name'),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Reports are private. They won't know it was you."),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final r in ReportReason.values)
                ChoiceChip(
                  label: Text(r.label),
                  selected: _reason == r,
                  onSelected: _busy ? null : (_) => setState(() => _reason = r),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _details,
            maxLength: 1000,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Anything else we should know? (optional)',
            ),
          ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: AppColors.destructive)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _reason == null || _busy ? null : _submit,
          child: Text(_busy ? 'Sending...' : 'Send report'),
        ),
      ],
    );
  }
}
