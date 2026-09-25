import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';

/// The one chromatic control: a pill with a gradient hairline and a
/// transparent fill (`.pill-cta` in `web/app/globals.css`). Use for the
/// primary action on a screen; everything else is an [OutlinedButton] or
/// [TextButton].
class CtaButton extends StatelessWidget {
  const CtaButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1,
        child: CustomPaint(
          painter: const _GradientHairline(),
          child: Material(
            type: MaterialType.transparency,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              overlayColor: WidgetStatePropertyAll(
                AppColors.foreground.withValues(alpha: 0.05),
              ),
              child: SizedBox(
                height: 48,
                width: double.infinity,
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientHairline extends CustomPainter {
  const _GradientHairline();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.deflate(0.75),
        Radius.circular(size.height / 2),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = brandGradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GradientHairline oldDelegate) => false;
}
