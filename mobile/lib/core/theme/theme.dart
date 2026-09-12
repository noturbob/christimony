import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'motion.dart';
import 'tokens.dart';
import 'typography.dart';

/// Builds [ThemeData] for a [ChristimonyColors] token set.
///
/// Derives a [ColorScheme] from the tokens so Material's own widgets
/// (dialogs, `TextField` cursors, `Switch`) render correctly without
/// per-widget overrides, while [ChristimonyColors] stays the source of
/// truth for anything that needs the exact brand token (see
/// `docs/mobile-v1-plan.md` §3.2 for the full mapping rationale).
ThemeData buildTheme(ChristimonyColors colors, Brightness brightness) {
  final colorScheme = ColorScheme(
    brightness: brightness,
    surface: colors.background,
    onSurface: colors.foreground,
    primary: colors.primary,
    onPrimary: colors.primaryForeground,
    secondary: colors.secondary,
    onSecondary: colors.secondaryForeground,
    tertiary: colors.accent,
    onTertiary: colors.accentForeground,
    surfaceContainerLowest: colors.card,
    surfaceContainerHighest: colors.muted,
    onSurfaceVariant: colors.mutedForeground,
    outlineVariant: colors.border,
    outline: colors.border,
    error: colors.destructive,
    onError: colors.destructiveForeground,
  );

  final textTheme = AppTypography.textTheme(colors.foreground);
  const radii = ChristimonyRadii.standard;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.background,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    fontFamily: 'Inter',
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    extensions: [colors, radii],
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: colors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: radii.xl2Radius,
        side: BorderSide(color: colors.border),
      ),
    ),
    dividerTheme: DividerThemeData(color: colors.border, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: radii.lgRadius,
        borderSide: BorderSide(color: colors.input),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radii.lgRadius,
        borderSide: BorderSide(color: colors.input),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radii.lgRadius,
        borderSide: BorderSide(color: colors.ring, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radii.lgRadius,
        borderSide: BorderSide(color: colors.destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radii.lgRadius,
        borderSide: BorderSide(color: colors.destructive, width: 2),
      ),
      hintStyle: textTheme.bodyLarge?.copyWith(color: colors.mutedForeground),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.primaryForeground,
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
        textStyle: textTheme.labelLarge,
        animationDuration: Motion.fast,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.foreground,
        backgroundColor: colors.background,
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
        side: BorderSide(color: colors.border),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: textTheme.labelLarge,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.foreground,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colors.background,
      ),
      shape: RoundedRectangleBorder(borderRadius: radii.xl2Radius),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.popover,
      shape: RoundedRectangleBorder(borderRadius: radii.xl2Radius),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.popover,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radii.xl2)),
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

ThemeData buildLightTheme() =>
    buildTheme(ChristimonyColors.light, Brightness.light);

ThemeData buildDarkTheme() =>
    buildTheme(ChristimonyColors.dark, Brightness.dark);
