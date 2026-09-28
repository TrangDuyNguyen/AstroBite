import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Clay Carrot Spaceship (Tàu Vũ Trụ Củ Cà Rốt 3D) for the Celestial Cockpit.
/// Features a chubby vibrant orange carrot fuselage with realistic ridges,
/// cosmic green foliage thruster fins, an astronaut cockpit porthole window,
/// starlight flame thrust, and 3D glossy highlight.
class Clay3DCarrotRocket extends StatelessWidget {
  const Clay3DCarrotRocket({
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
        painter: const _Clay3DCarrotRocketPainter(),
      ),
    );
  }
}

/// Backward compatibility alias: Clay3DRocket now renders the signature Carrot Spaceship
typedef Clay3DRocket = Clay3DCarrotRocket;

class _Clay3DCarrotRocketPainter extends CustomPainter {
  const _Clay3DCarrotRocketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Rotate canvas 45 degrees so carrot rocket launches diagonally up-right
    canvas.save();
    canvas.translate(w * 0.5, h * 0.5);
    canvas.rotate(math.pi / 4);
    canvas.translate(-w * 0.5, -h * 0.5);

    // 1. Starlight Thrust Flame at bottom
    final flamePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFEA00), Color(0xFFFF9100), Color(0xFFFF3D00)],
      ).createShader(Rect.fromLTWH(w * 0.36, h * 0.74, w * 0.28, h * 0.26));

    final flamePath = Path()
      ..moveTo(w * 0.38, h * 0.74)
      ..quadraticBezierTo(w * 0.28, h * 0.86, w * 0.50, h * 0.98)
      ..quadraticBezierTo(w * 0.72, h * 0.86, w * 0.62, h * 0.74)
      ..close();
    canvas.drawPath(flamePath, flamePaint);

    // Inner bright flame core
    final innerFlamePaint = Paint()..color = const Color(0xFFFFF9C4);
    final innerFlamePath = Path()
      ..moveTo(w * 0.42, h * 0.74)
      ..quadraticBezierTo(w * 0.36, h * 0.83, w * 0.50, h * 0.90)
      ..quadraticBezierTo(w * 0.64, h * 0.83, w * 0.58, h * 0.74)
      ..close();
    canvas.drawPath(innerFlamePath, innerFlamePaint);

    // 2. Carrot Foliage Greenery Fins (Cánh lá cà rốt vũ trụ 3D)
    final leafPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF76E01A),
          Color(0xFF58CC02),
          Color(0xFF2E7D32),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Left foliage wing
    final leftLeaf = Path()
      ..moveTo(w * 0.32, h * 0.58)
      ..cubicTo(w * 0.08, h * 0.60, w * 0.06, h * 0.78, w * 0.30, h * 0.76)
      ..close();
    canvas.drawPath(leftLeaf.shift(const Offset(0, 1.2)), Paint()..color = const Color(0xFF1B5E20));
    canvas.drawPath(leftLeaf, leafPaint);

    // Right foliage wing
    final rightLeaf = Path()
      ..moveTo(w * 0.68, h * 0.58)
      ..cubicTo(w * 0.92, h * 0.60, w * 0.94, h * 0.78, w * 0.70, h * 0.76)
      ..close();
    canvas.drawPath(rightLeaf.shift(const Offset(0, 1.2)), Paint()..color = const Color(0xFF1B5E20));
    canvas.drawPath(rightLeaf, leafPaint);

    // 3. Carrot Fuselage (Thân củ cà rốt đất sét 3D múp míp)
    final carrotPath = Path()
      ..moveTo(w * 0.50, h * 0.05) // Top rounded carrot nose tip
      ..cubicTo(w * 0.65, h * 0.12, w * 0.75, h * 0.42, w * 0.66, h * 0.74)
      ..quadraticBezierTo(w * 0.50, h * 0.77, w * 0.34, h * 0.74)
      ..cubicTo(w * 0.25, h * 0.42, w * 0.35, h * 0.12, w * 0.50, h * 0.05)
      ..close();

    // 3D Bottom Bevel Shadow
    canvas.drawPath(
      carrotPath.shift(const Offset(0, 1.8)),
      Paint()..color = const Color(0xFFBF360C),
    );

    // Volumetric Carrot Clay Gradient
    final carrotPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.35),
        radius: 0.90,
        colors: [
          Color(0xFFFFB74D), // Soft golden carrot highlight
          Color(0xFFFF9100), // Vibrant carrot orange
          Color(0xFFFF5722), // Saturated Duolingo tangerine
          Color(0xFFD84315), // Deep terracotta bevel
        ],
      ).createShader(Rect.fromLTWH(w * 0.26, h * 0.05, w * 0.48, h * 0.72));
    canvas.drawPath(carrotPath, carrotPaint);

    // 4. Characteristic Carrot Ridges / Grooves (Các khía ngang củ cà rốt 3D)
    final ridgePaint = Paint()
      ..color = const Color(0xFFD84315)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(w * 0.36, h * 0.22), Offset(w * 0.47, h * 0.23), ridgePaint);
    canvas.drawLine(Offset(w * 0.54, h * 0.34), Offset(w * 0.64, h * 0.35), ridgePaint);
    canvas.drawLine(Offset(w * 0.34, h * 0.52), Offset(w * 0.45, h * 0.53), ridgePaint);
    canvas.drawLine(Offset(w * 0.52, h * 0.62), Offset(w * 0.63, h * 0.63), ridgePaint);

    // 5. Cockpit Porthole Window (Cửa sổ phi thuyền không gian 3D)
    final windowCenter = Offset(w * 0.50, h * 0.40);
    final windowR = w * 0.12;

    // Window metallic frame
    canvas.drawCircle(
      windowCenter,
      windowR + 1.2,
      Paint()..color = const Color(0xFFE65100),
    );

    // Window glass
    final glassPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFBAE6FD), Color(0xFF0284C7)],
      ).createShader(Rect.fromCircle(center: windowCenter, radius: windowR));
    canvas.drawCircle(windowCenter, windowR, glassPaint);

    // Window starlight glint
    canvas.drawCircle(
      Offset(windowCenter.dx - windowR * 0.35, windowCenter.dy - windowR * 0.35),
      windowR * 0.30,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    // 6. Gloss Specular Highlight Curve on Carrot Body
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(w * 0.40, h * 0.12)
      ..quadraticBezierTo(w * 0.35, h * 0.28, w * 0.37, h * 0.48);
    canvas.drawPath(glossPath, glossPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _Clay3DCarrotRocketPainter oldDelegate) => false;
}
