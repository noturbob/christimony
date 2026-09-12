import 'package:flutter/animation.dart';

/// The motion vocabulary from `web/app/globals.css`'s `:root` block, plus
/// what the web's components actually use (several of the CSS durations
/// are declared but dead — see plan §3.4). Durations named by role, not by
/// number, so a call site reads as intent ("this is a step transition")
/// rather than a magic number.
abstract final class Motion {
  /// Micro-transitions: press states, small toggles.
  static const fast = Duration(milliseconds: 150);

  /// Hover / focus changes.
  static const hover = Duration(milliseconds: 200);

  /// Onboarding wizard step transitions.
  static const step = Duration(milliseconds: 250);

  /// Surface changes: sheets, panel open/close.
  static const base = Duration(milliseconds: 300);

  /// Progress bar fills.
  static const progress = Duration(milliseconds: 400);

  /// Scroll-triggered reveal animations.
  static const reveal = Duration(milliseconds: 700);

  /// `--ease-out-quart: cubic-bezier(0.25, 1, 0.5, 1)` — the workhorse
  /// easing used almost everywhere in the web app.
  static const easeOutQuart = Cubic(0.25, 1, 0.5, 1);

  /// `--ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1)`.
  static const easeOutExpo = Cubic(0.16, 1, 0.3, 1);

  /// `--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)`.
  static const easeSpring = Cubic(0.34, 1.56, 0.64, 1);
}
