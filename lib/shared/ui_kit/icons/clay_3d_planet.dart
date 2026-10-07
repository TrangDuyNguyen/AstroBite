import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Clay Celestial Planet figurine for AstroBite Guilds.
///
/// Features:
/// - Volumetric 3D sphere with multi-stop radial illumination
/// - Solid warm 3D bottom bevel
/// - Custom planetary features (Mars craters, Saturn ring, Jupiter bands, Venus cloud, Neptune ice)
/// - Top-left glossy specular highlight arc
class Clay3DPlanet extends StatelessWidget {
  const Clay3DPlanet({
    super.key,
    required this.planet,
    this.size = 28.0,
  });

  final String planet;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DPlanetPainter(planet: planet.toLowerCase()),
      ),
    );
  }
}

class _Clay3DPlanetPainter extends CustomPainter {
  const _Clay3DPlanetPainter({required this.planet});

  final String planet;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w * 0.40;

    final config = _getPlanetConfig(planet);

    // If Saturn, draw back half of the 3D ring first
    if (planet == 'saturn') {
      _drawSaturnRingBack(canvas, center, w, config);
    }

    // 1. Ambient Drop Shadow
    final shadowPaint = Paint()
      ..color = config.bevelColor.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
    canvas.drawCircle(center.translate(0, 2.5), radius, shadowPaint);

