import 'package:flutter/material.dart';

/// The Christimony brand palette as a [ThemeExtension].
///
/// This is a 1:1 transcription of the design tokens defined in
/// `web/app/globals.css` (light) and the dark palette authored for the
/// mobile app (see `docs/mobile-v1-plan.md` §3.1) — no derivation, no
/// opacity math here. Every token is one line, so a designer handoff that
/// changes a value is a one-line diff in this file.
///
/// Access via the [ThemeX] extension: `context.c.primary`.
@immutable
class ChristimonyColors extends ThemeExtension<ChristimonyColors> {
  const ChristimonyColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.celebration,
    required this.onCelebration,
    required this.peach,
    required this.blush,
    required this.scrim,
  });

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;

  /// Ground for the full-screen match-celebration overlay. Deliberately
  /// NOT [primary] on dark — using the lifted sage there would flash
  /// bright against the rest of the dark UI. See plan §3.1.
  final Color celebration;
  final Color onCelebration;

  /// On-dark emphasis colors mined from the marketing page's dark
  /// sections. Unchanged between light and dark.
  final Color peach;
  final Color blush;

  /// Scrim behind overlays (photo-delete chip, sheets).
  final Color scrim;

  static const light = ChristimonyColors(
    background: Color(0xFFFAF6EF),
    foreground: Color(0xFF1B1B18),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF1B1B18),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF1B1B18),
    primary: Color(0xFF24463B),
    primaryForeground: Color(0xFFFAF6EF),
    secondary: Color(0xFFE2DACB),
    secondaryForeground: Color(0xFF1B1B18),
    muted: Color(0xFFF1ECE1),
    mutedForeground: Color(0xFF6B6459),
    accent: Color(0xFF7A2E2E),
    accentForeground: Color(0xFFFAF6EF),
    destructive: Color(0xFFE7000B),
    destructiveForeground: Color(0xFFFAFAFA),
    border: Color(0xFFE2DACB),
    input: Color(0xFFE2DACB),
    ring: Color(0xFF24463B),
    celebration: Color(0xFF24463B),
    onCelebration: Color(0xFFFAF6EF),
    peach: Color(0xFFE6B9A9),
    blush: Color(0xFFF1C7B7),
    scrim: Color(0x99000000),
  );

  static const dark = ChristimonyColors(
    background: Color(0xFF14140F),
    foreground: Color(0xFFF0EBE1),
    card: Color(0xFF1F1E19),
    cardForeground: Color(0xFFF0EBE1),
    popover: Color(0xFF262420),
    popoverForeground: Color(0xFFF0EBE1),
    primary: Color(0xFF6F9C8A),
    primaryForeground: Color(0xFF10201A),
    secondary: Color(0xFF2E2A23),
    secondaryForeground: Color(0xFFE8E0D2),
    muted: Color(0xFF242118),
    mutedForeground: Color(0xFFA39A8B),
    accent: Color(0xFFC96A63),
    accentForeground: Color(0xFF1B1B18),
    destructive: Color(0xFFFF5A52),
    destructiveForeground: Color(0xFF14140F),
    border: Color(0xFF353027),
    input: Color(0xFF353027),
    ring: Color(0xFF6F9C8A),
    celebration: Color(0xFF1B3A30),
    onCelebration: Color(0xFFEBE4D8),
    peach: Color(0xFFE6B9A9),
    blush: Color(0xFFF1C7B7),
    scrim: Color(0xB8000000),
  );

  @override
  ChristimonyColors copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? celebration,
    Color? onCelebration,
    Color? peach,
    Color? blush,
    Color? scrim,
  }) {
    return ChristimonyColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      celebration: celebration ?? this.celebration,
      onCelebration: onCelebration ?? this.onCelebration,
      peach: peach ?? this.peach,
      blush: blush ?? this.blush,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  ChristimonyColors lerp(ThemeExtension<ChristimonyColors>? other, double t) {
    if (other is! ChristimonyColors) return this;
    return ChristimonyColors(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      popover: Color.lerp(popover, other.popover, t)!,
      popoverForeground: Color.lerp(
        popoverForeground,
        other.popoverForeground,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground: Color.lerp(
        primaryForeground,
        other.primaryForeground,
        t,
      )!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground: Color.lerp(
        secondaryForeground,
        other.secondaryForeground,
        t,
      )!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentForeground: Color.lerp(
        accentForeground,
        other.accentForeground,
        t,
      )!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveForeground: Color.lerp(
        destructiveForeground,
        other.destructiveForeground,
        t,
      )!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      ring: Color.lerp(ring, other.ring, t)!,
      celebration: Color.lerp(celebration, other.celebration, t)!,
      onCelebration: Color.lerp(onCelebration, other.onCelebration, t)!,
      peach: Color.lerp(peach, other.peach, t)!,
      blush: Color.lerp(blush, other.blush, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

/// Radius tokens. Resolve from `--radius: 12px` in the web's token set —
/// these are non-default (stock Tailwind `rounded-2xl` is 16; here it's
/// 21.6). Getting these right is most of the visual fidelity.
@immutable
class ChristimonyRadii extends ThemeExtension<ChristimonyRadii> {
  const ChristimonyRadii({
    this.sm = 7.2,
    this.md = 9.6,
    this.lg = 12,
    this.xl = 16.8,
    this.xl2 = 21.6,
    this.xl3 = 26.4,
    this.xl4 = 31.2,
  });

  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xl2;
  final double xl3;
  final double xl4;

  static const standard = ChristimonyRadii();

  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
  BorderRadius get xl2Radius => BorderRadius.circular(xl2);
  BorderRadius get xl3Radius => BorderRadius.circular(xl3);

  @override
  ChristimonyRadii copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xl2,
    double? xl3,
    double? xl4,
  }) {
    return ChristimonyRadii(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xl2: xl2 ?? this.xl2,
      xl3: xl3 ?? this.xl3,
      xl4: xl4 ?? this.xl4,
    );
  }

  @override
  ChristimonyRadii lerp(ThemeExtension<ChristimonyRadii>? other, double t) {
    if (other is! ChristimonyRadii) return this;
    return ChristimonyRadii(
      sm: lerpDouble(sm, other.sm, t),
      md: lerpDouble(md, other.md, t),
      lg: lerpDouble(lg, other.lg, t),
      xl: lerpDouble(xl, other.xl, t),
      xl2: lerpDouble(xl2, other.xl2, t),
      xl3: lerpDouble(xl3, other.xl3, t),
      xl4: lerpDouble(xl4, other.xl4, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

/// Convenience accessors so call sites read like the web's CSS variables:
/// `context.c.muted` instead of `Theme.of(context).extension<...>()!.muted`.
extension ThemeX on BuildContext {
  ChristimonyColors get c =>
      Theme.of(this).extension<ChristimonyColors>() ?? ChristimonyColors.light;

  ChristimonyRadii get r =>
      Theme.of(this).extension<ChristimonyRadii>() ?? ChristimonyRadii.standard;
}
