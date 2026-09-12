import 'package:flutter/material.dart';

/// Fraunces (display/headings) + Inter (body/UI) text theme.
///
/// Fonts are bundled as variable fonts under `assets/fonts/` — never
/// fetched at runtime (`google_fonts` would mean a font-less first paint
/// and non-deterministic golden tests). Both `fontWeight` AND an explicit
/// `wght` [FontVariation] are set because `fontWeight` alone isn't
/// reliably mapped to a variable font's axis across platforms, and `opsz`
/// tracks the rendered size to reproduce the web's
/// `font-optical-sizing: auto`.
///
/// Fraunces is used at 400/500/600 only, normal style — matching the web
/// (`weight: ["400", "500", "600"]` in `web/app/layout.tsx`).
abstract final class AppTypography {
  static const _fraunces = 'Fraunces';
  static const _inter = 'Inter';

  static TextStyle _display(
    double size, {
    int weight = 600,
    double height = 1.15,
    double letterSpacing = -0.4,
  }) {
    return TextStyle(
      fontFamily: _fraunces,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: _nearestWeight(weight),
      fontVariations: [
        FontVariation('wght', weight.toDouble()),
        FontVariation('opsz', size.clamp(9, 144)),
      ],
    );
  }

  static TextStyle _body(
    double size, {
    int weight = 400,
    double height = 1.45,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: _inter,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: _nearestWeight(weight),
      fontVariations: [FontVariation('wght', weight.toDouble())],
    );
  }

  static FontWeight _nearestWeight(int weight) {
    final index = ((weight / 100).round() - 1).clamp(0, 8);
    return FontWeight.values[index];
  }

  /// The mobile end of the web's `clamp()` display scale
  /// (`--text-display-1/2`, `--text-heading-1/2`).
  static TextTheme textTheme(Color foreground) {
    return TextTheme(
      displayLarge: _display(44).copyWith(color: foreground),
      displayMedium: _display(36).copyWith(color: foreground),
      displaySmall: _display(30, weight: 500).copyWith(color: foreground),
      headlineLarge: _display(28, weight: 500).copyWith(color: foreground),
      headlineMedium: _display(22, weight: 500).copyWith(color: foreground),
      headlineSmall: _display(20, weight: 500).copyWith(color: foreground),
      titleLarge: _body(18, weight: 600).copyWith(color: foreground),
      titleMedium: _body(16, weight: 500).copyWith(color: foreground),
      titleSmall: _body(14, weight: 500).copyWith(color: foreground),
      bodyLarge: _body(16).copyWith(color: foreground),
      bodyMedium: _body(14).copyWith(color: foreground),
      bodySmall: _body(13).copyWith(color: foreground),
      labelLarge: _body(14, weight: 500).copyWith(color: foreground),
      labelMedium: _body(13).copyWith(color: foreground),
      labelSmall: _body(11).copyWith(color: foreground),
    );
  }
}
