import 'package:flutter/material.dart';

/// 3D Clay Streak Flame icon.
/// Chubby volumetric flame with dual-layer clay, warm golden core, and specular gloss.
class Clay3DFlame extends StatelessWidget {
  const Clay3DFlame({
    super.key,
    this.size = 20.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size * 0.85, size),
        painter: const _Clay3DFlamePainter(),
      ),
    );
  }
}

class _Clay3DFlamePainter extends CustomPainter {
  const _Clay3DFlamePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Drop Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x35FF6D00)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    final shadowPath = _createFlamePath(w, h).shift(const Offset(0, 2.0));
    canvas.drawPath(shadowPath, shadowPaint);

    // 2. 3D Bottom Bevel Shadow
    final bevelPaint = Paint()
      ..color = const Color(0xFFC43800)
      ..style = PaintingStyle.fill;
    final bevelPath = _createFlamePath(w, h).shift(const Offset(0, 1.5));
    canvas.drawPath(bevelPath, bevelPaint);

    // 3. Outer Fiery Orange Clay Flame
    final outerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFF9100),
          Color(0xFFFF5722),
          Color(0xFFE64A19),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final outerPath = _createFlamePath(w, h);
    canvas.drawPath(outerPath, outerPaint);

    // 4. Inner Golden Heart Flame (Lõi lửa vàng ấm 3D)
    final innerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFF9C4),
          Color(0xFFFFD54F),
          Color(0xFFFFB300),
        ],
      ).createShader(Rect.fromLTWH(w * 0.22, h * 0.36, w * 0.56, h * 0.54));

    final innerPath = Path()
      ..moveTo(w * 0.50, h * 0.36)
      ..cubicTo(w * 0.68, h * 0.50, w * 0.74, h * 0.70, w * 0.50, h * 0.88)
      ..cubicTo(w * 0.26, h * 0.70, w * 0.32, h * 0.50, w * 0.50, h * 0.36)
      ..close();
    canvas.drawPath(innerPath, innerPaint);

    // 5. Specular Gloss Curve (Ánh phản chiếu cong 3D)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(w * 0.26, h * 0.44)
      ..quadraticBezierTo(w * 0.22, h * 0.62, w * 0.32, h * 0.76);
    canvas.drawPath(glossPath, glossPaint);
  }

  Path _createFlamePath(double w, double h) {
    return Path()
      ..moveTo(w * 0.52, h * 0.04) // Top tongue tip
      ..cubicTo(w * 0.70, h * 0.18, w * 0.94, h * 0.46, w * 0.88, h * 0.72)
      ..cubicTo(w * 0.84, h * 0.92, w * 0.66, h * 0.98, w * 0.50, h * 0.98)
      ..cubicTo(w * 0.34, h * 0.98, w * 0.14, h * 0.92, w * 0.10, h * 0.70)
      ..cubicTo(w * 0.08, h * 0.52, w * 0.24, h * 0.36, w * 0.34, h * 0.28)
      ..cubicTo(w * 0.40, h * 0.20, w * 0.46, h * 0.10, w * 0.52, h * 0.04)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _Clay3DFlamePainter oldDelegate) => false;
}
