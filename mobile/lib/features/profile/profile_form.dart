import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/network/api_exception.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/error_text.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/dates.dart';
import '../../data/api/christimony_api.dart';
import '../../domain/models/denomination.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/profile.dart';
import '../../ui/cta_button.dart';

final denominationsProvider = FutureProvider<List<Denomination>>((ref) {
  return ref
      .watch(christimonyApiProvider)
      .send(
        Api.denominations,
        decode: (json) => [
          for (final d in json! as List)
            Denomination.fromJson(d as Map<String, dynamic>),
        ],
      );
});

/// `dob` is a bare civil date: "1998-04-02".
String formatCivilDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// The latest date of birth that is 18 or older on [today].
DateTime latestAdultDob(DateTime today) =>
    DateTime(today.year - 18, today.month, today.day);

/// The profile details form, shared by create and edit. [onSubmit]
/// receives the flat field map; an [ApiException] it throws is shown
/// under the button.
class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({
    required this.submitLabel,
    required this.onSubmit,
    this.initial,
    super.key,
  });

  final Profile? initial;
  final String submitLabel;
  final Future<void> Function(Map<String, Object?> fields) onSubmit;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _city = TextEditingController(text: widget.initial?.city);
  late final _education = TextEditingController(
    text: widget.initial?.education,
  );
  late final _profession = TextEditingController(
    text: widget.initial?.profession,
  );
  late final _bio = TextEditingController(text: widget.initial?.bio);
  late DateTime? _dob = widget.initial?.dob == null
      ? null
      : parseCivilDate(widget.initial!.dob!);
  late Gender? _gender = widget.initial?.gender == Gender.unknown
      ? null
      : widget.initial?.gender;
  late int? _denominationId = widget.initial?.denominationId;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _city, _education, _profession, _bio]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    String? text(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSubmit({
        'name': _name.text.trim(),
        'dob': formatCivilDate(_dob!),
        'gender': _gender?.toJson(),
        'denomination_id': _denominationId,
        'city': text(_city),
        'education': text(_education),
        'profession': text(_profession),
        'bio': text(_bio),
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final denominations = ref.watch(denominationsProvider);
    final denominationItems = denominations.value ?? const [];
    const gap = SizedBox(height: 16);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.words,
            validator: (v) => (v ?? '').trim().isEmpty ? 'Add a name' : null,
          ),
          gap,
          FormField<DateTime>(
            initialValue: _dob,
            validator: (v) => v == null ? 'Add a date of birth' : null,
            builder: (field) => InkWell(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              onTap: () async {
                final last = latestAdultDob(DateTime.now());
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1940),
                  lastDate: last,
                  initialDate: field.value == null || field.value!.isAfter(last)
                      ? DateTime(last.year - 7, last.month, last.day)
                      : field.value,
                  helpText: 'Date of birth (18 or older)',
                );
                if (picked == null) return;
                field.didChange(picked);
                setState(() => _dob = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date of birth',
                  errorText: field.errorText,
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                isEmpty: field.value == null,
                child: Text(
                  field.value == null
                      ? ''
                      : DateFormat.yMMMd().format(field.value!),
                ),
              ),
            ),
          ),
          gap,
          DropdownButtonFormField<Gender>(
            initialValue: _gender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: const [
              DropdownMenuItem(value: Gender.female, child: Text('Woman')),
              DropdownMenuItem(value: Gender.male, child: Text('Man')),
            ],
            validator: (v) => v == null ? 'Choose one' : null,
            onChanged: (v) => _gender = v,
          ),
          gap,
          DropdownButtonFormField<int>(
            key: ValueKey(denominationItems.length),
            initialValue: denominationItems.any((d) => d.id == _denominationId)
                ? _denominationId
                : null,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Denomination',
              helperText: denominations.hasError
                  ? "Couldn't load the list."
                  : null,
              suffixIcon: denominations.hasError
                  ? IconButton(
                      tooltip: 'Retry',
                      icon: const Icon(Icons.refresh),
                      onPressed: () => ref.invalidate(denominationsProvider),
                    )
                  : null,
            ),
            items: [
              for (final d in denominationItems)
                DropdownMenuItem(
                  value: d.id,
                  child: Text(d.name, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (v) => _denominationId = v,
          ),
          gap,
          TextFormField(
            controller: _city,
            decoration: const InputDecoration(labelText: 'City'),
            textCapitalization: TextCapitalization.words,
          ),
          gap,
          TextFormField(
            controller: _education,
            decoration: const InputDecoration(labelText: 'Education'),
          ),
          gap,
          TextFormField(
            controller: _profession,
            decoration: const InputDecoration(labelText: 'Profession'),
          ),
          gap,
          TextFormField(
            controller: _bio,
            decoration: const InputDecoration(
              labelText: 'Bio',
              alignLabelWithHint: true,
            ),
            minLines: 3,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
          ),
          if (_error != null) ...[
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.destructive),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          CtaButton(
            label: _busy ? 'Saving…' : widget.submitLabel,
            onPressed: _busy ? null : _submit,
          ),
        ],
      ),
    );
  }
}
