import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painters for 3D clay meals, drinks and celestial items (SunnyEgg, Cookie, Ramen, Coffee, CosmicStar).
class Clay3DMealsDrinksPainters {
  const Clay3DMealsDrinksPainters._();

  static void drawSunnyEgg(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.52;

    final whitePath = Path()
      ..moveTo(cx - w * 0.35, cy - h * 0.22)
      ..cubicTo(cx - w * 0.45, cy - h * 0.05, cx - w * 0.42, cy + h * 0.28, cx - w * 0.15, cy + h * 0.38)
      ..cubicTo(cx + w * 0.12, cy + h * 0.44, cx + w * 0.40, cy + h * 0.32, cx + w * 0.42, cy + h * 0.08)
      ..cubicTo(cx + w * 0.44, cy - h * 0.18, cx + w * 0.22, cy - h * 0.38, cx, cy - h * 0.35)
      ..cubicTo(cx - w * 0.18, cy - h * 0.32, cx - w * 0.25, cy - h * 0.30, cx - w * 0.35, cy - h * 0.22)
      ..close();

    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(whitePath, Paint()..color = const Color(0xFFD1D5DB));
    canvas.restore();

    canvas.drawPath(
      whitePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF3F4F6)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final yolkCenter = Offset(cx, cy + h * 0.02);
    final yolkR = w * 0.22;

    canvas.drawCircle(yolkCenter + const Offset(0, 2), yolkR, Paint()..color = const Color(0x28000000));

    canvas.drawCircle(
      yolkCenter,
      yolkR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.85,
          colors: const [Color(0xFFFFDD00), Color(0xFFFF9500), Color(0xFFE85D04)],
        ).createShader(Rect.fromCircle(center: yolkCenter, radius: yolkR)),
    );

