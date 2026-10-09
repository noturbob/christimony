import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/router/routes.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/error_text.dart';
import '../../core/push/push_service.dart';
import '../../core/session/session_controller.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import 'widgets.dart';

const deletePhrase = 'DELETE';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool? _pushEnabled;
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      SharedPreferences.getInstance().then((prefs) {
        if (mounted) {
          setState(() => _pushEnabled = prefs.getBool(pushEnabledKey) ?? true);
        }
      }),
    );
  }

  Future<void> _setPush(bool on) async {
    setState(() => _pushEnabled = on);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(pushEnabledKey, on);
    await ref.read(pushServiceProvider)?.sync();
  }

  Future<void> _logout() async {
    setState(() => _loggingOut = true);
    await ref.read(sessionProvider.notifier).logout();
  }

  Future<void> _delete() async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const DeleteAccountDialog(),
    );
    if (deleted ?? false) await ref.read(sessionProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
        children: [
          const SectionLabel('Notifications'),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.antiAlias,
            child: SwitchListTile(
              title: const Text('Push notifications'),
              subtitle: const Text('Messages, matches and introductions'),
              value: _pushEnabled ?? true,
              onChanged: _pushEnabled == null ? null : _setPush,
            ),
          ),
          const SectionLabel('Safety'),
          NavTile(
            title: 'Blocked people',
            leading: const Icon(Icons.block),
            onTap: () => context.push(Routes.blocked),
          ),
          const SectionLabel('Account'),
          NavTile(
            title: 'Log out',
            leading: const Icon(Icons.logout),
            trailing: _loggingOut
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const SizedBox.shrink(),
            onTap: _loggingOut ? () {} : _logout,
          ),
          if (kDebugMode)
            NavTile(
              title: 'Design gallery',
              leading: const Icon(Icons.palette_outlined),
              onTap: () => context.push(Routes.gallery),
            ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.destructive,
                minimumSize: const Size(48, 48),
              ),
              onPressed: _delete,
              child: const Text('Delete account'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pops `true` once `DELETE /me` succeeded. The button stays disabled
/// until [deletePhrase] is typed exactly.
class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  ConsumerState<DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(christimonyApiProvider)
          .send<void>(Api.deleteMe, decode: (_) {});
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = errorText(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final armed = _confirm.text == deletePhrase && !_busy;
    return AlertDialog(
      title: const Text('Delete your account?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This permanently deletes your account and every profile you '
              'own — photos, matches, conversations and introductions. It '
              "can't be undone.",
            ),
            const SizedBox(height: 16),
            Text.rich(
              const TextSpan(
                text: 'Type ',
                children: [
                  TextSpan(
                    text: deletePhrase,
                    style: TextStyle(
                      color: AppColors.destructive,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' to confirm'),
                ],
              ),
              style: text.bodyMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _confirm,
              autocorrect: false,
              enableSuggestions: false,
              enabled: !_busy,
              decoration: const InputDecoration(hintText: deletePhrase),
              onChanged: (_) => setState(() {}),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: text.bodySmall?.copyWith(color: AppColors.destructive),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.destructive),
          onPressed: armed ? _delete : null,
          child: Text(_busy ? 'Deleting…' : 'Delete forever'),
        ),
      ],
    );
  }
}
