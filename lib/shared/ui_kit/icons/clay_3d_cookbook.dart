import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// 3D Clay Recipe Book / Cookbook icon.
/// Handcrafted with volumetric clay cover, rounded spine, creamy paper edges,
/// ribbon bookmark, and glossy 3D specular highlight.
class Clay3DCookbook extends StatelessWidget {
  const Clay3DCookbook({
    super.key,
    this.size = 28.0,
    this.primaryColor,
    this.badgeColor,
  });

  final double size;
  final Color? primaryColor;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DCookbookPainter(
          primaryColor: primaryColor ?? AppColors.primary,
          badgeColor: badgeColor ?? AppColors.tertiary,
        ),
      ),
    );
  }
}

class _Clay3DCookbookPainter extends CustomPainter {
  const _Clay3DCookbookPainter({
    required this.primaryColor,
    required this.badgeColor,
  });

  final Color primaryColor;
  final Color badgeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Bottom 3D Drop Bevel Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x301E2337)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    final shadowRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.16 + 2.5, w * 0.76, h * 0.72),
      const Radius.circular(5.0),
    );
    canvas.drawRRect(shadowRRect, shadowPaint);

    // 2. Thick 3D Bottom Book Bevel
    final bevelPaint = Paint()
      ..color = Color.lerp(primaryColor, Colors.black, 0.35)!
      ..style = PaintingStyle.fill;
    final bevelRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.14, h * 0.16 + 2.0, w * 0.72, h * 0.70),
      const Radius.circular(5.0),
    );
    canvas.drawRRect(bevelRRect, bevelPaint);

    // 3. Layered Paper Pages Block (Trang sách kem sữa 3D)
    final pagePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFDF8), Color(0xFFF1ECE1)],
      ).createShader(Rect.fromLTWH(w * 0.20, h * 0.18, w * 0.64, h * 0.64));
    final pageRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.18, w * 0.64, h * 0.64),
      const Radius.circular(4.0),
    );
    canvas.drawRRect(pageRRect, pagePaint);

    // Subtle page crease lines
    final pageLinePaint = Paint()
      ..color = const Color(0xFFDDD5C7)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.82, h * 0.26),
      Offset(w * 0.82, h * 0.76),
      pageLinePaint,
    );

    // 4. Ribbon Bookmark hanging out the bottom (Dải ruy-băng hồng)
    final ribbonPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF85A6), Color(0xFFFF5C8D)],
      ).createShader(Rect.fromLTWH(w * 0.44, h * 0.50, w * 0.16, h * 0.38));
    final ribbonPath = Path()
      ..moveTo(w * 0.44, h * 0.50)
      ..lineTo(w * 0.58, h * 0.50)
      ..lineTo(w * 0.58, h * 0.88)
      ..lineTo(w * 0.51, h * 0.81) // V-notch cut
      ..lineTo(w * 0.44, h * 0.88)
      ..close();
    canvas.drawPath(ribbonPath, ribbonPaint);

    // 5. Hardcover Front (Bìa sách 3D đất sét Duolingo)
    final coverRect = Rect.fromLTWH(w * 0.14, h * 0.14, w * 0.68, h * 0.68);
    final coverPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(primaryColor, Colors.white, 0.22)!,
          primaryColor,
          Color.lerp(primaryColor, Colors.black, 0.15)!,
        ],
      ).createShader(coverRect);
    final coverRRect = RRect.fromRectAndRadius(
      coverRect,
      const Radius.circular(5.0),
    );
    canvas.drawRRect(coverRRect, coverPaint);

    // 6. Rounded Book Spine (Gáy sách 3D dày dặn bên trái)
    final spineRect = Rect.fromLTWH(w * 0.14, h * 0.14, w * 0.14, h * 0.68);
    final spinePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.lerp(primaryColor, Colors.black, 0.28)!,
          Color.lerp(primaryColor, Colors.white, 0.12)!,
          Color.lerp(primaryColor, Colors.black, 0.18)!,
        ],
      ).createShader(spineRect);
    final spineRRect = RRect.fromRectAndCorners(
      spineRect,
      topLeft: const Radius.circular(5.0),
      bottomLeft: const Radius.circular(5.0),
    );
    canvas.drawRRect(spineRRect, spinePaint);

    // 7. Embossed Golden Celestial Star on the cover (Huy hiệu ngôi sao nổi)
    final starCenter = Offset(w * 0.50, h * 0.46);
    final starR = w * 0.14;
    final starPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(badgeColor, Colors.white, 0.35)!,
          badgeColor,
        ],
      ).createShader(Rect.fromCircle(center: starCenter, radius: starR));

    final starPath = Path()
      ..moveTo(starCenter.dx, starCenter.dy - starR)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx + starR, starCenter.dy)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy + starR)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx - starR, starCenter.dy)
      ..quadraticBezierTo(starCenter.dx, starCenter.dy, starCenter.dx, starCenter.dy - starR)
      ..close();

    // Star bottom shadow
    canvas.drawPath(
      starPath.shift(const Offset(0, 1.0)),
      Paint()..color = const Color(0x35000000),
    );
    canvas.drawPath(starPath, starPaint);

    // 8. Glossy Specular Highlight (Ánh sáng bóng tròn 3D trên bìa)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;
    final glossRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.32, h * 0.18, w * 0.38, h * 0.08),
      const Radius.circular(3.0),
    );
    canvas.drawRRect(glossRRect, glossPaint);
  }

  @override
  bool shouldRepaint(covariant _Clay3DCookbookPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor || oldDelegate.badgeColor != badgeColor;
  }
}
