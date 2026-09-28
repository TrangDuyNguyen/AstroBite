import 'package:flutter/material.dart';

/// 3D Clay Macro Analytics Chart Icon for "Thống kê" (Insights) tab.
/// Chubby volumetric 3D pillars representing Carbs (Sky Blue), Protein (Tangerine),
/// and Fat (Strawberry Pink) with rounded caps and specular gloss.
class Clay3DAnalyticsChart extends StatelessWidget {
  const Clay3DAnalyticsChart({
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
        painter: _Clay3DAnalyticsChartPainter(isSelected: isSelected),
      ),
    );
  }
}

class _Clay3DAnalyticsChartPainter extends CustomPainter {
  const _Clay3DAnalyticsChartPainter({required this.isSelected});

  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Pillar Definitions: [xRatio, widthRatio, heightRatio, gradientColors, bevelColor, shadowColor]
    final pillars = [
      // 1. Left Pillar (Carbs — Sky Blue)
      _PillarSpec(
        x: w * 0.12,
        width: w * 0.22,
        height: h * 0.48,
        colors: isSelected
            ? const [Color(0xFF38BDF8), Color(0xFF1CB0F6)]
            : const [Color(0xFF94A3B8), Color(0xFF64748B)],
        bevelColor: isSelected ? const Color(0xFF1488C2) : const Color(0xFF475569),
        shadowColor: isSelected ? const Color(0x301CB0F6) : const Color(0x151E2337),
      ),
      // 2. Middle Pillar (Protein — Honey Tangerine)
      _PillarSpec(
        x: w * 0.39,
        width: w * 0.22,
        height: h * 0.82,
        colors: isSelected
            ? const [Color(0xFFFFB300), Color(0xFFFF9600)]
            : const [Color(0xFFCBD5E1), Color(0xFF94A3B8)],
        bevelColor: isSelected ? const Color(0xFFD47700) : const Color(0xFF64748B),
        shadowColor: isSelected ? const Color(0x35FF9600) : const Color(0x151E2337),
      ),
      // 3. Right Pillar (Fat — Strawberry Pink)
      _PillarSpec(
        x: w * 0.66,
        width: w * 0.22,
        height: h * 0.64,
        colors: isSelected
            ? const [Color(0xFFFF8DAF), Color(0xFFFF5C8D)]
            : const [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
        bevelColor: isSelected ? const Color(0xFFD6336C) : const Color(0xFF94A3B8),
        shadowColor: isSelected ? const Color(0x30FF5C8D) : const Color(0x151E2337),
      ),
    ];

    final bottomY = h * 0.92;

    for (final p in pillars) {
      final topY = bottomY - p.height;
      final radius = Radius.circular(p.width * 0.45);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(p.x, topY, p.width, p.height),
        radius,
      );

      // 1. Drop Shadow
      final shadowPaint = Paint()
        ..color = p.shadowColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawRRect(rrect.shift(const Offset(0, 1.8)), shadowPaint);

      // 2. 3D Bottom Bevel
      final bevelPaint = Paint()
        ..color = p.bevelColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect.shift(const Offset(0, 1.2)), bevelPaint);

      // 3. Pillar Body Gradient
      final bodyPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: p.colors,
        ).createShader(Rect.fromLTWH(p.x, topY, p.width, p.height));
      canvas.drawRRect(rrect, bodyPaint);

      // 4. Specular Gloss Reflection on rounded cap
      final glossPaint = Paint()
        ..color = Colors.white.withValues(alpha: isSelected ? 0.75 : 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;

      final glossPath = Path()
        ..moveTo(p.x + p.width * 0.25, topY + p.width * 0.35)
        ..quadraticBezierTo(
          p.x + p.width * 0.5,
          topY + p.width * 0.15,
          p.x + p.width * 0.75,
          topY + p.width * 0.35,
        );
      canvas.drawPath(glossPath, glossPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _Clay3DAnalyticsChartPainter oldDelegate) =>
      oldDelegate.isSelected != isSelected;
}

class _PillarSpec {
  const _PillarSpec({
    required this.x,
    required this.width,
    required this.height,
    required this.colors,
    required this.bevelColor,
    required this.shadowColor,
  });

  final double x;
  final double width;
  final double height;
  final List<Color> colors;
  final Color bevelColor;
  final Color shadowColor;
}
