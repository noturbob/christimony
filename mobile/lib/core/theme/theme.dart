import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'motion.dart';
import 'tokens.dart';
import 'typography.dart';

/// The app's only theme -- dark, like the web.
///
/// Derives a [ColorScheme] from [AppColors] so Material's own widgets
/// (dialogs, `TextField` cursors, `Switch`) render on-brand without
/// per-widget overrides; [AppColors] stays the source of truth for
/// anything that needs an exact token.
ThemeData buildTheme() {
  const colorScheme = ColorScheme.dark(
    surface: AppColors.background,
    onSurface: AppColors.foreground,
    primary: AppColors.primary,
    onPrimary: AppColors.primaryForeground,
    secondary: AppColors.secondary,
    onSecondary: AppColors.foreground,
    tertiary: AppColors.accent,
    onTertiary: AppColors.accentForeground,
    surfaceContainerLowest: AppColors.card,
    surfaceContainerHighest: AppColors.muted,
    onSurfaceVariant: AppColors.mutedForeground,
    outlineVariant: AppColors.border,
    outline: AppColors.border,
    error: AppColors.destructive,
    onError: AppColors.ink,
  );

  final textTheme = AppTypography.textTheme(AppColors.foreground);
  OutlineInputBorder field(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    fontFamily: 'Bricolage Grotesque',
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primary.withValues(alpha: 0.14),
      height: 64,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.mutedForeground,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelSmall?.copyWith(
          color: states.contains(WidgetState.selected)
              ? AppColors.foreground
              : AppColors.mutedForeground,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xl2),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: field(AppColors.border),
      enabledBorder: field(AppColors.border),
      focusedBorder: field(AppColors.ring, 2),
      errorBorder: field(AppColors.destructive),
      focusedErrorBorder: field(AppColors.destructive, 2),
      hintStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.mutedForeground,
      ),
    ),
    // The primary action is `CtaButton` (lib/ui/) -- a gradient hairline,
    // never a filled block. These cover the secondary shapes.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foreground,
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
        side: BorderSide(color: AppColors.foreground.withValues(alpha: 0.5)),
        textStyle: textTheme.labelLarge,
        animationDuration: Motion.fast,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: textTheme.labelLarge,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.foreground,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.background,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xl2),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.popover,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.xl2),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.popover,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl2)),
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
