import 'package:flutter/material.dart';

/// 3D Clay Starlight Shield icon.
/// Cute medieval celestial kite shield with metallic cyan-silver sheen and embossed star.
class Clay3DShield extends StatelessWidget {
  const Clay3DShield({
    super.key,
    this.size = 18.0,
    this.isActive = true,
  });

  final double size;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size * 0.90, size),
        painter: _Clay3DShieldPainter(isActive: isActive),
      ),
    );
  }
}

class _Clay3DShieldPainter extends CustomPainter {
  const _Clay3DShieldPainter({required this.isActive});

  final bool isActive;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Drop Shadow
    final shadowPaint = Paint()
      ..color = isActive ? const Color(0x3538BDF8) : const Color(0x18000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    final shadowPath = _createShieldPath(w, h).shift(const Offset(0, 2.0));
    canvas.drawPath(shadowPath, shadowPaint);

    // 2. 3D Bottom Bevel Shadow
    final bevelPaint = Paint()
      ..color = isActive ? const Color(0xFF0369A1) : const Color(0xFF475569)
      ..style = PaintingStyle.fill;
    final bevelPath = _createShieldPath(w, h).shift(const Offset(0, 1.5));
    canvas.drawPath(bevelPath, bevelPaint);

    // 3. Shield Body with Volumetric Gradient
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isActive
            ? const [
                Color(0xFFBAE6FD),
                Color(0xFF38BDF8),
                Color(0xFF0284C7),
              ]
            : const [
                Color(0xFFE2E8F0),
                Color(0xFF94A3B8),
                Color(0xFF64748B),
              ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final bodyPath = _createShieldPath(w, h);
    canvas.drawPath(bodyPath, bodyPaint);

    // 4. Embossed Micro Celestial Star / Cross in center
    final center = Offset(w * 0.50, h * 0.48);
    final starR = w * 0.22;
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: isActive ? 0.95 : 0.80)
      ..style = PaintingStyle.fill;

    final starPath = Path()
      ..moveTo(center.dx, center.dy - starR)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + starR * 0.8, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + starR)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - starR * 0.8, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - starR)
      ..close();
    canvas.drawPath(starPath, starPaint);

    // 5. Specular Gloss on Top Rim
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(w * 0.22, h * 0.16)
      ..quadraticBezierTo(w * 0.50, h * 0.12, w * 0.78, h * 0.16);
    canvas.drawPath(glossPath, glossPaint);
  }

  Path _createShieldPath(double w, double h) {
    return Path()
      ..moveTo(w * 0.12, h * 0.12)
      ..quadraticBezierTo(w * 0.50, h * 0.04, w * 0.88, h * 0.12)
      ..cubicTo(w * 0.92, h * 0.44, w * 0.78, h * 0.76, w * 0.50, h * 0.96)
      ..cubicTo(w * 0.22, h * 0.76, w * 0.08, h * 0.44, w * 0.12, h * 0.12)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _Clay3DShieldPainter oldDelegate) {
    return oldDelegate.isActive != isActive;
  }
}
