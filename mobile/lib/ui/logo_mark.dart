import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// The Christimony mark: a cross drawn as four separate arms -- the many
/// traditions -- meeting at one ring, the marriage at the centre. A 1:1
/// port of `web/components/logo.tsx` (same 64x64 geometry); keep in sync.
class LogoMark extends StatelessWidget {
  const LogoMark({this.size = 32, super.key});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: const _LogoPainter());
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  static const _arms = [
    Rect.fromLTWH(28, 3, 8, 12),
    Rect.fromLTWH(28, 31, 8, 30),
    Rect.fromLTWH(9, 19, 12, 8),
    Rect.fromLTWH(43, 19, 12, 8),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 64);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(14, 3),
        const Offset(50, 61),
        const [Color(0xFFD4F7B5), Color(0xFF5FD39A), Color(0xFF1B7A55)],
        const [0, 0.5, 1],
      );
    for (final arm in _arms) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(arm, const Radius.circular(4)),
        paint,
      );
    }
    canvas.drawCircle(
      const Offset(32, 23),
      6.5,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.4,
    );
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => false;
}