    // 2. 3D Bottom Bevel Shadow (Layer 1)
    final bevelPaint = Paint()
      ..color = config.bevelColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center.translate(0, 1.8), radius, bevelPaint);

    // 3. Spherical Clay Body with directional radial lighting
    final sphereRect = Rect.fromCircle(center: center, radius: radius);
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.45),
        radius: 1.1,
        colors: [
          config.highlightColor,
          config.midColor,
          config.baseColor,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(sphereRect);
    canvas.drawCircle(center, radius, bodyPaint);

    // Clip to sphere for surface details
    canvas.save();
    final clipPath = Path()..addOval(sphereRect);
    canvas.clipPath(clipPath);

    // 4. Distinct Surface Details per planet
    _drawPlanetDetails(canvas, center, radius, config);

    canvas.restore();

    // If Saturn, draw front half of the 3D ring over the sphere
    if (planet == 'saturn') {
      _drawSaturnRingFront(canvas, center, w, config);
    }

    // 5. Specular Gloss Arc (Ánh sáng phản chiếu góc trên bên trái)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, w * 0.08)
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius * 0.72),
        -math.pi * 0.85,
        math.pi * 0.40,
      );
    canvas.drawPath(glossPath, glossPaint);

    // 6. Micro Specular Dot (Điểm sáng hạt ngọc)
    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.90);
    canvas.drawCircle(
      center.translate(-radius * 0.45, -radius * 0.45),
      math.max(1.0, radius * 0.12),
      dotPaint,
    );
  }

  void _drawPlanetDetails(
    Canvas canvas,
    Offset center,
    double radius,
    _PlanetConfig config,
  ) {
    switch (planet) {
      case 'mars':
        // Craters on Mars
        final craterPaint1 = Paint()..color = config.detailColor.withValues(alpha: 0.60);
        canvas.drawCircle(center.translate(-radius * 0.25, radius * 0.15), radius * 0.25, craterPaint1);
        final craterPaint2 = Paint()..color = config.detailColor.withValues(alpha: 0.45);
        canvas.drawCircle(center.translate(radius * 0.35, -radius * 0.10), radius * 0.18, craterPaint2);
        break;

      case 'jupiter':
        // Gas giant banded stripes
        final stripePaint = Paint()
          ..color = config.detailColor.withValues(alpha: 0.50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.22;
        canvas.drawLine(
          Offset(center.dx - radius, center.dy - radius * 0.15),
          Offset(center.dx + radius, center.dy - radius * 0.15),
          stripePaint,
        );
        final stripePaint2 = Paint()
          ..color = config.detailColor.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.18;
        canvas.drawLine(
          Offset(center.dx - radius, center.dy + radius * 0.25),
          Offset(center.dx + radius, center.dy + radius * 0.25),
          stripePaint2,
        );
        // Red spot
        final spotPaint = Paint()..color = const Color(0xFFC62828).withValues(alpha: 0.75);
        canvas.drawOval(
          Rect.fromCenter(
            center: center.translate(radius * 0.30, radius * 0.25),
            width: radius * 0.35,
            height: radius * 0.22,
          ),
          spotPaint,
        );
        break;

      case 'venus':
        // Swirling warm cloud ribbon
        final cloudPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.26
          ..strokeCap = StrokeCap.round;
        final cloudPath = Path()
          ..moveTo(center.dx - radius * 0.8, center.dy + radius * 0.1)
          ..quadraticBezierTo(
            center.dx,
            center.dy - radius * 0.3,
            center.dx + radius * 0.8,
            center.dy + radius * 0.2,
          );
        canvas.drawPath(cloudPath, cloudPaint);
        break;

      case 'neptune':
        // Cyan atmospheric wind ribbon
        final windPaint = Paint()
          ..color = const Color(0xFF80D8FF).withValues(alpha: 0.40)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.18;
        final windPath = Path()
          ..moveTo(center.dx - radius * 0.9, center.dy + radius * 0.1)
          ..quadraticBezierTo(
            center.dx,
            center.dy - radius * 0.15,
            center.dx + radius * 0.9,
            center.dy,
          );
        canvas.drawPath(windPath, windPaint);
        break;

      default:
        break;
    }
  }

  void _drawSaturnRingBack(Canvas canvas, Offset center, double w, _PlanetConfig config) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 7);

    final ringRect = Rect.fromCenter(
      center: Offset.zero,
      width: w * 0.95,
      height: w * 0.32,
    );

    // Clip to upper half (back)
    canvas.clipRect(Rect.fromLTRB(-w, -w, w, 0));

    final ringPaint = Paint()
      ..color = config.detailColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12;
    canvas.drawOval(ringRect, ringPaint);

    final ringHighlight = Paint()
      ..color = const Color(0xFFFFF9C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04;
    canvas.drawOval(ringRect, ringHighlight);

    canvas.restore();
  }

  void _drawSaturnRingFront(Canvas canvas, Offset center, double w, _PlanetConfig config) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 7);

    final ringRect = Rect.fromCenter(
      center: Offset.zero,
      width: w * 0.95,
      height: w * 0.32,
    );

    // Clip to lower half (front)
    canvas.clipRect(Rect.fromLTRB(-w, 0, w, w));

    // Ring shadow on planet
    final ringShadow = Paint()
      ..color = const Color(0x301E2337)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12;
    canvas.drawOval(ringRect.shift(const Offset(0, 1.5)), ringShadow);

    final ringPaint = Paint()
      ..color = config.detailColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12;
    canvas.drawOval(ringRect, ringPaint);

    final ringHighlight = Paint()
      ..color = const Color(0xFFFFF9C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04;
    canvas.drawOval(ringRect, ringHighlight);

    canvas.restore();
  }

  _PlanetConfig _getPlanetConfig(String p) {
    switch (p) {
      case 'mars':
        return const _PlanetConfig(
          highlightColor: Color(0xFFFF8A65),
          midColor: Color(0xFFF4511E),
          baseColor: Color(0xFFBF360C),
          bevelColor: Color(0xFF871F00),
          detailColor: Color(0xFF8E2100),
        );
      case 'venus':
        return const _PlanetConfig(
          highlightColor: Color(0xFFFFF59D),
          midColor: Color(0xFFFFCA28),
          baseColor: Color(0xFFFF8F00),
          bevelColor: Color(0xFFC76A00),
          detailColor: Color(0xFFFFB300),
        );
      case 'jupiter':
        return const _PlanetConfig(
          highlightColor: Color(0xFFFFCC80),
          midColor: Color(0xFFFF9800),
          baseColor: Color(0xFFE65100),
          bevelColor: Color(0xFFA33500),
          detailColor: Color(0xFFBF360C),
        );
      case 'saturn':
        return const _PlanetConfig(
          highlightColor: Color(0xFFF8BBD0),
          midColor: Color(0xFFCE93D8),
          baseColor: Color(0xFF8E24AA),
          bevelColor: Color(0xFF5A1070),
          detailColor: Color(0xFFFFE082),
        );
      case 'neptune':
        return const _PlanetConfig(
          highlightColor: Color(0xFF80D8FF),
          midColor: Color(0xFF00B0FF),
          baseColor: Color(0xFF0077C2),
          bevelColor: Color(0xFF004D80),
          detailColor: Color(0xFF005B94),
        );
      default:
        // Default celestial cosmic planet
        return const _PlanetConfig(
          highlightColor: Color(0xFFB388FF),
          midColor: Color(0xFF7C4DFF),
          baseColor: Color(0xFF512DA8),
          bevelColor: Color(0xFF311B92),
          detailColor: Color(0xFF4527A0),
        );
    }
  }

  @override
  bool shouldRepaint(covariant _Clay3DPlanetPainter oldDelegate) =>
      oldDelegate.planet != planet;
}

class _PlanetConfig {
  const _PlanetConfig({
    required this.highlightColor,
    required this.midColor,
    required this.baseColor,
    required this.bevelColor,
    required this.detailColor,
  });

  final Color highlightColor;
  final Color midColor;
  final Color baseColor;
  final Color bevelColor;
  final Color detailColor;
}
