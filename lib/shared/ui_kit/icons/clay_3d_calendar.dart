import 'package:flutter/material.dart';

/// 3D Clay Calendar Icon for "Hôm nay" (Today) tab.
/// Chubby volumetric ceramic calendar with Sky Blue header, binder rings, and specular gloss.
class Clay3DCalendar extends StatelessWidget {
  const Clay3DCalendar({
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
        painter: _Clay3DCalendarPainter(isSelected: isSelected),
      ),
    );
  }
}

class _Clay3DCalendarPainter extends CustomPainter {
  const _Clay3DCalendarPainter({required this.isSelected});

  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Drop Shadow
    final shadowPaint = Paint()
      ..color = isSelected ? const Color(0x301CB0F6) : const Color(0x181E2337)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    final cardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.18, w * 0.80, h * 0.74),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(cardRect.shift(const Offset(0, 1.8)), shadowPaint);

    // 2. 3D Bottom Bevel
    final bevelPaint = Paint()
      ..color = isSelected ? const Color(0xFFDDD8CE) : const Color(0xFFE2E0D8)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(cardRect.shift(const Offset(0, 1.2)), bevelPaint);

    // 3. Main Calendar Base (Pure White Clay)
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFF8F6F2)],
      ).createShader(Rect.fromLTWH(w * 0.10, h * 0.18, w * 0.80, h * 0.74));
    canvas.drawRRect(cardRect, bodyPaint);

    // 4. Header Band (Duolingo Sky Blue or Muted Slate)
    final headerRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.10, h * 0.18, w * 0.80, h * 0.26),
      topLeft: const Radius.circular(5.5),
      topRight: const Radius.circular(5.5),
    );
    final headerPaint = Paint()
      ..shader = isSelected
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF38BDF8), Color(0xFF1CB0F6)],
            ).createShader(Rect.fromLTWH(w * 0.10, h * 0.18, w * 0.80, h * 0.26))
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
            ).createShader(Rect.fromLTWH(w * 0.10, h * 0.18, w * 0.80, h * 0.26));
    canvas.drawRRect(headerRect, headerPaint);

    // 5. Header Bottom Bevel line
    final headerBevelPaint = Paint()
      ..color = isSelected ? const Color(0xFF1488C2) : const Color(0xFF475569)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.10, h * 0.44),
      Offset(w * 0.90, h * 0.44),
      headerBevelPaint,
    );

    // 6. Twin Binder Rings (Top metallic/clay loops)
    final ringPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFCBD5E1)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final ringStroke = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (final xRatio in [0.32, 0.68]) {
      final ringRRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * xRatio, h * 0.18),
          width: w * 0.11,
          height: h * 0.18,
        ),
        const Radius.circular(2.5),
      );
      canvas.drawRRect(ringRRect, ringPaint);
      canvas.drawRRect(ringRRect, ringStroke);
    }

    // 7. Embossed Calendar Dates (2x2 grid of chubby dots)
    final dotPaintMuted = Paint()
      ..color = isSelected ? const Color(0xFFCBD5E1) : const Color(0xFFE2E8F0);
    final dotPaintActive = Paint()
      ..color = isSelected ? const Color(0xFFFF9600) : const Color(0xFF94A3B8);

    final dotPositions = [
      Offset(w * 0.34, h * 0.58),
      Offset(w * 0.66, h * 0.58),
      Offset(w * 0.34, h * 0.76),
      Offset(w * 0.66, h * 0.76),
    ];

    for (int i = 0; i < dotPositions.length; i++) {
      final pos = dotPositions[i];
      final isToday = i == 3; // Bottom right dot is today
      canvas.drawCircle(
        pos,
        w * 0.075,
        isToday ? dotPaintActive : dotPaintMuted,
      );
      if (isToday && isSelected) {
        // Tiny highlight on today dot
        canvas.drawCircle(
          pos - Offset(w * 0.02, h * 0.02),
          w * 0.025,
          Paint()..color = Colors.white.withValues(alpha: 0.8),
        );
      }
    }

    // 8. Specular Gloss Curve along top of header
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.18, h * 0.22),
      Offset(w * 0.82, h * 0.22),
      glossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _Clay3DCalendarPainter oldDelegate) =>
      oldDelegate.isSelected != isSelected;
}
