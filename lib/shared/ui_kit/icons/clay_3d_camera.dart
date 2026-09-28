import 'package:flutter/material.dart';

/// 3D Clay Food Scanner Camera Icon for the hero Camera FAB.
/// Chubby volumetric camera with sapphire lens, AI Vision green core,
/// tactile orange shutter button, and glossy specular reflection.
class Clay3DCamera extends StatelessWidget {
  const Clay3DCamera({
    super.key,
    this.size = 28.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: const _Clay3DCameraPainter(),
      ),
    );
  }
}

class _Clay3DCameraPainter extends CustomPainter {
  const _Clay3DCameraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Shutter Button on Top Shoulder (Nút bấm chụp màu cam nổi 3D)
    final shutterRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.68, h * 0.08, w * 0.18, h * 0.14),
      topLeft: const Radius.circular(2.5),
      topRight: const Radius.circular(2.5),
    );
    final shutterBevel = Paint()..color = const Color(0xFFC2410C);
    canvas.drawRRect(shutterRect.shift(const Offset(0, 0.8)), shutterBevel);

    final shutterPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFDBA74), Color(0xFFEA580C)],
      ).createShader(shutterRect.outerRect);
    canvas.drawRRect(shutterRect, shutterPaint);

    // 2. Camera Body Drop Shadow
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.18, w * 0.84, h * 0.72),
      Radius.circular(w * 0.22),
    );
    final shadowPaint = Paint()
      ..color = const Color(0x350284C7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    canvas.drawRRect(bodyRect.shift(const Offset(0, 2.2)), shadowPaint);

    // 3. Camera Body 3D Bottom Bevel
    final bevelPaint = Paint()
      ..color = const Color(0xFF0369A1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bodyRect.shift(const Offset(0, 1.6)), bevelPaint);

    // 4. Camera Body Main Gradient (Duolingo Sky Blue Clay)
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF38BDF8),
          Color(0xFF1CB0F6),
          Color(0xFF0284C7),
        ],
      ).createShader(bodyRect.outerRect);
    canvas.drawRRect(bodyRect, bodyPaint);

    // 5. Flash Reflector (Chấm đèn flash trên góc trái)
    final flashCenter = Offset(w * 0.26, h * 0.32);
    final flashRadius = w * 0.06;
    final flashBevel = Paint()..color = const Color(0xFF075985);
    canvas.drawCircle(flashCenter + const Offset(0, 0.8), flashRadius, flashBevel);

    final flashPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFFDE047)],
      ).createShader(Rect.fromCircle(center: flashCenter, radius: flashRadius));
    canvas.drawCircle(flashCenter, flashRadius, flashPaint);

    // 6. Camera Lens System (Hệ thấu kính 3D sapphire)
    final lensCenter = Offset(w * 0.52, h * 0.56);
    final outerLensRadius = w * 0.25;

    // 6a. Outer Lens Bezel (Vành kim loại tối)
    final outerLensBevel = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(lensCenter + const Offset(0, 1.2), outerLensRadius, outerLensBevel);

    final outerLensPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF334155), Color(0xFF0F172A)],
      ).createShader(Rect.fromCircle(center: lensCenter, radius: outerLensRadius));
    canvas.drawCircle(lensCenter, outerLensRadius, outerLensPaint);

    // 6b. Inner Sapphire Glass Element (Mặt kính sapphire)
    final innerLensRadius = outerLensRadius * 0.78;
    final glassPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        colors: [
          Color(0xFF1D4ED8),
          Color(0xFF1E3A8A),
          Color(0xFF0B192C),
        ],
      ).createShader(Rect.fromCircle(center: lensCenter, radius: innerLensRadius));
    canvas.drawCircle(lensCenter, innerLensRadius, glassPaint);

    // 6c. AI Vision Core (Chấm xanh ngọc mắt thần AI)
    final coreRadius = innerLensRadius * 0.36;
    final corePaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFF4ADE80),
          Color(0xFF58CC02),
          Color(0xFF15803D),
        ],
      ).createShader(Rect.fromCircle(center: lensCenter, radius: coreRadius));
    canvas.drawCircle(lensCenter, coreRadius, corePaint);

    // 6d. Center Pupil Sparkle
    canvas.drawCircle(
      lensCenter - Offset(coreRadius * 0.3, coreRadius * 0.3),
      coreRadius * 0.35,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // 6e. Specular Gloss Arc on Outer Lens (Vệt sáng phản chiếu cong 3D)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;

    final glossPath = Path()
      ..moveTo(lensCenter.dx - innerLensRadius * 0.65, lensCenter.dy - innerLensRadius * 0.25)
      ..quadraticBezierTo(
        lensCenter.dx - innerLensRadius * 0.55,
        lensCenter.dy - innerLensRadius * 0.70,
        lensCenter.dx,
        lensCenter.dy - innerLensRadius * 0.75,
      );
    canvas.drawPath(glossPath, glossPaint);

    // 7. Top Body Specular Rim (Đường viền bóng trên thân máy ảnh)
    final rimPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.22, h * 0.22),
      Offset(w * 0.80, h * 0.22),
      rimPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _Clay3DCameraPainter oldDelegate) => false;
}