    canvas.drawCircle(
      yolkCenter + Offset(-yolkR * 0.35, -yolkR * 0.35),
      yolkR * 0.26,
      Paint()..color = Colors.white.withValues(alpha: 0.88),
    );
  }

  static void drawCookie(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.5;
    final r = w * 0.38;

    canvas.drawCircle(Offset(cx, cy + h * 0.06), r, Paint()..color = const Color(0xFF8B4B0C));

    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: const [Color(0xFFE29547), Color(0xFFB86B1E), Color(0xFF944B0C)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    void drawChip(Offset c, double cr) {
      canvas.drawCircle(c + const Offset(0, 1), cr, Paint()..color = const Color(0xFF1E0E06));
      canvas.drawCircle(
        c,
        cr,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.2, -0.2),
            colors: const [Color(0xFF4A2810), Color(0xFF2B1408)],
          ).createShader(Rect.fromCircle(center: c, radius: cr)),
      );
      canvas.drawCircle(c + Offset(-cr * 0.25, -cr * 0.25), cr * 0.25, Paint()..color = Colors.white.withValues(alpha: 0.6));
    }

    drawChip(Offset(cx - r * 0.45, cy - r * 0.35), w * 0.08);
    drawChip(Offset(cx + r * 0.38, cy - r * 0.25), w * 0.075);
    drawChip(Offset(cx - r * 0.15, cy + r * 0.15), w * 0.09);
    drawChip(Offset(cx + r * 0.42, cy + r * 0.35), w * 0.08);
    drawChip(Offset(cx - r * 0.42, cy + r * 0.45), w * 0.07);
  }

  static void drawRamen(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    final steamPaint = Paint()
      ..color = const Color(0xFF9D65FF).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final steam1 = Path()
      ..moveTo(cx - w * 0.14, h * 0.28)
      ..cubicTo(cx - w * 0.20, h * 0.20, cx - w * 0.08, h * 0.14, cx - w * 0.12, h * 0.08);
    final steam2 = Path()
      ..moveTo(cx + w * 0.12, h * 0.28)
      ..cubicTo(cx + w * 0.06, h * 0.20, cx + w * 0.18, h * 0.14, cx + w * 0.14, h * 0.08);
    canvas.drawPath(steam1, steamPaint);
    canvas.drawPath(steam2, steamPaint);

    final bowlPath = Path()
      ..moveTo(cx - w * 0.38, h * 0.42)
      ..lineTo(cx + w * 0.38, h * 0.42)
      ..cubicTo(cx + w * 0.36, h * 0.78, cx + w * 0.20, h * 0.88, cx, h * 0.88)
      ..cubicTo(cx - w * 0.20, h * 0.88, cx - w * 0.36, h * 0.78, cx - w * 0.38, h * 0.42)
      ..close();

    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(bowlPath, Paint()..color = const Color(0xFF6B21A8));
    canvas.restore();

    canvas.drawPath(
      bowlPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3E8FF), Color(0xFFC084FC), Color(0xFF9333EA)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final soupRect = Rect.fromCenter(center: Offset(cx, h * 0.42), width: w * 0.72, height: h * 0.18);
    canvas.drawOval(
      soupRect,
      Paint()..color = const Color(0xFFD97706),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.14, h * 0.42), width: w * 0.20, height: h * 0.12),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(cx - w * 0.14, h * 0.42),
      w * 0.05,
      Paint()..color = const Color(0xFFF59E0B),
    );

    final chopPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.10, h * 0.48), Offset(cx + w * 0.42, h * 0.32), chopPaint);
    canvas.drawLine(Offset(cx - w * 0.08, h * 0.52), Offset(cx + w * 0.44, h * 0.36), chopPaint);
  }

  static void drawCoffee(Canvas canvas, double w, double h) {
    final cx = w * 0.46;

    final steamPaint = Paint()
      ..color = const Color(0xFF8D5B4C).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final steam = Path()
      ..moveTo(cx, h * 0.28)
      ..cubicTo(cx - w * 0.08, h * 0.20, cx + w * 0.08, h * 0.14, cx, h * 0.08);
    canvas.drawPath(steam, steamPaint);

    final handlePaint = Paint()
      ..color = const Color(0xFF8D5B4C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + w * 0.32, h * 0.58), width: w * 0.26, height: h * 0.32),
      -math.pi * 0.5,
      math.pi,
      false,
      handlePaint,
    );

    final mugRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(cx - w * 0.30, h * 0.40, w * 0.58, h * 0.44),
      bottomLeft: Radius.circular(w * 0.16),
      bottomRight: Radius.circular(w * 0.16),
    );

    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawRRect(mugRect, Paint()..color = const Color(0xFF5C382E));
    canvas.restore();

    canvas.drawRRect(
      mugRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE2C9BE), Color(0xFF8D5B4C)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.01, h * 0.40), width: w * 0.56, height: h * 0.14),
      Paint()..color = const Color(0xFF381E14),
    );
    canvas.drawCircle(
      Offset(cx - w * 0.01, h * 0.40),
      w * 0.06,
      Paint()..color = const Color(0xFFEED7C5),
    );
  }

  static void drawCosmicStar(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.5;
    final outerR = w * 0.44;
    final innerR = w * 0.18;

    Path createStarPath(double offsetDown) {
      final path = Path();
      for (int i = 0; i < 8; i++) {
        final angle = (i * math.pi / 4) - math.pi / 2;
        final r = (i % 2 == 0) ? outerR : innerR;
        final x = cx + r * math.cos(angle);
        final y = cy + offsetDown + r * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      return path;
    }

    canvas.drawPath(createStarPath(h * 0.06), Paint()..color = const Color(0xFFB45309));

    canvas.drawPath(
      createStarPath(0),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.25),
          radius: 0.85,
          colors: const [Color(0xFFFFF07C), Color(0xFFFFD166), Color(0xFFF59E0B)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: outerR)),
    );

    canvas.drawCircle(
      Offset(cx - w * 0.06, cy - h * 0.06),
      w * 0.11,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
  }
}
