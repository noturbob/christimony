import 'package:flutter/material.dart';

/// Bricolage Grotesque for everything, Fraunces italic for accent words --
/// the same pair `web/app/layout.tsx` loads.
///
/// Both are bundled variable fonts (`assets/fonts/`), never fetched at
/// runtime. `fontWeight` AND an explicit `wght` [FontVariation] are set
/// because `fontWeight` alone isn't reliably mapped to a variable font's
/// axis across platforms; `opsz` tracks the size, like the web's
/// `font-optical-sizing: auto`.
abstract final class AppTypography {
  static TextStyle _grotesk(
    double size, {
    int weight = 400,
    double height = 1.45,
    double tracking = 0,
  }) {
    return TextStyle(
      fontFamily: 'Bricolage Grotesque',
      fontSize: size,
      height: height,
      letterSpacing: tracking * size,
      fontWeight: _nearestWeight(weight),
      fontVariations: [
        FontVariation('wght', weight.toDouble()),
        FontVariation('opsz', size.clamp(12, 96)),
      ],
    );
  }

  /// Headings: weight 600, -0.035em tracking (`.font-display`).
  static TextStyle _heading(double size) =>
      _grotesk(size, weight: 600, height: 1.1, tracking: -0.035);

  /// `.serif-italic`: the accent word in a heading ("It's a *match.*").
  static TextStyle serifItalic(double size) => TextStyle(
    fontFamily: 'Fraunces',
    fontStyle: FontStyle.italic,
    fontSize: size,
    letterSpacing: -0.02 * size,
    fontWeight: FontWeight.w400,
    fontVariations: [
      const FontVariation('wght', 400),
      FontVariation('opsz', size.clamp(9, 144)),
    ],
  );

  static FontWeight _nearestWeight(int weight) {
    final index = ((weight / 100).round() - 1).clamp(0, 8);
    return FontWeight.values[index];
  }

  /// The mobile end of the web's `clamp()` scale (`--text-display-1/2`,
  /// `--text-heading-1/2`).
  static TextTheme textTheme(Color foreground) {
    final t = TextTheme(
      displayLarge: _heading(44),
      displayMedium: _heading(36),
      displaySmall: _heading(30),
      headlineLarge: _heading(28),
      headlineMedium: _heading(22),
      headlineSmall: _heading(20),
      titleLarge: _grotesk(18, weight: 600),
      titleMedium: _grotesk(16, weight: 500),
      titleSmall: _grotesk(14, weight: 500),
      bodyLarge: _grotesk(16),
      bodyMedium: _grotesk(14),
      bodySmall: _grotesk(13),
      labelLarge: _grotesk(15, weight: 600),
      labelMedium: _grotesk(13),
      labelSmall: _grotesk(11),
    );
    return t.apply(bodyColor: foreground, displayColor: foreground);
  }
}
