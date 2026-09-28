import 'package:flutter/material.dart';

/// 3D Clay Sugar Cube / Sweetness icon.
/// Handcrafted with isometric 3D clay facets, warm honey gradient, and sparkle shine.
class Clay3DSugarCube extends StatelessWidget {
  const Clay3DSugarCube({
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
        painter: _Clay3DSugarCubePainter(
          accentColor: accentColor ?? const Color(0xFFFF9600),
        ),
      ),
    );
  }
}

class _Clay3DSugarCubePainter extends CustomPainter {
  const _Clay3DSugarCubePainter({required this.accentColor});

  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Bottom shadow
    final shadowPaint = Paint()
      ..color = const Color(0x25000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.88),
        width: w * 0.68,
        height: h * 0.20,
      ),
      shadowPaint,
    );

    // 2. Isometric 3D Cube Facets
    // Center point of top 3 visible faces
    final center = Offset(w * 0.50, h * 0.48);
    final top = Offset(w * 0.50, h * 0.15);
    final leftTop = Offset(w * 0.18, h * 0.32);
    final rightTop = Offset(w * 0.82, h * 0.32);
    final leftBottom = Offset(w * 0.18, h * 0.66);
    final rightBottom = Offset(w * 0.82, h * 0.66);
    final bottom = Offset(w * 0.50, h * 0.82);

    // Face A: Top Face (brightest highlight)
    final topFace = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(rightTop.dx, rightTop.dy)
      ..lineTo(center.dx, center.dy)
      ..lineTo(leftTop.dx, leftTop.dy)
      ..close();
    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Color.lerp(accentColor, Colors.white, 0.65)!,
        ],
      ).createShader(Rect.fromLTWH(w * 0.18, h * 0.15, w * 0.64, h * 0.35));
    canvas.drawPath(topFace, topPaint);

    // Face B: Left Face (mid-tone)
    final leftFace = Path()
      ..moveTo(leftTop.dx, leftTop.dy)
      ..lineTo(center.dx, center.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(leftBottom.dx, leftBottom.dy)
      ..close();
    final leftPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(accentColor, Colors.white, 0.35)!,
          accentColor,
        ],
      ).createShader(Rect.fromLTWH(w * 0.18, h * 0.32, w * 0.32, h * 0.52));
    canvas.drawPath(leftFace, leftPaint);

    // Face C: Right Face (deep shadow tone)
    final rightFace = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(rightTop.dx, rightTop.dy)
      ..lineTo(rightBottom.dx, rightBottom.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..close();
    final rightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          accentColor,
          Color.lerp(accentColor, Colors.black, 0.25)!,
        ],
      ).createShader(Rect.fromLTWH(w * 0.50, h * 0.32, w * 0.32, h * 0.52));
    canvas.drawPath(rightFace, rightPaint);

    // 3. Facet outline / soft bevel borders
    final edgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, top, edgePaint);
    canvas.drawLine(center, leftTop, edgePaint);
    canvas.drawLine(center, rightTop, edgePaint);
    canvas.drawLine(center, bottom, edgePaint);

    // 4. Sparkle glint on top vertex
    final sparklePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(top.dx, top.dy + 1), 1.2, sparklePaint);
  }

  @override
  bool shouldRepaint(covariant _Clay3DSugarCubePainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}
