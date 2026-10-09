import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/endpoints.dart';
import '../../core/theme/tokens.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/prompt.dart';
import 'widgets.dart';

const promptCount = 3;

final promptQuestionsProvider = FutureProvider<List<String>>((ref) {
  return ref
      .watch(christimonyApiProvider)
      .send(
        Api.promptQuestions,
        decode: (json) => [for (final q in json! as List) q as String],
      );
});

/// Lists, edits, adds and removes a profile's prompts. Activation needs
/// exactly [promptCount].
class PromptEditor extends ConsumerStatefulWidget {
  const PromptEditor({
    required this.profileId,
    required this.prompts,
    required this.isActive,
    required this.onChanged,
    super.key,
  });

  final int profileId;
  final List<Prompt> prompts;
  final bool isActive;
  final ValueChanged<List<Prompt>> onChanged;

  @override
  ConsumerState<PromptEditor> createState() => _PromptEditorState();
}

class _PromptEditorState extends ConsumerState<PromptEditor> {
  bool _busy = false;

  ChristimonyApi get _api => ref.read(christimonyApiProvider);

  Prompt _decode(Object? json) =>
      Prompt.fromJson(json! as Map<String, dynamic>);

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    await runWithSnack(context, action);
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _edit(Prompt prompt) async {
    final answer = await showDialog<String>(
      context: context,
      builder: (_) =>
          _AnswerDialog(question: prompt.question, initial: prompt.answer),
    );
    if (answer == null || answer == prompt.answer || !mounted) return;
    await _run(() async {
      final updated = await _api.send(
        Api.updatePrompt,
        pathArgs: {'pid': widget.profileId, 'id': prompt.id},
        fields: {'answer': answer},
        decode: _decode,
      );
      widget.onChanged([
        for (final p in widget.prompts)
          if (p.id == prompt.id) updated else p,
      ]);
    });
  }

  Future<void> _delete(Prompt prompt) async {
    if (widget.isActive && widget.prompts.length <= promptCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An active profile needs $promptCount prompts. Edit this one '
            'instead, or pause the profile.',
          ),
        ),
      );
      return;
    }
    final ok = await confirm(
      context,
      title: 'Remove this prompt?',
      message: prompt.question,
      action: 'Remove',
    );
    if (!ok || !mounted) return;
    await _run(() async {
      await _api.send<void>(
        Api.deletePrompt,
        pathArgs: {'pid': widget.profileId, 'id': prompt.id},
        decode: (_) {},
      );
      widget.onChanged([
        for (final p in widget.prompts)
          if (p.id != prompt.id) p,
      ]);
    });
  }

  Future<void> _add() async {
    final used = {for (final p in widget.prompts) p.question};
    List<String> questions;
    try {
      questions = await ref.read(promptQuestionsProvider.future);
    } on Object {
      ref.invalidate(promptQuestionsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't load prompts. Try again.")),
        );
      }
      return;
    }
    if (!mounted) return;

    final question = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final q in questions)
              if (!used.contains(q))
                ListTile(
                  title: Text(q),
                  onTap: () => Navigator.pop(context, q),
                ),
          ],
        ),
      ),
    );
    if (question == null || !mounted) return;
    final answer = await showDialog<String>(
      context: context,
      builder: (_) => _AnswerDialog(question: question),
    );
    if (answer == null || !mounted) return;

    await _run(() async {
      final created = await _api.send(
        Api.createPrompt,
        pathArgs: {'pid': widget.profileId},
        fields: {'question': question, 'answer': answer},
        decode: _decode,
      );
      widget.onChanged([...widget.prompts, created]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final p in widget.prompts)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
              title: Text(
                p.question,
                style: text.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(p.answer, style: text.bodyLarge),
              ),
              onTap: _busy ? null : () => _edit(p),
              trailing: IconButton(
                tooltip: 'Remove prompt',
                icon: const Icon(Icons.delete_outline),
                onPressed: _busy ? null : () => _delete(p),
              ),
            ),
          ),
        if (widget.prompts.length < promptCount)
          OutlinedButton.icon(
            onPressed: _busy ? null : _add,
            icon: const Icon(Icons.add),
            label: Text(
              'Add a prompt (${widget.prompts.length} of $promptCount)',
            ),
          ),
        if (widget.prompts.length > promptCount)
          Text(
            'Profiles show $promptCount prompts — remove '
            '${widget.prompts.length - promptCount} to activate.',
            style: text.bodySmall?.copyWith(color: AppColors.mutedForeground),
          ),
      ],
    );
  }
}

class _AnswerDialog extends StatefulWidget {
  const _AnswerDialog({required this.question, this.initial});

  final String question;
  final String? initial;

  @override
  State<_AnswerDialog> createState() => _AnswerDialogState();
}

class _AnswerDialogState extends State<_AnswerDialog> {
  late final _answer = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.question),
    content: TextField(
      controller: _answer,
      autofocus: true,
      minLines: 2,
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(hintText: 'Your answer'),
      onChanged: (_) => setState(() {}),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: _answer.text.trim().isEmpty
            ? null
            : () => Navigator.pop(context, _answer.text.trim()),
        child: const Text('Save'),
      ),
    ],
  );
}
