import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter for the 4 glowing rounded corner brackets of the viewfinder.
class ViewfinderCornerPainter extends CustomPainter {
  ViewfinderCornerPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
  });

  final Color color;
  final double strokeWidth;
  final double cornerLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = strokeWidth + 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    const radius = 16.0;

    void drawCorner(Path path) {
      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, paint);
    }

    // Top-Left corner
    final tl = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, radius)
      ..arcToPoint(const Offset(radius, 0), radius: const Radius.circular(radius))
      ..lineTo(cornerLength, 0);
    drawCorner(tl);

    // Top-Right corner
    final tr = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: const Radius.circular(radius))
      ..lineTo(size.width, cornerLength);
    drawCorner(tr);

    // Bottom-Left corner
    final bl = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - radius)
      ..arcToPoint(Offset(radius, size.height), radius: const Radius.circular(radius))
      ..lineTo(cornerLength, size.height);
    drawCorner(bl);

    // Bottom-Right corner
    final br = Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(Offset(size.width, size.height - radius), radius: const Radius.circular(radius))
      ..lineTo(size.width, size.height - cornerLength);
    drawCorner(br);
  }

  @override
  bool shouldRepaint(covariant ViewfinderCornerPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      cornerLength != oldDelegate.cornerLength;
}

/// Central rotating holographic reticle with dashed concentric segments.
class HolographicReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ringPaint = Paint()
      ..color = const Color(0xFF1CB0F6).withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Outer dashed ring (8 segments)
    const segments = 8;
    const sweep = (2 * math.pi) / segments;
    for (int i = 0; i < segments; i++) {
      if (i % 2 == 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          i * sweep,
          sweep * 0.65,
          false,
          ringPaint,
        );
      }
    }

    // Inner subtle ring
    final innerPaint = Paint()
      ..color = const Color(0xFF1CB0F6).withValues(alpha: 0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius * 0.65, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Inner crosshair tick marks at 12, 3, 6, 9 o'clock.
class PrecisionCrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF1CB0F6).withValues(alpha: 0.7)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const tick = 6.0;
    const gap = 8.0;

    // Top
    canvas.drawLine(Offset(center.dx, center.dy - gap), Offset(center.dx, center.dy - gap - tick), paint);
    // Bottom
    canvas.drawLine(Offset(center.dx, center.dy + gap), Offset(center.dx, center.dy + gap + tick), paint);
    // Left
    canvas.drawLine(Offset(center.dx - gap, center.dy), Offset(center.dx - gap - tick, center.dy), paint);
    // Right
    canvas.drawLine(Offset(center.dx + gap, center.dy), Offset(center.dx + gap + tick, center.dy), paint);

    // Center focal point dot
    final dotPaint = Paint()..color = const Color(0xFF1CB0F6).withValues(alpha: 0.85);
    canvas.drawCircle(center, 2.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Subtle HUD grid background overlay.
class HudGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1CB0F6).withValues(alpha: 0.04)
      ..strokeWidth = 0.8;

    const divisions = 4;
    final stepX = size.width / divisions;
    final stepY = size.height / divisions;

    for (int i = 1; i < divisions; i++) {
      canvas.drawLine(Offset(stepX * i, 0), Offset(stepX * i, size.height), paint);
      canvas.drawLine(Offset(0, stepY * i), Offset(size.width, stepY * i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
