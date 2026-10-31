import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Procedural 3D Claymorphic Microphone painter with physical lighting & metallic mesh.
class Clay3DMicFallbackPainter extends CustomPainter {
  const Clay3DMicFallbackPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // 1. Base stand plate (3D disc)
    final baseRect = Rect.fromCenter(
      center: Offset(cx, cy + 28),
      width: 44,
      height: 14,
    );
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF64B5F6), Color(0xFF0D47A1)],
      ).createShader(baseRect);
    canvas.drawOval(baseRect, basePaint);

    // 2. Vertical stand stem
    final stemRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + 18), width: 8, height: 18),
      const Radius.circular(4),
    );
    final stemPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF90CAF9), Color(0xFF1565C0)],
      ).createShader(stemRect.outerRect);
    canvas.drawRRect(stemRect, stemPaint);

    // 3. Microphone Capsule Body (Pill)
    final micRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - 6), width: 34, height: 46),
      const Radius.circular(17),
    );
    final micPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.45),
        radius: 0.95,
        colors: [
          Color(0xFF64D8FF),
          Color(0xFF1CB0F6),
          Color(0xFF0288D1),
          Color(0xFF01579B),
        ],
      ).createShader(micRect.outerRect);
    canvas.drawRRect(micRect, micPaint);

    // 4. Horizontal metallic mesh grille lines
    final grillePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    for (int i = -16; i <= 6; i += 7) {
      canvas.drawLine(
        Offset(cx - 11, cy + i),
        Offset(cx + 11, cy + i),
        grillePaint,
      );
    }

    // 5. Specular spherical 3D highlight (top-left glossy reflection)
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final highlightArcRect = Rect.fromCircle(
      center: Offset(cx - 5, cy - 14),
      radius: 9,
    );
    canvas.drawArc(highlightArcRect, math.pi * 1.1, math.pi * 0.7, false, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

