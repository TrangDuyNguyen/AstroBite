import 'package:flutter/material.dart';

/// 3D Clay AstroBot Icon for the "AstroCoach" AI feature.
/// Chubby volumetric robot with glowing AI visor eyes, satellite antenna,
/// ear pods, dual-layer clay bevel, and glossy specular reflection.
class Clay3DAstroBot extends StatelessWidget {
  const Clay3DAstroBot({
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
        painter: _Clay3DAstroBotPainter(isSelected: isSelected),
      ),
    );
  }
}

class _Clay3DAstroBotPainter extends CustomPainter {
  const _Clay3DAstroBotPainter({required this.isSelected});

  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Top Satellite Antenna (Ăng-ten vệ tinh trên đỉnh đầu)
    final antennaStemPaint = Paint()
      ..color = isSelected ? const Color(0xFF64748B) : const Color(0xFF94A3B8)
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.50, h * 0.22),
      Offset(w * 0.50, h * 0.12),
      antennaStemPaint,
    );

    // Antenna Glowing Tip (Chóp ăng-ten phát sóng AI)
    final tipCenter = Offset(w * 0.50, h * 0.09);
    final tipRadius = w * 0.09;

    if (isSelected) {
      // Glow halo
      final glowPaint = Paint()
        ..color = const Color(0x6038BDF8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawCircle(tipCenter, tipRadius * 1.5, glowPaint);
    }

    final tipPaint = Paint()
      ..shader = isSelected
          ? const RadialGradient(
              colors: [Color(0xFFBAE6FD), Color(0xFF0284C7)],
            ).createShader(Rect.fromCircle(center: tipCenter, radius: tipRadius))
          : const RadialGradient(
              colors: [Color(0xFFE2E8F0), Color(0xFF64748B)],
            ).createShader(Rect.fromCircle(center: tipCenter, radius: tipRadius));
    canvas.drawCircle(tipCenter, tipRadius, tipPaint);

    // Tip specular highlight
    canvas.drawCircle(
      tipCenter - Offset(tipRadius * 0.3, tipRadius * 0.3),
      tipRadius * 0.3,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // 2. Ear Pods / Headset (Tai nghe 2 bên tròn béo 3D)
    final earRadius = w * 0.11;
    for (final xSign in [-1, 1]) {
      final earCenter = Offset(w * 0.50 + xSign * (w * 0.40), h * 0.56);
      
      // Ear shadow & bevel
      final earBevel = Paint()
        ..color = isSelected ? const Color(0xFF0284C7) : const Color(0xFF475569);
      canvas.drawCircle(earCenter + const Offset(0, 1.2), earRadius, earBevel);

      final earPaint = Paint()
        ..shader = isSelected
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF38BDF8), Color(0xFF1CB0F6)],
              ).createShader(Rect.fromCircle(center: earCenter, radius: earRadius))
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
              ).createShader(Rect.fromCircle(center: earCenter, radius: earRadius));
      canvas.drawCircle(earCenter, earRadius, earPaint);

      // Ear gloss highlight
      canvas.drawCircle(
        earCenter - Offset(earRadius * 0.25, earRadius * 0.25),
        earRadius * 0.32,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );
    }

    // 3. Head Shell (Thân đầu Robot tròn trịa bằng gốm sứ trắng)
    final headRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.56),
        width: w * 0.72,
        height: h * 0.64,
      ),
      Radius.circular(w * 0.26),
    );

    // Head Drop Shadow
    final shadowPaint = Paint()
      ..color = isSelected ? const Color(0x301CB0F6) : const Color(0x181E2337)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    canvas.drawRRect(headRect.shift(const Offset(0, 2.0)), shadowPaint);

    // 3D Bottom Bevel
    final bevelPaint = Paint()
      ..color = isSelected ? const Color(0xFFDDD8CE) : const Color(0xFFE2E0D8)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(headRect.shift(const Offset(0, 1.4)), bevelPaint);

    // Head Main Ceramic Clay Surface
    final headPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
      ).createShader(headRect.outerRect);
    canvas.drawRRect(headRect, headPaint);

    // 4. LED Visor Face Screen (Màn hình kính đen hiển thị khuôn mặt AI)
    final visorRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.55),
        width: w * 0.54,
        height: h * 0.38,
      ),
      Radius.circular(w * 0.16),
    );

    final visorPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
      ).createShader(visorRect.outerRect);
    canvas.drawRRect(visorRect, visorPaint);

    // 5. Friendly AI Glowing Eyes (Đôi mắt LED AI sáng biểu cảm thông minh)
    final eyeY = h * 0.54;
    final eyeSpacing = w * 0.14;

    for (final eyeSign in [-1, 1]) {
      final eyeCenter = Offset(w * 0.50 + eyeSign * eyeSpacing, eyeY);

      if (isSelected) {
        // Glowing cyan eye halo
        final eyeGlow = Paint()
          ..color = const Color(0x8038BDF8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
        canvas.drawCircle(eyeCenter, w * 0.08, eyeGlow);
      }

      // Eye pill / circle
      final eyePaint = Paint()
        ..color = isSelected ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: eyeCenter, width: w * 0.11, height: h * 0.16),
          Radius.circular(w * 0.05),
        ),
        eyePaint,
      );

      // Eye sparkle reflection
      if (isSelected) {
        canvas.drawCircle(
          eyeCenter - Offset(w * 0.02, h * 0.03),
          w * 0.03,
          Paint()..color = Colors.white,
        );
      }
    }

    // 6. Mini Happy Smile Curve (Nụ cười AI thân thiện bên dưới mắt)
    if (isSelected) {
      final smilePaint = Paint()
        ..color = const Color(0xFF38BDF8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round;
      final smilePath = Path()
        ..moveTo(w * 0.44, h * 0.65)
        ..quadraticBezierTo(w * 0.50, h * 0.69, w * 0.56, h * 0.65);
      canvas.drawPath(smilePath, smilePaint);
    }

    // 7. Visor Specular Gloss Curve (Vệt phản quang tráng gương 3D trên kính)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: isSelected ? 0.75 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(w * 0.28, h * 0.44)
      ..quadraticBezierTo(w * 0.42, h * 0.40, w * 0.60, h * 0.42);
    canvas.drawPath(glossPath, glossPaint);

    // 8. Head Shell Top Highlight Rim
    final rimPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.32, h * 0.27),
      Offset(w * 0.68, h * 0.27),
      rimPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _Clay3DAstroBotPainter oldDelegate) =>
      oldDelegate.isSelected != isSelected;
}
