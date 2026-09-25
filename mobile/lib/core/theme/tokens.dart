import 'package:flutter/painting.dart';

/// The Christimony "chalkboard" palette, transcribed 1:1 from
/// `web/app/globals.css`'s `:root`. The app is dark-only, like the web.
///
/// Colour is taxonomy, never decoration -- one highlighter per part of
/// the product:
///   sage  = the brand + primary action
///   gold  = browsing / intention
///   lilac = pace / connecting
///   blush = family
abstract final class AppColors {
  // Raw palette.
  static const ink = Color(0xFF0F1311);
  static const ink2 = Color(0xFF161B18);
  static const ink3 = Color(0xFF1D2420);
  static const line = Color(0xFF2C332E);
  static const chalk = Color(0xFFFAF6EF);
  static const chalk50 = Color(0xFF8B877B);
  static const sage = Color(0xFF9FE0B8);
  static const gold = Color(0xFFF2B95C);
  static const lilac = Color(0xFFB8A9FF);
  static const blush = Color(0xFFF1C7B7);

  // Semantic roles, mapped exactly as the web maps its shadcn tokens.
  static const Color background = ink;
  static const Color foreground = chalk;
  static const Color card = ink2;
  static const Color popover = ink2;
  static const Color primary = sage;
  static const Color primaryForeground = ink;
  static const Color secondary = ink3;
  static const Color muted = ink3;
  static const Color mutedForeground = chalk50;
  static const Color accent = gold;
  static const Color accentForeground = ink;
  static const destructive = Color(0xFFF0806F);
  static const Color border = line;
  static const Color ring = sage;

  static const scrim = Color(0xB8000000);
}

/// `--grad-brand`. Also the primary button's hairline at rest (the web's
/// `.pill-cta` only reveals its gold stop on hover, which phones don't have).
const brandGradient = LinearGradient(
  begin: Alignment(-0.9, -0.4),
  end: Alignment(0.9, 0.4),
  colors: [Color(0xFF3FBF86), Color(0xFFC9F5A8)],
);

/// Radii from `--radius: 0.5rem` (8px) and the web's multipliers.
abstract final class AppRadii {
  static const sm = 4.8;
  static const md = 6.4;
  static const lg = 8.0;
  static const xl = 11.2;
  static const xl2 = 14.4;
  static const xl3 = 17.6;
  static const xl4 = 20.8;
}
