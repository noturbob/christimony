import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../ui/states.dart';
import 'phone_auth.dart';

const _codeLength = 6;

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({required this.phone, super.key});
  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with SingleTickerProviderStateMixin {
  // One hidden field drawn as six cells: typing advances, backspace goes
  // back, and paste / SMS autofill fill every cell, all natively.
  final _code = TextEditingController();
  final _focus = FocusNode();
  late final _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  Timer? _timer;
  late int _cooldown;
  String? _error;
  bool _verifying = false;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    _startCooldown(ref.read(phoneStartProvider).retryAfter);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shake.dispose();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    _cooldown = seconds;
    if (seconds <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _cooldown--);
      if (_cooldown <= 0) t.cancel();
    });
  }

  void _onChanged(String value) {
    setState(() => _error = null);
    if (value.length == _codeLength) unawaited(_verify(value));
  }

  Future<void> _verify(String code) async {
    setState(() => _verifying = true);
    try {
      final result = await ref
          .read(christimonyApiProvider)
          .send(
            Api.phoneVerify,
            fields: {'phone': widget.phone, 'code': code},
            decode: SignInResult.fromJson,
          );
      // The router guard takes it from here.
      await ref.read(sessionProvider.notifier).signIn(result);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = errorText(e));
      _code.clear();
      _focus.requestFocus();
      if (!MediaQuery.disableAnimationsOf(context)) {
        _shake.forward(from: 0);
      }
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _error = null;
    });
    try {
      await ref.read(phoneStartProvider.notifier).send(widget.phone);
      _code.clear();
      _focus.requestFocus();
      _startCooldown(ref.read(phoneStartProvider).retryAfter);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = text.bodyMedium?.copyWith(color: AppColors.mutedForeground);
    final devCode = ref.watch(phoneStartProvider).devCode;

    if (widget.phone.isEmpty) {
      return Scaffold(
        body: EmptyView(
          title: 'No phone number to verify.',
          action: OutlinedButton(
            onPressed: () => context.go(Routes.login),
            child: const Text('Go back'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Almost ',
                      children: [
                        TextSpan(
                          text: 'there.',
                          style: AppTypography.serifItalic(36)
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    style: text.displayMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a 6-digit code to ${widget.phone}.',
                    style: muted,
                  ),
                  if (devCode != null) ...[
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: const ShapeDecoration(
                        color: AppColors.secondary,
                        shape: StadiumBorder(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Dev mode — your code is $devCode',
                          textAlign: TextAlign.center,
                          style: text.bodySmall?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _shake,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(
                        math.sin(_shake.value * math.pi * 6) *
                            8 *
                            (1 - _shake.value),
                        0,
                      ),
                      child: child,
                    ),
                    child: _cells(text),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.destructive,
                      ),
                    ),
                  ],
                  if (_verifying) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Verifying...',
                      textAlign: TextAlign.center,
                      style: muted,
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (_cooldown > 0)
                    Text(
                      'Resend code in ${_cooldown}s',
                      textAlign: TextAlign.center,
                      style: muted,
                    )
                  else
                    TextButton(
                      onPressed: _resending || _verifying ? null : _resend,
                      child: Text(_resending ? 'Sending...' : 'Resend code'),
                    ),
                  TextButton(
                    onPressed: () => context.go(Routes.login),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.mutedForeground,
                    ),
                    child: const Text('Use a different number'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cells(TextTheme text) {
    return ListenableBuilder(
      listenable: Listenable.merge([_code, _focus]),
      builder: (context, _) {
        final value = _code.text;
        return Stack(
          children: [
            Row(
              children: [
                for (var i = 0; i < _codeLength; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppRadii.xl2),
                        border: Border.all(
                          color:
                              _focus.hasFocus &&
                                  i == math.min(value.length, _codeLength - 1)
                              ? AppColors.ring
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          i < value.length ? value[i] : '',
                          style: text.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Positioned.fill(
              child: Semantics(
                label: '6-digit code',
                child: TextField(
                  controller: _code,
                  focusNode: _focus,
                  autofocus: true,
                  enabled: !_verifying,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_codeLength),
                  ],
                  onChanged: _onChanged,
                  showCursor: false,
                  style: const TextStyle(color: Colors.transparent),
                  // Every border explicitly none: collapsed() only clears
                  // `border`, so the theme's outline still drew a box
                  // across the cells.
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
