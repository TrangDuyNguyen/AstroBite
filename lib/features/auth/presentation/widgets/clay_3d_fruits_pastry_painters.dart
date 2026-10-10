import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painters for 3D clay fruits and pastries (Apple, Avocado, Croissant, Pizza, IceCream).
class Clay3DFruitsPastryPainters {
  const Clay3DFruitsPastryPainters._();

  static void drawApple(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.55;
    final r = w * 0.36;

    // Stem (cuống nâu cong nổi khối)
    final stemPath = Path()
      ..moveTo(cx, cy - r * 0.85)
      ..quadraticBezierTo(cx + w * 0.08, cy - r * 1.35, cx + w * 0.04, cy - r * 1.55);
    final stemPaint = Paint()
      ..color = const Color(0xFF6A3810)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(stemPath, stemPaint);

    // Leaf (lá xanh dập nổi)
    final leafPath = Path()
      ..moveTo(cx + w * 0.04, cy - r * 1.1)
      ..quadraticBezierTo(cx + w * 0.35, cy - r * 1.35, cx + w * 0.32, cy - r * 0.85)
      ..quadraticBezierTo(cx + w * 0.15, cy - r * 0.85, cx + w * 0.04, cy - r * 1.1);
    final leafPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF58CC02), Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(cx, cy - r * 1.4, w * 0.35, h * 0.35));
    canvas.drawPath(leafPath, leafPaint);

    // 3D Apple Body Path
    final bodyPath = Path()
      ..moveTo(cx, cy - r * 0.7)
      ..cubicTo(cx - r * 0.7, cy - r * 1.1, cx - r * 1.15, cy - r * 0.2, cx - r * 1.05, cy + r * 0.35)
      ..cubicTo(cx - r * 0.95, cy + r * 0.95, cx - r * 0.45, cy + r * 1.05, cx, cy + r * 0.78)
      ..cubicTo(cx + r * 0.45, cy + r * 1.05, cx + r * 0.95, cy + r * 0.95, cx + r * 1.05, cy + r * 0.35)
      ..cubicTo(cx + r * 1.15, cy - r * 0.2, cx + r * 0.7, cy - r * 1.1, cx, cy - r * 0.7)
      ..close();

    // Layer 1: Solid Bevel Shadow
    final bevelPaint = Paint()..color = const Color(0xFF9E0B2B);
    canvas.save();
    canvas.translate(0, h * 0.06);
    canvas.drawPath(bodyPath, bevelPaint);
    canvas.restore();

    // Layer 2: Main Clay Body with 3D Radial Shading
    final applePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.4),
        radius: 0.85,
        colors: const [
          Color(0xFFFF5C7A),
          Color(0xFFE51A4B),
          Color(0xFFB50831),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 1.2));
    canvas.drawPath(bodyPath, applePaint);

    // Layer 3: Glossy Specular Sheen
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;
    final glossPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(cx - r * 0.48, cy - r * 0.32),
        width: r * 0.38,
        height: r * 0.22,
      ));
    canvas.save();
    canvas.rotate(-0.35);
    canvas.drawPath(glossPath, glossPaint);
    canvas.restore();

    // Dot specular highlight
    canvas.drawCircle(
      Offset(cx - r * 0.22, cy - r * 0.52),
      r * 0.09,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  static void drawAvocado(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    // Avocado contour path
    final avoPath = Path()
      ..moveTo(cx, h * 0.12)
      ..cubicTo(cx - w * 0.25, h * 0.12, cx - w * 0.26, h * 0.36, cx - w * 0.42, h * 0.58)
      ..cubicTo(cx - w * 0.48, h * 0.78, cx - w * 0.3, h * 0.92, cx, h * 0.92)
      ..cubicTo(cx + w * 0.3, h * 0.92, cx + w * 0.48, h * 0.78, cx + w * 0.42, h * 0.58)
      ..cubicTo(cx + w * 0.26, h * 0.36, cx + w * 0.25, h * 0.12, cx, h * 0.12)
      ..close();

    // Bevel bottom shadow
    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(avoPath, Paint()..color = const Color(0xFF1E4620));
    canvas.restore();

    // Dark forest green rind
    canvas.drawPath(
      avoPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF386641), Color(0xFF244829)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Inner Creamy Flesh
    final fleshPath = Path()
      ..moveTo(cx, h * 0.19)
      ..cubicTo(cx - w * 0.19, h * 0.19, cx - w * 0.20, h * 0.38, cx - w * 0.33, h * 0.58)
      ..cubicTo(cx - w * 0.38, h * 0.74, cx - w * 0.24, h * 0.85, cx, h * 0.85)
      ..cubicTo(cx + w * 0.24, h * 0.85, cx + w * 0.38, h * 0.74, cx + w * 0.33, h * 0.58)
      ..cubicTo(cx + w * 0.20, h * 0.38, cx + w * 0.19, h * 0.19, cx, h * 0.19)
      ..close();
    canvas.drawPath(
      fleshPath,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, 0.4),
          radius: 0.7,
          colors: [Color(0xFFF1FAEE), Color(0xFFC7E6A8), Color(0xFFA7C957)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Big 3D Round Seed
    final pitCenter = Offset(cx, h * 0.65);
    final pitR = w * 0.18;

    canvas.drawCircle(
      pitCenter + const Offset(0, 2),
      pitR,
      Paint()..color = const Color(0x33000000),
    );

    canvas.drawCircle(
      pitCenter,
      pitR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.8,
          colors: const [Color(0xFFB06836), Color(0xFF7A3E1D), Color(0xFF4A200B)],
        ).createShader(Rect.fromCircle(center: pitCenter, radius: pitR)),
    );

    canvas.drawCircle(
      pitCenter + Offset(-pitR * 0.35, -pitR * 0.35),
      pitR * 0.25,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
  }

  static void drawCroissant(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.52;

    final crescentPath = Path()
      ..moveTo(cx - w * 0.42, cy + h * 0.18)
      ..cubicTo(cx - w * 0.44, cy - h * 0.08, cx - w * 0.18, cy - h * 0.36, cx, cy - h * 0.36)
      ..cubicTo(cx + w * 0.18, cy - h * 0.36, cx + w * 0.44, cy - h * 0.08, cx + w * 0.42, cy + h * 0.18)
      ..cubicTo(cx + w * 0.32, cy + h * 0.10, cx + w * 0.22, cy - h * 0.08, cx, cy - h * 0.08)
      ..cubicTo(cx - w * 0.22, cy - h * 0.08, cx - w * 0.32, cy + h * 0.10, cx - w * 0.42, cy + h * 0.18)
      ..close();

    canvas.save();
    canvas.translate(0, h * 0.06);
    canvas.drawPath(crescentPath, Paint()..color = const Color(0xFF8B4513));
    canvas.restore();

    canvas.drawPath(
      crescentPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD166), Color(0xFFE08D3C), Color(0xFFA55416)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final ribPaint = Paint()
      ..color = const Color(0xFF7A3508)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(cx - w * 0.14, cy - h * 0.32),
      Offset(cx - w * 0.08, cy - h * 0.08),
      ribPaint,
    );
    canvas.drawLine(
      Offset(cx + w * 0.14, cy - h * 0.32),
      Offset(cx + w * 0.08, cy - h * 0.08),
      ribPaint,
    );

    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.22), width: w * 0.24, height: h * 0.14),
      -math.pi * 0.8,
      math.pi * 0.6,
      false,
      glossPaint,
    );
  }

  static void drawPizza(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    final slicePath = Path()
      ..moveTo(cx - w * 0.38, h * 0.25)
      ..quadraticBezierTo(cx, h * 0.18, cx + w * 0.38, h * 0.25)
      ..lineTo(cx + w * 0.06, h * 0.86)
      ..quadraticBezierTo(cx, h * 0.92, cx - w * 0.06, h * 0.86)
      ..close();

    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(slicePath, Paint()..color = const Color(0xFFB45309));
    canvas.restore();

    canvas.drawPath(
      slicePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD000), Color(0xFFFF9E00)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final crustPath = Path()
      ..moveTo(cx - w * 0.40, h * 0.26)
      ..quadraticBezierTo(cx, h * 0.16, cx + w * 0.40, h * 0.26)
      ..quadraticBezierTo(cx, h * 0.22, cx - w * 0.40, h * 0.26)
      ..close();
    canvas.drawPath(
      crustPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFE09F3E), Color(0xFF9E5A18)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    void drawPepperoni(Offset center, double r) {
      canvas.drawCircle(center + const Offset(0, 1), r, Paint()..color = const Color(0xFF7F1D1D));
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: const [Color(0xFFEF4444), Color(0xFFB91C1C)],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );
      canvas.drawCircle(center + Offset(-r * 0.3, -r * 0.3), r * 0.25, Paint()..color = Colors.white.withValues(alpha: 0.7));
    }

    drawPepperoni(Offset(cx - w * 0.12, h * 0.40), w * 0.09);
    drawPepperoni(Offset(cx + w * 0.14, h * 0.48), w * 0.08);
    drawPepperoni(Offset(cx - w * 0.04, h * 0.65), w * 0.075);
  }

  static void drawIceCream(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    final conePath = Path()
      ..moveTo(cx - w * 0.26, h * 0.50)
      ..lineTo(cx + w * 0.26, h * 0.50)
      ..lineTo(cx, h * 0.92)
      ..close();

    canvas.save();
    canvas.translate(0, h * 0.04);
    canvas.drawPath(conePath, Paint()..color = const Color(0xFF8B5A2B));
    canvas.restore();

    canvas.drawPath(
      conePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8B67B), Color(0xFFB87834)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFF7A4817).withValues(alpha: 0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(cx - w * 0.18, h * 0.56), Offset(cx + w * 0.08, h * 0.78), gridPaint);
    canvas.drawLine(Offset(cx + w * 0.18, h * 0.56), Offset(cx - w * 0.08, h * 0.78), gridPaint);

    void drawSwirlTier(double cy, double width, double height, Color c1, Color c2) {
      final rect = Rect.fromCenter(center: Offset(cx, cy), width: width, height: height);
      final p = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(height * 0.5)));
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.shift(const Offset(0, 1.5)), Radius.circular(height * 0.5)),
        Paint()..color = c2.withValues(alpha: 0.4),
      );
      canvas.drawPath(
        p,
        Paint()
          ..shader = LinearGradient(
            colors: [c1, c2],
          ).createShader(rect),
      );
      canvas.drawCircle(
        Offset(cx - width * 0.3, cy - height * 0.15),
        height * 0.2,
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
    }

    drawSwirlTier(h * 0.47, w * 0.62, h * 0.20, const Color(0xFF70D6FF), const Color(0xFF0096C7));
    drawSwirlTier(h * 0.33, w * 0.50, h * 0.18, const Color(0xFFFF99C8), const Color(0xFFFF5C8D));

    final tipPath = Path()
      ..moveTo(cx - w * 0.16, h * 0.27)
      ..quadraticBezierTo(cx - w * 0.05, h * 0.10, cx + w * 0.08, h * 0.12)
      ..quadraticBezierTo(cx + w * 0.18, h * 0.16, cx + w * 0.12, h * 0.27)
      ..close();
    canvas.drawPath(
      tipPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFE5F6FD), Color(0xFF70D6FF)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
  }
}
