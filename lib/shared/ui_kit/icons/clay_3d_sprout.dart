import 'package:flutter/material.dart';

/// 3D Clay Sprout / Dietary Fiber vitality icon.
/// Handcrafted with plump dual clay leaves, organic curved stem, and glossy highlights.
class Clay3DSprout extends StatelessWidget {
  const Clay3DSprout({
    super.key,
    this.size = 20.0,
    this.accentColor,
  });

  final double size;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DSproutPainter(
          accentColor: accentColor ?? const Color(0xFF58CC02),
        ),
      ),
    );
  }
}

class _Clay3DSproutPainter extends CustomPainter {
  const _Clay3DSproutPainter({required this.accentColor});

  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Bottom shadow
    final shadowPaint = Paint()
      ..color = const Color(0x22000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.90),
        width: w * 0.60,
        height: h * 0.16,
      ),
      shadowPaint,
    );

    // 2. Organic curved stem
    final stemPaint = Paint()
      ..color = Color.lerp(accentColor, Colors.black, 0.25)!
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final stemPath = Path()
      ..moveTo(w * 0.50, h * 0.88)
      ..quadraticBezierTo(w * 0.52, h * 0.62, w * 0.46, h * 0.42);
    canvas.drawPath(stemPath, stemPaint);

    // 3. Left Leaf (Plump clay teardrop)
    final leftLeafPath = Path()
      ..moveTo(w * 0.46, h * 0.55)
      ..cubicTo(w * 0.32, h * 0.54, w * 0.12, h * 0.42, w * 0.14, h * 0.26)
      ..cubicTo(w * 0.30, h * 0.25, w * 0.42, h * 0.40, w * 0.46, h * 0.55)
      ..close();

    final leftLeafPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(accentColor, Colors.white, 0.4)!,
          accentColor,
          Color.lerp(accentColor, Colors.black, 0.2)!,
        ],
      ).createShader(Rect.fromLTWH(w * 0.12, h * 0.25, w * 0.36, h * 0.32));
    canvas.drawPath(leftLeafPath, leftLeafPaint);

    // Left leaf gloss highlight
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final leftGlossPath = Path()
      ..moveTo(w * 0.18, h * 0.30)
      ..quadraticBezierTo(w * 0.28, h * 0.28, w * 0.38, h * 0.38);
    canvas.drawPath(leftGlossPath, glossPaint);

    // 4. Right Leaf (Pointing up-right, vibrant)
    final rightLeafPath = Path()
      ..moveTo(w * 0.46, h * 0.46)
      ..cubicTo(w * 0.64, h * 0.42, w * 0.86, h * 0.26, w * 0.82, h * 0.12)
      ..cubicTo(w * 0.66, h * 0.14, w * 0.52, h * 0.30, w * 0.46, h * 0.46)
      ..close();

    final rightLeafPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(accentColor, Colors.white, 0.5)!,
          accentColor,
          Color.lerp(accentColor, Colors.black, 0.15)!,
        ],
      ).createShader(Rect.fromLTWH(w * 0.44, h * 0.12, w * 0.42, h * 0.36));
    canvas.drawPath(rightLeafPath, rightLeafPaint);

    // Right leaf gloss
    final rightGlossPath = Path()
      ..moveTo(w * 0.76, h * 0.16)
      ..quadraticBezierTo(w * 0.64, h * 0.20, w * 0.54, h * 0.34);
    canvas.drawPath(rightGlossPath, glossPaint);
  }

  @override
  bool shouldRepaint(covariant _Clay3DSproutPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}
