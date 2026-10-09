import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../../core/theme/tokens.dart';

enum Swipe { like, pass }

/// One draggable card, ported from `web/components/swipe-card.tsx`. Only
/// horizontal drags are claimed, so the card's own vertical scroll and the
/// photo carousel's taps still reach the content.
class SwipeCard extends StatefulWidget {
  const SwipeCard({required this.child, required this.onSwiped, super.key});

  final Widget child;
  final ValueChanged<Swipe> onSwiped;

  @override
  State<SwipeCard> createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  static const threshold = 120.0;
  static const flingVelocity = 600.0;
  static const exitDistance = 500.0;
  static const _spring = SpringDescription(
    mass: 1,
    stiffness: 320,
    damping: 26,
  );

  // The web card has no dragConstraints, so framer's dragElastic (0.6)
  // never engages there: the card tracks the finger 1:1, as here.
  late final _x = AnimationController.unbounded(vsync: this);
  Timer? _callback;
  bool _gone = false;

  /// Throws the card off-screen, as the Like / Pass buttons do.
  void swipe(Swipe direction) {
    if (_gone) return;
    _gone = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      widget.onSwiped(direction);
      return;
    }
    _x.animateTo(
      direction == Swipe.like ? exitDistance : -exitDistance,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    _callback = Timer(
      const Duration(milliseconds: 180),
      () => widget.onSwiped(direction),
    );
  }

  void _onEnd(DragEndDetails details) {
    if (_gone) return;
    final x = _x.value;
    final v = details.velocity.pixelsPerSecond.dx;
    if (x > threshold || v > flingVelocity) {
      swipe(Swipe.like);
    } else if (x < -threshold || v < -flingVelocity) {
      swipe(Swipe.pass);
    } else if (MediaQuery.disableAnimationsOf(context)) {
      _x.value = 0;
    } else {
      _x.animateWith(SpringSimulation(_spring, x, 0, v));
    }
  }

  @override
  void dispose() {
    _callback?.cancel();
    _x.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _x,
      builder: (context, child) {
        final x = _x.value;
        return Transform.translate(
          offset: Offset(x, 0),
          child: Transform.rotate(
            angle: (x / 300).clamp(-1.0, 1.0) * 16 * math.pi / 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                child!,
                Positioned(
                  top: 32,
                  left: 24,
                  child: _Stamp(
                    'LIKE',
                    AppColors.primary,
                    -12,
                    ((x - 24) / 116).clamp(0, 1),
                  ),
                ),
                Positioned(
                  top: 32,
                  right: 24,
                  child: _Stamp(
                    'PASS',
                    AppColors.destructive,
                    12,
                    ((-24 - x) / 116).clamp(0, 1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: GestureDetector(
        onHorizontalDragStart: (_) => _gone ? null : _x.stop(),
        onHorizontalDragUpdate: (d) => _gone ? null : _x.value += d.delta.dx,
        onHorizontalDragEnd: _onEnd,
        child: widget.child,
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp(this.label, this.color, this.degrees, this.opacity);

  final String label;
  final Color color;
  final double degrees;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Opacity(
          opacity: opacity,
          child: Transform.rotate(
            angle: degrees * math.pi / 180,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 4),
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Text(
                label,
                textScaler: TextScaler.noScaling,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
