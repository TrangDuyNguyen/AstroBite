import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints twinkling cosmic stardust and micro-stars drifting across the cosmos.
class CosmicStardustPainter extends CustomPainter {
  const CosmicStardustPainter({required this.progress});

  final double progress;

  // Normalized (x, y, radius, color, seed)
  static const List<(double, double, double, Color, double)> _stars = [
    (0.24, 0.19, 2.5, Color(0xFFF59E0B), 0.1), // Golden micro-star
    (0.78, 0.20, 2.2, Color(0xFF1CB0F6), 0.7), // Sky blue stardust
    (0.48, 0.04, 2.8, Color(0xFFF59E0B), 1.3), // Top gold star
    (0.04, 0.48, 2.0, Color(0xFFFF5C8D), 2.2), // Pink stardust
    (0.96, 0.48, 2.4, Color(0xFF58CC02), 3.0), // Mint stardust
    (0.12, 0.82, 2.6, Color(0xFFF59E0B), 0.4), // Golden star
    (0.88, 0.82, 2.2, Color(0xFF9D65FF), 1.9), // Taro stardust
    (0.38, 0.84, 2.0, Color(0xFF1CB0F6), 2.5), // Sky stardust
    (0.64, 0.84, 2.2, Color(0xFFFF5C8D), 3.4), // Pink stardust
    (0.50, 0.93, 2.6, Color(0xFFF59E0B), 1.1), // Bottom star
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final twoPi = 2 * math.pi;

    for (final star in _stars) {
      final x = star.$1 * size.width;
      final y = star.$2 * size.height;
      final baseR = star.$3;
      final color = star.$4;
      final seed = star.$5;

      // Soft twinkle pulsing
      final pulse = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(progress * twoPi * 1.5 + seed));
      final currentR = baseR * (0.85 + 0.3 * pulse);

      final paint = Paint()
        ..color = color.withValues(alpha: pulse * 0.75)
        ..style = PaintingStyle.fill;

      // Draw 4-pointed micro diamond sparkle
      final path = Path()
        ..moveTo(x, y - currentR * 1.4)
        ..quadraticBezierTo(x, y, x + currentR * 1.4, y)
        ..quadraticBezierTo(x, y, x, y + currentR * 1.4)
        ..quadraticBezierTo(x, y, x - currentR * 1.4, y)
        ..quadraticBezierTo(x, y, x, y - currentR * 1.4)
        ..close();

      canvas.drawPath(path, paint);

      // Core white sparkle dot
      canvas.drawCircle(
        Offset(x, y),
        currentR * 0.4,
        Paint()..color = Colors.white.withValues(alpha: pulse * 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CosmicStardustPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
