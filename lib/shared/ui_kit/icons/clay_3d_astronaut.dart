import 'package:flutter/material.dart';

/// 3D Clay Astronaut Avatar Icon for "Cá nhân" (Profile) tab.
/// Chubby volumetric white clay helmet with celestial dark sapphire visor,
/// glossy specular reflection, and collar vitality badge.
class Clay3DAstronaut extends StatelessWidget {
  const Clay3DAstronaut({
    super.key,
    this.size = 22.0,
    this.isSelected = true,
  });

  final double size;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DAstronautPainter(isSelected: isSelected),
      ),
    );
  }
}

class _Clay3DAstronautPainter extends CustomPainter {
  const _Clay3DAstronautPainter({required this.isSelected});

  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.50, h * 0.46);
    final helmetRadius = w * 0.38;

    // 1. Helmet Drop Shadow
    final shadowPaint = Paint()
      ..color = isSelected ? const Color(0x301CB0F6) : const Color(0x181E2337)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawCircle(center + const Offset(0, 2.0), helmetRadius, shadowPaint);

    // 2. Helmet 3D Bottom Bevel
    final bevelPaint = Paint()
      ..color = isSelected ? const Color(0xFFDDD8CE) : const Color(0xFFE2E0D8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center + const Offset(0, 1.3), helmetRadius, bevelPaint);

    // 3. Helmet Main Body (Pure White Ceramic Clay)
    final helmetPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
      ).createShader(Rect.fromCircle(center: center, radius: helmetRadius));
    canvas.drawCircle(center, helmetRadius, helmetPaint);

    // 4. Celestial Sapphire Visor
    final visorRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + h * 0.02),
        width: w * 0.52,
        height: h * 0.36,
      ),
      Radius.circular(w * 0.16),
    );

    final visorPaint = Paint()
      ..shader = isSelected
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ).createShader(visorRect.outerRect)
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF475569), Color(0xFF334155)],
            ).createShader(visorRect.outerRect);
    canvas.drawRRect(visorRect, visorPaint);

    // 5. Visor Specular Gloss Curve (Ánh phản quang cong 3D)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: isSelected ? 0.75 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(center.dx - w * 0.18, center.dy - h * 0.06)
      ..quadraticBezierTo(
        center.dx - w * 0.08,
        center.dy - h * 0.12,
        center.dx + w * 0.08,
        center.dy - h * 0.08,
      );
    canvas.drawPath(glossPath, glossPaint);

    // 6. Collar / Neck Band (Đai cổ áo phi hành gia)
    final collarRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.25, h * 0.80, w * 0.50, h * 0.14),
      const Radius.circular(3.5),
    );
    final collarPaint = Paint()
      ..shader = isSelected
          ? const LinearGradient(
              colors: [Color(0xFF58CC02), Color(0xFF46A302)],
            ).createShader(collarRect.outerRect)
          : const LinearGradient(
              colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
            ).createShader(collarRect.outerRect);
    canvas.drawRRect(collarRect, collarPaint);

    // Tiny white badge dot on collar
    canvas.drawCircle(
      Offset(w * 0.50, h * 0.87),
      w * 0.035,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(covariant _Clay3DAstronautPainter oldDelegate) =>
      oldDelegate.isSelected != isSelected;
}
