import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Clay Celestial Sun & Moon icons for the Top Avatar.
class Clay3DCelestialAvatarArt extends StatelessWidget {
  const Clay3DCelestialAvatarArt({
    super.key,
    required this.hour,
    this.size = 24.0,
  });

  final int hour;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DCelestialAvatarPainter(hour: hour),
      ),
    );
  }
}

class _Clay3DCelestialAvatarPainter extends CustomPainter {
  const _Clay3DCelestialAvatarPainter({required this.hour});

  final int hour;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final isNight = (hour >= 21 || hour < 5);
    final isDawnOrTwilight = (hour >= 5 && hour < 11) || (hour >= 17 && hour < 21);

    if (isNight) {
      _draw3DMoon(canvas, w, h);
    } else if (isDawnOrTwilight) {
      _draw3DDawn(canvas, w, h);
    } else {
      _draw3DSun(canvas, w, h);
    }
  }

  // 1. 3D Golden Sun with Rounded Clay Rays (Ban ngày rực rỡ)
  void _draw3DSun(Canvas canvas, double w, double h) {
    final center = Offset(w * 0.50, h * 0.50);
    final r = w * 0.28;

    // A. 6 Rounded Clay Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFFA000)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      final angle = i * (math.pi / 3);
      final rayDist = r * 1.45;
      final rx = center.dx + math.cos(angle) * rayDist;
      final ry = center.dy + math.sin(angle) * rayDist;
      canvas.drawCircle(Offset(rx, ry), r * 0.28, rayPaint);
    }

    // B. Sun 3D Bottom Bevel
    final bevelPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center.translate(0, 1.5), r, bevelPaint);

    // C. Sun Core Radial Clay Gradient
    final sunPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 0.90,
        colors: const [
          Color(0xFFFFF9C4),
          Color(0xFFFFD54F),
          Color(0xFFFF9800),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, sunPaint);

    // D. Glossy Specular Highlight
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - r * 0.32, center.dy - r * 0.32), r * 0.28, glossPaint);
  }

  // 2. 3D Rising/Setting Sun over Horizon (Bình minh / Hoàng hôn)
  void _draw3DDawn(Canvas canvas, double w, double h) {
    final center = Offset(w * 0.50, h * 0.54);
    final r = w * 0.32;

    // A. Sun Half Dome Bevel
    final bevelPaint = Paint()
      ..color = const Color(0xFFEA580C)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center.translate(0, 1.2), r, bevelPaint);

    // B. Sun Half Dome Body
    final sunPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.85,
        colors: const [
          Color(0xFFFFF59D),
          Color(0xFFFFB300),
          Color(0xFFFF5722),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, sunPaint);

    // C. 3 Rays popping up
    final rayPaint = Paint()
      ..color = const Color(0xFFFF9100)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.50, h * 0.12), r * 0.22, rayPaint);
    canvas.drawCircle(Offset(w * 0.22, h * 0.24), r * 0.20, rayPaint);
    canvas.drawCircle(Offset(w * 0.78, h * 0.24), r * 0.20, rayPaint);

    // D. Soft 3D Horizon Bar / Cloud Block
    final horizonRect = Rect.fromLTWH(w * 0.12, h * 0.60, w * 0.76, h * 0.24);
    final horizonPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFB74D), Color(0xFFFF7043)],
      ).createShader(horizonRect);
    final horizonRRect = RRect.fromRectAndRadius(horizonRect, const Radius.circular(5.0));

    // Horizon shadow
    canvas.drawRRect(horizonRRect.shift(const Offset(0, 1.2)), Paint()..color = const Color(0xFFC8451B));
    canvas.drawRRect(horizonRRect, horizonPaint);

    // Horizon Gloss
    final glossRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.16, h * 0.62, w * 0.68, h * 0.06),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(glossRRect, Paint()..color = Colors.white.withValues(alpha: 0.65));
  }

  // 3. 3D Chubby Crescent Moon with Companion Star (Đêm trăng sao)
  void _draw3DMoon(Canvas canvas, double w, double h) {
    final center = Offset(w * 0.44, h * 0.48);
    final r = w * 0.36;

    final moonPath = Path()
      ..addArc(Rect.fromCircle(center: center, radius: r), -0.6 * math.pi, 1.5 * math.pi)
      ..arcTo(
        Rect.fromCircle(center: Offset(center.dx + r * 0.55, center.dy - r * 0.15), radius: r * 0.85),
        0.8 * math.pi,
        -1.3 * math.pi,
        false,
      )
      ..close();

    // Moon Bevel Shadow
    canvas.drawPath(moonPath.shift(const Offset(0, 1.5)), Paint()..color = const Color(0xFFB45309));

    // Moon Body
    final moonPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.90,
        colors: const [
          Color(0xFFFFF9C4),
          Color(0xFFFFD54F),
          Color(0xFFFFA000),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawPath(moonPath, moonPaint);

    // Companion Starlight Gem (Ngôi sao đồng hành)
    final starCenter = Offset(w * 0.78, h * 0.30);
    final starR = w * 0.14;
    final starPath = Path()
      ..moveTo(starCenter.dx, starCenter.dy - starR)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx + starR, starCenter.dy)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy + starR)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx - starR, starCenter.dy)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy - starR)
      ..close();
    canvas.drawPath(
      starPath,
      Paint()..color = const Color(0xFFFFD54F),
    );
    canvas.drawCircle(starCenter, starR * 0.35, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _Clay3DCelestialAvatarPainter oldDelegate) {
    return oldDelegate.hour != hour;
  }
}
