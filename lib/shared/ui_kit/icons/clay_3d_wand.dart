import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Clay Cosmic Magic Wand icon for "AstroCoach" tab.
/// Volumetric golden celestial star with 3D amber bevel and cosmic magic wand handle.
class Clay3DWand extends StatelessWidget {
  const Clay3DWand({
    super.key,
    this.size = 22.0,
    this.isSelected = true,
  });

  final double size;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DWandPainter(isSelected: isSelected),
      ),
    );
  }
}

class _Clay3DWandPainter extends CustomPainter {
  const _Clay3DWandPainter({required this.isSelected});

  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Wand Handle Drop Shadow & 3D Rod
    final handlePaint = Paint()
      ..shader = isSelected
          ? const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
            ).createShader(Rect.fromLTWH(0, 0, w, h))
          : const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
            ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round;

    final handleShadow = Paint()
      ..color = const Color(0x201E2337)
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

    // Draw shadow then handle
    canvas.drawLine(
      Offset(w * 0.15, h * 0.85 + 1.2),
      Offset(w * 0.45, h * 0.55 + 1.2),
      handleShadow,
    );
    canvas.drawLine(
      Offset(w * 0.15, h * 0.85),
      Offset(w * 0.45, h * 0.55),
      handlePaint,
    );

    // Wand tip golden grip ring
    final gripPaint = Paint()
      ..color = isSelected ? const Color(0xFFFFD54F) : const Color(0xFFCBD5E1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.44, h * 0.56), w * 0.08, gripPaint);

    // 2. Star Center & Points
    final starCenter = Offset(w * 0.62, h * 0.38);
    final outerRadius = w * 0.36;
    final innerRadius = w * 0.17;
    const points = 5;

    final starPath = _createStarPath(starCenter, outerRadius, innerRadius, points);

    // Star Drop Shadow
    final starShadowPaint = Paint()
      ..color = isSelected ? const Color(0x35FFB300) : const Color(0x181E2337)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawPath(starPath.shift(const Offset(0, 1.8)), starShadowPaint);

    // 3D Bottom Bevel
    final starBevelPaint = Paint()
      ..color = isSelected ? const Color(0xFFC47500) : const Color(0xFF475569)
      ..style = PaintingStyle.fill;
    canvas.drawPath(starPath.shift(const Offset(0, 1.2)), starBevelPaint);

    // Star Main Body Gradient
    final starBodyPaint = Paint()
      ..shader = isSelected
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF176),
                Color(0xFFFFB300),
                Color(0xFFFF8F00),
              ],
            ).createShader(Rect.fromCenter(
                center: starCenter,
                width: outerRadius * 2,
                height: outerRadius * 2,
              ))
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE2E8F0),
                Color(0xFF94A3B8),
                Color(0xFF64748B),
              ],
            ).createShader(Rect.fromCenter(
                center: starCenter,
                width: outerRadius * 2,
                height: outerRadius * 2,
              ));
    canvas.drawPath(starPath, starBodyPaint);

    // 3. Mini Celestial Sparkle (Starlight Diamond at top-left)
    if (isSelected) {
      final sparkleCenter = Offset(w * 0.26, h * 0.22);
      final sparklePaint = Paint()..color = const Color(0xFFFFF59D);
      final sparklePath = Path()
        ..moveTo(sparkleCenter.dx, sparkleCenter.dy - w * 0.12)
        ..quadraticBezierTo(sparkleCenter.dx, sparkleCenter.dy,
            sparkleCenter.dx + w * 0.12, sparkleCenter.dy)
        ..quadraticBezierTo(sparkleCenter.dx, sparkleCenter.dy,
            sparkleCenter.dx, sparkleCenter.dy + w * 0.12)
        ..quadraticBezierTo(sparkleCenter.dx, sparkleCenter.dy,
            sparkleCenter.dx - w * 0.12, sparkleCenter.dy)
        ..quadraticBezierTo(sparkleCenter.dx, sparkleCenter.dy,
            sparkleCenter.dx, sparkleCenter.dy - w * 0.12)
        ..close();
      canvas.drawPath(sparklePath, sparklePaint);
    }

    // 4. Specular Gloss Highlight Arc on upper lobe
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(starCenter.dx - outerRadius * 0.25, starCenter.dy - outerRadius * 0.35)
      ..quadraticBezierTo(
        starCenter.dx,
        starCenter.dy - outerRadius * 0.55,
        starCenter.dx + outerRadius * 0.25,
        starCenter.dy - outerRadius * 0.35,
      );
    canvas.drawPath(glossPath, glossPaint);
  }

  Path _createStarPath(
    Offset center,
    double outerR,
    double innerR,
    int points,
  ) {
    final path = Path();
    final step = math.pi / points;
    double angle = -math.pi / 2;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _Clay3DWandPainter oldDelegate) =>
      oldDelegate.isSelected != isSelected;
}
