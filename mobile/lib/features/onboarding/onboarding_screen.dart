import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../app/router/routes.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/error_text.dart';
import '../../core/theme/motion.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/dates.dart';
import '../../domain/models/photo.dart';
import '../../ui/cta_button.dart';
import '../../ui/states.dart';
import 'onboarding_controller.dart';
import 'onboarding_draft.dart';

/// The 11-step wizard, ported from `web/app/onboarding/[step]/page.tsx`.
/// One screen for every step: the router keeps it mounted across steps,
/// so the progress bar and step transition animate between them.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({required this.step, super.key});
  final String step;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _busy = false;
  bool _uploading = false;
  String? _error;

  int get _index => onboardingSteps.indexOf(widget.step);
  OnboardingController get _controller => ref.read(onboardingProvider.notifier);

  @override
  void didUpdateWidget(OnboardingScreen old) {
    super.didUpdateWidget(old);
    if (old.step != widget.step) _error = null;
  }

  void _goTo(String step) {
    _controller.edit((d) => d.copyWith(step: step));
    context.go(Routes.onboardingStep(step));
  }

  void _back() => _goTo(onboardingSteps[_index - 1]);

  Future<void> _run(
    Future<void> Function() action, {
    bool advance = true,
  }) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted && advance && _index < onboardingSteps.length - 1) {
        _goTo(onboardingSteps[_index + 1]);
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _next() => _run(switch (widget.step) {
    'account-type' => _controller.saveAccountType,
    'education' => _controller.saveBasics,
    'prompts' => _controller.savePrompts,
    'bio' => _controller.saveBio,
    'review' => _controller.finish,
    _ => () async {},
  });

  /// Where this step should send the user instead, if anywhere.
  String? _redirect(OnboardingDraft d) {
    if (_index == -1) return onboardingSteps.first;
    final resume = _controller.takeResumeStep(widget.step);
    if (resume != null) return resume;
    // Photos onward attach to the profile created on leaving `education`.
    final needsProfile = _index > onboardingSteps.indexOf('education');
    return needsProfile && d.profileId == null ? 'education' : null;
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(onboardingProvider);
    return Scaffold(
      body: SafeArea(
        child: switch (draft) {
          AsyncData(:final value) => _wizard(value),
          AsyncError(:final error) => ErrorView(
            error: error,
            onRetry: () => ref.invalidate(onboardingProvider),
          ),
          _ => const LoadingView(),
        },
      ),
    );
  }

  Widget _wizard(OnboardingDraft d) {
    final redirect = _redirect(d);
    if (redirect != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _goTo(redirect);
      });
      return const LoadingView();
    }

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final text = Theme.of(context).textTheme;
    final isReview = widget.step == 'review';

    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_busy) _back();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
            child: Row(
              children: [
                if (_index > 0)
                  IconButton(
                    onPressed: _busy ? null : _back,
                    tooltip: 'Back',
                    icon: const Icon(Icons.chevron_left),
                  )
                else
                  const SizedBox(width: 48),
                const SizedBox(width: 8),
                Expanded(
                  child: _ProgressBar(
                    value: (_index + 1) / onboardingSteps.length,
                    animate: !reduceMotion,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: reduceMotion ? Duration.zero : Motion.step,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                final dx = child.key == ValueKey(widget.step) ? 24.0 : -24.0;
                return FadeTransition(
                  opacity: animation,
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (_, c) => Transform.translate(
                      offset: Offset(dx * (1 - animation.value), 0),
                      child: c,
                    ),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                key: ValueKey(widget.step),
                padding: const EdgeInsets.all(24),
                child: _stepBody(d),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: text.bodyMedium?.copyWith(
                      color: AppColors.destructive,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                CtaButton(
                  label: _busy
                      ? 'Saving...'
                      : isReview
                      ? 'Start browsing'
                      : 'Continue',
                  onPressed: _busy || _uploading || !canContinue(widget.step, d)
                      ? null
                      : _next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepBody(OnboardingDraft d) {
    final child = d.forChild;
    final c = _controller;
    return switch (widget.step) {
      'account-type' => _Frame(
        title: 'Who is this for?',
        subtitle:
            "Parents: you'll build your child's profile next, so other "
            'families can be introduced to them.',
        children: [
          _Option(
            label: 'Myself',
            description: "I'm creating my own profile.",
            selected: d.accountType == 'individual',
            onTap: () => c.edit((d) => d.copyWith(accountType: 'individual')),
          ),
          _Option(
            label: 'My child',
            description: "I'm a parent helping guide my child's search.",
            selected: d.accountType == 'parent',
            onTap: () => c.edit((d) => d.copyWith(accountType: 'parent')),
          ),
        ],
      ),
      'name' => _Frame(
        title: child ? "What's your child's name?" : "What's your name?",
        children: [
          _Field(
            initial: d.name,
            hint: 'Full name',
            autofocus: true,
            capitalization: TextCapitalization.words,
            onChanged: (v) => c.edit((d) => d.copyWith(name: v)),
          ),
        ],
      ),
      'dob' => _Frame(
        title: child ? 'When were they born?' : 'When were you born?',
        children: [
          OutlinedButton.icon(
            onPressed: () => _pickDob(d),
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text(
              d.dob.isEmpty
                  ? 'Choose a date'
                  : DateFormat.yMMMMd().format(parseCivilDate(d.dob)),
            ),
          ),
          if (d.dob.isNotEmpty && !isAdult(d.dob))
            _ErrorText(
              '${child ? 'Your child' : 'You'} must be 18 or older to join '
              'Christimony.',
            ),
        ],
      ),
      'gender' => _Frame(
        title: child ? 'My child is...' : 'I am...',
        children: [
          for (final (value, label) in [('male', 'Male'), ('female', 'Female')])
            _Option(
              label: label,
              selected: d.gender == value,
              onTap: () => c.edit((d) => d.copyWith(gender: value)),
            ),
        ],
      ),
      'denomination' => _Frame(
        title: child ? 'Their denomination?' : "What's your denomination?",
        subtitle: 'Optional, but helps us match well.',
        children: [_denominations(d)],
      ),
      'city' => _Frame(
        title: child ? 'Where are they based?' : 'Where are you based?',
        children: [
          _Field(
            initial: d.city,
            hint: 'City',
            autofocus: true,
            capitalization: TextCapitalization.words,
            onChanged: (v) => c.edit((d) => d.copyWith(city: v)),
          ),
        ],
      ),
      'education' => _Frame(
        title: 'Education & work',
        subtitle: 'Optional — you can always add this later.',
        children: [
          _Field(
            initial: d.education,
            hint: 'Education',
            onChanged: (v) => c.edit((d) => d.copyWith(education: v)),
          ),
          _Field(
            initial: d.profession,
            hint: 'Profession',
            onChanged: (v) => c.edit((d) => d.copyWith(profession: v)),
          ),
        ],
      ),
      'photos' => _Frame(
        title: child ? 'Add their photos' : 'Add your photos',
        subtitle:
            'At least $minPhotos photos help people take your profile '
            'seriously.',
        children: [_photos(d)],
      ),
      'prompts' => _Frame(
        title: 'Answer $requiredPrompts prompts',
        subtitle:
            'These show up on your profile — pick ones that feel like you.',
        children: [_prompts(d)],
      ),
      'bio' => _Frame(
        title: child ? 'Tell their story' : 'Tell your story',
        subtitle: child
            ? 'A few sentences about your child and the family you hope '
                  "they'll join."
            : "A few sentences about you and what you're looking for.",
        children: [
          _Field(
            initial: d.bio,
            hint: "I'm someone who...",
            autofocus: true,
            maxLines: 6,
            onChanged: (v) => c.edit((d) => d.copyWith(bio: v)),
          ),
        ],
      ),
      'review' => _Frame(
        title: 'Ready to go',
        subtitle: child
            ? "Here's what other families will see first."
            : "Here's what people will see first.",
        children: [_review(d)],
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Future<void> _pickDob(OnboardingDraft d) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: d.dob.isEmpty
          ? DateTime(now.year - 25, now.month, now.day)
          : parseCivilDate(d.dob),
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked == null) return;
    _controller.edit(
      (d) => d.copyWith(dob: DateFormat('yyyy-MM-dd').format(picked)),
    );
  }

  Widget _denominations(OnboardingDraft d) {
    return switch (ref.watch(denominationsProvider)) {
      AsyncData(:final value) when value.isEmpty => const EmptyView(
        title: 'Nothing to choose from yet',
        message: 'You can skip this step.',
      ),
      AsyncData(:final value) => Column(
        children: [
          for (final denomination in value)
            _Option(
              label: denomination.name,
              compact: true,
              selected: d.denominationId == denomination.id,
              onTap: () => _controller.edit(
                (d) => d.denominationId == denomination.id
                    ? d.copyWith(denominationId: null, denominationName: '')
                    : d.copyWith(
                        denominationId: denomination.id,
                        denominationName: denomination.name,
                      ),
              ),
            ),
        ],
      ),
      AsyncError(:final error) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(denominationsProvider),
      ),
      _ => const Padding(padding: EdgeInsets.all(32), child: LoadingView()),
    };
  }

  Future<void> _addPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _uploading = true;
      _error = null;
    });
    try {
      final jpeg =
          await FlutterImageCompress.compressWithFile(
            file.path,
            minWidth: 1600,
            minHeight: 1600,
            quality: 85,
          ) ??
          await file.readAsBytes();
      await _controller.addPhoto(jpeg);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _removePhoto(PhotoRef photo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(() => _controller.removePhoto(photo), advance: false);
  }

  Widget _photos(OnboardingDraft d) {
    final muted = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: AppColors.mutedForeground);
    final radius = BorderRadius.circular(AppRadii.xl2);
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 4 / 5,
          children: [
            for (final photo in d.photos)
              Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: radius,
                    child: CachedNetworkImage(
                      imageUrl: photo.thumbUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) =>
                          const ColoredBox(color: AppColors.secondary),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      tooltip: 'Remove photo',
                      onPressed: _busy ? null : () => _removePhoto(photo),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.scrim,
                      ),
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),
            Semantics(
              button: true,
              label: 'Add a photo',
              child: InkWell(
                onTap: _uploading || _busy ? null : _addPhoto,
                borderRadius: radius,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(color: AppColors.border, width: 2),
                  ),
                  child: Center(
                    child: _uploading
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : const Icon(
                            Icons.add,
                            color: AppColors.mutedForeground,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('${d.photos.length} of $minPhotos minimum added', style: muted),
      ],
    );
  }

  Widget _prompts(OnboardingDraft d) {
    final text = Theme.of(context).textTheme;
    return switch (ref.watch(promptQuestionsProvider)) {
      AsyncData(:final value) => Column(
        children: [
          for (final question in value)
            Builder(
              builder: (context) {
                final selected = d.answers.containsKey(question);
                final full = d.answers.length >= requiredPrompts;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _Card(
                    selected: selected,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: selected || !full
                              ? () => _controller.toggleQuestion(question)
                              : null,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 48),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                question,
                                style: text.titleSmall?.copyWith(
                                  color: selected || !full
                                      ? AppColors.foreground
                                      : AppColors.mutedForeground,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (selected)
                          _Field(
                            key: ValueKey(question),
                            initial: d.answers[question]!,
                            hint: 'Your answer',
                            autofocus: true,
                            maxLines: 3,
                            onChanged: (v) => _controller.edit(
                              (d) => d.copyWith(
                                answers: {...d.answers, question: v},
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          Text(
            '${d.answers.length} of $requiredPrompts selected',
            style: text.bodyMedium?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
      ),
      AsyncError(:final error) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(promptQuestionsProvider),
      ),
      _ => const Padding(padding: EdgeInsets.all(32), child: LoadingView()),
    };
  }

  Widget _review(OnboardingDraft d) {
    final text = Theme.of(context).textTheme;
    final muted = text.bodyMedium?.copyWith(color: AppColors.mutedForeground);
    final details = [
      d.city,
      d.denominationName,
      d.profession,
    ].where((s) => s.trim().isNotEmpty).join(' · ');
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(d.name, style: text.headlineSmall),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(details, style: muted),
          ],
          const SizedBox(height: 4),
          Text(
            '${d.photos.length} photos · ${d.answers.length} prompts',
            style: muted,
          ),
          if (d.bio.trim().isNotEmpty) ...[
            const Divider(height: 24),
            Text(d.bio, style: text.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.animate});
  final double value;
  final bool animate;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: value),
    duration: animate ? Motion.progress : Duration.zero,
    curve: Curves.easeOut,
    builder: (_, v, _) => Container(
      height: 6,
      decoration: const ShapeDecoration(
        color: AppColors.secondary,
        shape: StadiumBorder(),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: v,
        child: const DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.primary,
            shape: StadiumBorder(),
          ),
          child: SizedBox.expand(),
        ),
      ),
    ),
  );
}

class _Frame extends StatelessWidget {
  const _Frame({required this.title, required this.children, this.subtitle});
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: text.displaySmall),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: text.bodyMedium?.copyWith(color: AppColors.mutedForeground),
          ),
        ],
        const SizedBox(height: 24),
        for (final (i, child) in children.indexed) ...[
          if (i > 0) const SizedBox(height: 12),
          child,
        ],
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.selected = false});
  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: Motion.fast,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.05)
          : AppColors.card,
      borderRadius: BorderRadius.circular(AppRadii.xl2),
      border: Border.all(
        color: selected ? AppColors.primary : AppColors.border,
      ),
    ),
    child: child,
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
    this.description,
    this.compact = false,
  });

  final String label;
  final String? description;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 0),
      child: Semantics(
        selected: selected,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.xl2),
          child: _Card(
            selected: selected,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: text.titleMedium),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A text field seeded once from the draft, reporting every change.
class _Field extends StatefulWidget {
  const _Field({
    required this.initial,
    required this.hint,
    required this.onChanged,
    this.autofocus = false,
    this.maxLines = 1,
    this.capitalization = TextCapitalization.sentences,
    super.key,
  });

  final String initial;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final int maxLines;
  final TextCapitalization capitalization;

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    autofocus: widget.autofocus,
    minLines: 1,
    maxLines: widget.maxLines,
    textCapitalization: widget.capitalization,
    onChanged: widget.onChanged,
    decoration: InputDecoration(hintText: widget.hint),
  );
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);
  final String message;

  @override
  Widget build(BuildContext context) => Text(
    message,
    style: Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: AppColors.destructive),
  );
}
