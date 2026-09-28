import 'package:flutter/material.dart';

/// 3D Clay Salt Shaker / Sodium mineral icon.
/// Handcrafted with glass/mineral jar, metallic cap with shaker holes, salt crystal pile,
/// and glossy specular reflections.
class Clay3DSaltShaker extends StatelessWidget {
  const Clay3DSaltShaker({
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
        painter: _Clay3DSaltShakerPainter(
          accentColor: accentColor ?? const Color(0xFF00B0FF),
        ),
      ),
    );
  }
}

class _Clay3DSaltShakerPainter extends CustomPainter {
  const _Clay3DSaltShakerPainter({required this.accentColor});

  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Bottom shadow
    final shadowPaint = Paint()
      ..color = const Color(0x28000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.88),
        width: w * 0.68,
        height: h * 0.20,
      ),
      shadowPaint,
    );

    // 2. Glass / Mineral jar body
    final jarRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.22, h * 0.36, w * 0.56, h * 0.50),
      const Radius.circular(5.0),
    );
    final jarPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(accentColor, Colors.white, 0.75)!,
          Color.lerp(accentColor, Colors.white, 0.45)!,
          Color.lerp(accentColor, Colors.white, 0.25)!,
        ],
      ).createShader(Rect.fromLTWH(w * 0.22, h * 0.36, w * 0.56, h * 0.50));
    canvas.drawRRect(jarRRect, jarPaint);

    // 3. Salt pile inside (white crystals)
    final saltRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.26, h * 0.50, w * 0.48, h * 0.32),
      const Radius.circular(3.5),
    );
    final saltPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFE8F4FD)],
      ).createShader(Rect.fromLTWH(w * 0.26, h * 0.50, w * 0.48, h * 0.32));
    canvas.drawRRect(saltRRect, saltPaint);

    // 4. Shaker Cap (Chrome / metallic clay)
    final capRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.28, h * 0.16, w * 0.44, h * 0.22),
      const Radius.circular(3.5),
    );
    final capPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFCFD8DC), Color(0xFF90A4AE)],
      ).createShader(Rect.fromLTWH(w * 0.28, h * 0.16, w * 0.44, h * 0.22));
    canvas.drawRRect(capRRect, capPaint);

    // Cap shaker holes
    final holePaint = Paint()..color = const Color(0xFF607D8B);
    canvas.drawCircle(Offset(w * 0.38, h * 0.26), 0.9, holePaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.24), 0.9, holePaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.26), 0.9, holePaint);

    // 5. Specular gloss highlight on left jar side
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.28, h * 0.42), Offset(w * 0.28, h * 0.78), glossPaint);

    // 6. Sparkle glint on top right
    final sparklePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.68, h * 0.42), 1.0, sparklePaint);
  }

  @override
  bool shouldRepaint(covariant _Clay3DSaltShakerPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}
