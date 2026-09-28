import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// 3D Clay Science Flask / Beaker icon for Micronutrients.
/// Features conical clay glass body, glowing sky/mint potion liquid,
/// bubbles, and glossy highlight.
class Clay3DFlask extends StatelessWidget {
  const Clay3DFlask({
    super.key,
    this.size = 18.0,
    this.liquidColor,
  });

  final double size;
  final Color? liquidColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DFlaskPainter(
          liquidColor: liquidColor ?? AppColors.primary,
        ),
      ),
    );
  }
}

class _Clay3DFlaskPainter extends CustomPainter {
  const _Clay3DFlaskPainter({required this.liquidColor});

  final Color liquidColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Bottom shadow
    final shadowPaint = Paint()
      ..color = const Color(0x25000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    final shadowRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.16, h * 0.82 + 1.2, w * 0.68, h * 0.14),
      const Radius.circular(4.0),
    );
    canvas.drawRRect(shadowRRect, shadowPaint);

    // 2. Glass Flask Body Path
    final flaskPath = Path()
      ..moveTo(w * 0.40, h * 0.08)
      ..lineTo(w * 0.60, h * 0.08)
      ..lineTo(w * 0.60, h * 0.30)
      ..lineTo(w * 0.84, h * 0.78)
      ..quadraticBezierTo(w * 0.88, h * 0.90, w * 0.76, h * 0.92)
      ..lineTo(w * 0.24, h * 0.92)
      ..quadraticBezierTo(w * 0.12, h * 0.90, w * 0.16, h * 0.78)
      ..lineTo(w * 0.40, h * 0.30)
      ..close();

    // Glass backdrop
    final glassPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE5F6FD),
          Color(0xFFD6EFFB),
          Color(0xFFBCE3F7),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(flaskPath, glassPaint);

    // 3. Glowing Liquid at bottom
    final liquidPath = Path()
      ..moveTo(w * 0.30, h * 0.52)
      ..quadraticBezierTo(w * 0.50, h * 0.49, w * 0.70, h * 0.52)
      ..lineTo(w * 0.82, h * 0.78)
      ..quadraticBezierTo(w * 0.86, h * 0.88, w * 0.76, h * 0.90)
      ..lineTo(w * 0.24, h * 0.90)
      ..quadraticBezierTo(w * 0.14, h * 0.88, w * 0.18, h * 0.78)
      ..close();

    final liquidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(liquidColor, Colors.white, 0.3)!,
          liquidColor,
          Color.lerp(liquidColor, Colors.black, 0.2)!,
        ],
      ).createShader(Rect.fromLTWH(w * 0.18, h * 0.50, w * 0.64, h * 0.42));
    canvas.drawPath(liquidPath, liquidPaint);

    // 4. Liquid Surface Highlight (Meniscus)
    final meniscusPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final meniscusPath = Path()
      ..moveTo(w * 0.30, h * 0.52)
      ..quadraticBezierTo(w * 0.50, h * 0.49, w * 0.70, h * 0.52);
    canvas.drawPath(meniscusPath, meniscusPaint);

    // 5. Bubbles in Potion
    canvas.drawCircle(Offset(w * 0.44, h * 0.68), 1.6, Paint()..color = Colors.white.withValues(alpha: 0.75));
    canvas.drawCircle(Offset(w * 0.58, h * 0.76), 1.2, Paint()..color = Colors.white.withValues(alpha: 0.65));

    // 6. Flask Lip at top
    final lipRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.36, h * 0.05, w * 0.28, h * 0.07),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(lipRRect, Paint()..color = const Color(0xFFBCE3F7));

    // 7. Gloss Highlight on Left Slant
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final glossPath = Path()
      ..moveTo(w * 0.36, h * 0.32)
      ..lineTo(w * 0.22, h * 0.75);
    canvas.drawPath(glossPath, glossPaint);
  }

  @override
  bool shouldRepaint(covariant _Clay3DFlaskPainter oldDelegate) =>
      oldDelegate.liquidColor != liquidColor;
}
