import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Clay Celestial Star icon.
/// Volumetric 3D golden star with chubby clay tips, rich depth bevel, and specular gloss.
class Clay3DStar extends StatelessWidget {
  const Clay3DStar({
    super.key,
    this.size = 20.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: const _Clay3DStarPainter(),
      ),
    );
  }
}

class _Clay3DStarPainter extends CustomPainter {
  const _Clay3DStarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final rOuter = w * 0.46;
    final rInner = w * 0.22;

    final starPath = _createStarPath(center, rOuter, rInner);

    // 1. Drop Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x35FFA000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    final shadowPath = starPath.shift(const Offset(0, 2.2));
    canvas.drawPath(shadowPath, shadowPaint);

    // 2. 3D Bottom Bevel Shadow
    final bevelPaint = Paint()
      ..color = const Color(0xFFC77700)
      ..style = PaintingStyle.fill;
    final bevelPath = starPath.shift(const Offset(0, 1.6));
    canvas.drawPath(bevelPath, bevelPaint);

    // 3. Main Star Body (Warm Golden Clay Gradient)
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFF176), // Bright pastel gold top
          Color(0xFFFFCA28), // Vibrant warm gold
          Color(0xFFFF9800), // Deep amber base
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(starPath, bodyPaint);

    // 4. Inner Puffy Core (Lõi phồng 3D)
    final innerStarPath = _createStarPath(center.translate(0, -h * 0.02), rOuter * 0.65, rInner * 0.65);
    final innerPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFE0),
          Color(0xFFFFE082),
          Color(0xFFFFB300),
        ],
      ).createShader(Rect.fromLTWH(w * 0.2, h * 0.2, w * 0.6, h * 0.6));
    canvas.drawPath(innerStarPath, innerPaint);

    // 5. Specular Gloss (Ánh sáng phản chiếu góc trên bên trái)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, w * 0.06)
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(center.dx - rOuter * 0.45, center.dy - rOuter * 0.25)
      ..quadraticBezierTo(
        center.dx - rOuter * 0.15,
        center.dy - rOuter * 0.55,
        center.dx,
        center.dy - rOuter * 0.70,
      );
    canvas.drawPath(glossPath, glossPaint);
  }

  Path _createStarPath(Offset center, double rOuter, double rInner) {
    final path = Path();
    const int points = 5;
    const double step = math.pi / points;

    for (int i = 0; i < 2 * points; i++) {
      final double r = i.isEven ? rOuter : rInner;
      final double angle = -math.pi / 2 + i * step;
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _Clay3DStarPainter oldDelegate) => false;
}
