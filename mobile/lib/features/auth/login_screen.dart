import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../app/router/routes.dart';
import '../../core/config/app_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/error_text.dart';
import '../../core/session/session_controller.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../data/api/christimony_api.dart';
import '../../ui/cta_button.dart';
import '../../ui/logo_mark.dart';
import 'phone_auth.dart';

const _showGoogle = AppConfig.googleServerClientId != '';

/// `initialize` may only run once per app.
Future<void>? _googleReady;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  String? _error;
  bool _busy = false;
  bool _sendingCode = false;

  // Apple's native flow only exists on iOS; Android would need a web
  // redirect flow, which v1 skips.
  bool get _showApple => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final digits = _phone.text;
    final problem = phoneError(digits);
    setState(() => _error = problem);
    if (problem != null) return;

    final phone = indianE164(digits)!;
    setState(() => _busy = _sendingCode = true);
    try {
      await ref.read(phoneStartProvider.notifier).send(phone);
      if (mounted) {
        unawaited(
          context.push(
            '${Routes.otp}?phone=${Uri.encodeQueryComponent(phone)}',
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = _sendingCode = false);
    }
  }

  /// Runs a provider's native sign-in, then trades its ID token for a
  /// session. A null token means the user cancelled.
  Future<void> _oauth(
    Endpoint endpoint,
    Future<String?> Function() idToken,
  ) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final token = await idToken();
      if (token == null) return;
      final result = await ref
          .read(christimonyApiProvider)
          .send(
            endpoint,
            fields: {'id_token': token},
            decode: SignInResult.fromJson,
          );
      await ref.read(sessionProvider.notifier).signIn(result);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = errorText(e));
    } on Object {
      if (mounted) setState(() => _error = 'Sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _googleToken() async {
    try {
      await (_googleReady ??= GoogleSignIn.instance.initialize(
        serverClientId: AppConfig.googleServerClientId,
        clientId: AppConfig.googleIosClientId.isEmpty
            ? null
            : AppConfig.googleIosClientId,
      ));
    } on Object {
      _googleReady = null;
      rethrow;
    }
    try {
      final account = await GoogleSignIn.instance.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<String?> _appleToken() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );
      return credential.identityToken;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = text.bodyMedium?.copyWith(color: AppColors.mutedForeground);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LogoMark(size: 44),
                    ),
                    const SizedBox(height: 32),
                    Text.rich(
                      TextSpan(
                        text: 'Marriage, sought with ',
                        children: [
                          TextSpan(
                            text: 'intention.',
                            style: AppTypography.serifItalic(36)
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      style: text.displayMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Continue with your phone number or a connected account.',
                      style: muted,
                    ),
                    const SizedBox(height: 32),
                    Text('Phone number', style: text.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phone,
                      enabled: !_busy,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.send,
                      autofillHints: const [
                        AutofillHints.telephoneNumberNational,
                      ],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onSubmitted: (_) => _sendCode(),
                      decoration: InputDecoration(
                        hintText: '98765 43210',
                        border: _pill(AppColors.border),
                        enabledBorder: _pill(AppColors.border),
                        disabledBorder: _pill(AppColors.border),
                        focusedBorder: _pill(AppColors.ring, 2),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: DecoratedBox(
                            decoration: const ShapeDecoration(
                              color: AppColors.secondary,
                              shape: StadiumBorder(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Text('+91', style: muted),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: text.bodyMedium?.copyWith(
                          color: AppColors.destructive,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    CtaButton(
                      label: _sendingCode ? 'Sending code...' : 'Send code',
                      onPressed: _busy ? null : _sendCode,
                    ),
                    if (_showGoogle || _showApple) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR',
                              style: text.labelSmall?.copyWith(
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (_showGoogle)
                      OutlinedButton(
                        onPressed: _busy
                            ? null
                            : () => _oauth(Api.googleAuth, _googleToken),
                        child: const Text('Continue with Google'),
                      ),
                    if (_showGoogle && _showApple) const SizedBox(height: 12),
                    if (_showApple)
                      Opacity(
                        opacity: _busy ? 0.5 : 1,
                        child: SignInWithAppleButton(
                          height: 48,
                          style: SignInWithAppleButtonStyle.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(24),
                          ),
                          onPressed: _busy
                              ? () {}
                              : () => unawaited(
                                  _oauth(Api.appleAuth, _appleToken),
                                ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static OutlineInputBorder _pill(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide(color: color, width: width),
      );
}
