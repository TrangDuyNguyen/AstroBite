import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Enum specifying the 3D clay-sculpted food or fruit item to render.
enum Clay3DFoodType {
  apple,
  avocado,
  croissant,
  pizza,
  iceCream,
  sunnyEgg,
  cookie,
  ramen,
  coffee,
  cosmicStar,
}

/// A tactile, custom-drawn 3D claymorphic food/fruit illustration widget.
/// 
/// Instead of flat font icons, this widget paints high-fidelity, volumetric,
/// toy-like 3D clay food elements complete with radial gradient shading,
/// bottom clay bevels, multi-component clay parts, and glossy specular highlights.
class Clay3DFoodArt extends StatelessWidget {
  const Clay3DFoodArt({
    super.key,
    required this.foodType,
    this.size = 28,
  });

  final Clay3DFoodType foodType;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DFoodPainter(foodType: foodType),
      ),
    );
  }
}

class _Clay3DFoodPainter extends CustomPainter {
  const _Clay3DFoodPainter({required this.foodType});

  final Clay3DFoodType foodType;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (foodType) {
      case Clay3DFoodType.apple:
        _drawApple(canvas, w, h);
        break;
      case Clay3DFoodType.avocado:
        _drawAvocado(canvas, w, h);
        break;
      case Clay3DFoodType.croissant:
        _drawCroissant(canvas, w, h);
        break;
      case Clay3DFoodType.pizza:
        _drawPizza(canvas, w, h);
        break;
      case Clay3DFoodType.iceCream:
        _drawIceCream(canvas, w, h);
        break;
      case Clay3DFoodType.sunnyEgg:
        _drawSunnyEgg(canvas, w, h);
        break;
      case Clay3DFoodType.cookie:
        _drawCookie(canvas, w, h);
        break;
      case Clay3DFoodType.ramen:
        _drawRamen(canvas, w, h);
        break;
      case Clay3DFoodType.coffee:
        _drawCoffee(canvas, w, h);
        break;
      case Clay3DFoodType.cosmicStar:
        _drawCosmicStar(canvas, w, h);
        break;
    }
  }

  // ==========================================
  // 1. 🍎 3D CLAY CRUNCHY APPLE
  // ==========================================
  void _drawApple(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.55;
    final r = w * 0.36;

    // Stem (cuống nâu cong nổi khối)
    final stemPath = Path()
      ..moveTo(cx, cy - r * 0.85)
      ..quadraticBezierTo(cx + w * 0.08, cy - r * 1.35, cx + w * 0.04, cy - r * 1.55);
    final stemPaint = Paint()
      ..color = const Color(0xFF6A3810)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(stemPath, stemPaint);

    // Leaf (lá xanh dập nổi)
    final leafPath = Path()
      ..moveTo(cx + w * 0.04, cy - r * 1.1)
      ..quadraticBezierTo(cx + w * 0.35, cy - r * 1.35, cx + w * 0.32, cy - r * 0.85)
      ..quadraticBezierTo(cx + w * 0.15, cy - r * 0.85, cx + w * 0.04, cy - r * 1.1);
    final leafPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF58CC02), Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(cx, cy - r * 1.4, w * 0.35, h * 0.35));
    canvas.drawPath(leafPath, leafPaint);

    // 3D Apple Body Path (hai má bầu bĩnh, vết lõm trên và dưới)
    final bodyPath = Path()
      ..moveTo(cx, cy - r * 0.7)
      ..cubicTo(cx - r * 0.7, cy - r * 1.1, cx - r * 1.15, cy - r * 0.2, cx - r * 1.05, cy + r * 0.35)
      ..cubicTo(cx - r * 0.95, cy + r * 0.95, cx - r * 0.45, cy + r * 1.05, cx, cy + r * 0.78)
      ..cubicTo(cx + r * 0.45, cy + r * 1.05, cx + r * 0.95, cy + r * 0.95, cx + r * 1.05, cy + r * 0.35)
      ..cubicTo(cx + r * 1.15, cy - r * 0.2, cx + r * 0.7, cy - r * 1.1, cx, cy - r * 0.7)
      ..close();

    // Layer 1: Solid Bevel Shadow (Chân vát đáy đất sét)
    final bevelPaint = Paint()..color = const Color(0xFF9E0B2B);
    canvas.save();
    canvas.translate(0, h * 0.06);
    canvas.drawPath(bodyPath, bevelPaint);
    canvas.restore();

    // Layer 2: Main Clay Body with 3D Radial Shading
    final applePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.4),
        radius: 0.85,
        colors: const [
          Color(0xFFFF5C7A), // Highlight má trên
          Color(0xFFE51A4B), // Thân chính đỏ mọng
          Color(0xFFB50831), // Vát bóng đáy
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 1.2));
    canvas.drawPath(bodyPath, applePaint);

    // Layer 3: Glossy Specular Sheen (Vệt sáng bóng đất sét má trái)
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;
    final glossPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(cx - r * 0.48, cy - r * 0.32),
        width: r * 0.38,
        height: r * 0.22,
      ));
    canvas.save();
    canvas.rotate(-0.35);
    canvas.drawPath(glossPath, glossPaint);
    canvas.restore();

    // Dot specular highlight
    canvas.drawCircle(
      Offset(cx - r * 0.22, cy - r * 0.52),
      r * 0.09,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  // ==========================================
  // 2. 🥑 3D CLAY CREAMY AVOCADO
  // ==========================================
  void _drawAvocado(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    // Avocado contour path (hình quả lê tròn đáy)
    final avoPath = Path()
      ..moveTo(cx, h * 0.12)
      ..cubicTo(cx - w * 0.25, h * 0.12, cx - w * 0.26, h * 0.36, cx - w * 0.42, h * 0.58)
      ..cubicTo(cx - w * 0.48, h * 0.78, cx - w * 0.3, h * 0.92, cx, h * 0.92)
      ..cubicTo(cx + w * 0.3, h * 0.92, cx + w * 0.48, h * 0.78, cx + w * 0.42, h * 0.58)
      ..cubicTo(cx + w * 0.26, h * 0.36, cx + w * 0.25, h * 0.12, cx, h * 0.12)
      ..close();

    // Bevel bottom shadow
    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(avoPath, Paint()..color = const Color(0xFF1E4620));
    canvas.restore();

    // Dark forest green rind (vỏ xanh đậm)
    canvas.drawPath(
      avoPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF386641), Color(0xFF244829)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Inner Creamy Flesh (Thịt bơ vàng xanh béo ngậy)
    final fleshPath = Path()
      ..moveTo(cx, h * 0.19)
      ..cubicTo(cx - w * 0.19, h * 0.19, cx - w * 0.20, h * 0.38, cx - w * 0.33, h * 0.58)
      ..cubicTo(cx - w * 0.38, h * 0.74, cx - w * 0.24, h * 0.85, cx, h * 0.85)
      ..cubicTo(cx + w * 0.24, h * 0.85, cx + w * 0.38, h * 0.74, cx + w * 0.33, h * 0.58)
      ..cubicTo(cx + w * 0.20, h * 0.38, cx + w * 0.19, h * 0.19, cx, h * 0.19)
      ..close();
    canvas.drawPath(
      fleshPath,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, 0.4),
          radius: 0.7,
          colors: [Color(0xFFF1FAEE), Color(0xFFC7E6A8), Color(0xFFA7C957)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Big 3D Round Seed (Hạt bơ tròn nổi khối)
    final pitCenter = Offset(cx, h * 0.65);
    final pitR = w * 0.18;

    // Pit drop shadow onto flesh
    canvas.drawCircle(
      pitCenter + const Offset(0, 2),
      pitR,
      Paint()..color = const Color(0x33000000),
    );

    // 3D Seed gradient
    canvas.drawCircle(
      pitCenter,
      pitR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.8,
          colors: const [Color(0xFFB06836), Color(0xFF7A3E1D), Color(0xFF4A200B)],
        ).createShader(Rect.fromCircle(center: pitCenter, radius: pitR)),
    );

    // Pit Specular Highlight
    canvas.drawCircle(
      pitCenter + Offset(-pitR * 0.35, -pitR * 0.35),
      pitR * 0.25,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
  }

  // ==========================================
  // 3. 🥐 3D CLAY BUTTER CROISSANT
  // ==========================================
  void _drawCroissant(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.52;

    // Curved crescent pastry segments
    final crescentPath = Path()
      ..moveTo(cx - w * 0.42, cy + h * 0.18)
      ..cubicTo(cx - w * 0.44, cy - h * 0.08, cx - w * 0.18, cy - h * 0.36, cx, cy - h * 0.36)
      ..cubicTo(cx + w * 0.18, cy - h * 0.36, cx + w * 0.44, cy - h * 0.08, cx + w * 0.42, cy + h * 0.18)
      ..cubicTo(cx + w * 0.32, cy + h * 0.10, cx + w * 0.22, cy - h * 0.08, cx, cy - h * 0.08)
      ..cubicTo(cx - w * 0.22, cy - h * 0.08, cx - w * 0.32, cy + h * 0.10, cx - w * 0.42, cy + h * 0.18)
      ..close();

    // Bevel bottom shadow
    canvas.save();
    canvas.translate(0, h * 0.06);
    canvas.drawPath(crescentPath, Paint()..color = const Color(0xFF8B4513));
    canvas.restore();

    // Main Golden Baked Pastry
    canvas.drawPath(
      crescentPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD166), Color(0xFFE08D3C), Color(0xFFA55416)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // 3 Rolled Clay Segments (Các ngấn bột cuộn)
    final ribPaint = Paint()
      ..color = const Color(0xFF7A3508)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(cx - w * 0.14, cy - h * 0.32),
      Offset(cx - w * 0.08, cy - h * 0.08),
      ribPaint,
    );
    canvas.drawLine(
      Offset(cx + w * 0.14, cy - h * 0.32),
      Offset(cx + w * 0.08, cy - h * 0.08),
      ribPaint,
    );

    // Golden butter gloss highlight
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.22), width: w * 0.24, height: h * 0.14),
      -math.pi * 0.8,
      math.pi * 0.6,
      false,
      glossPaint,
    );
  }

  // ==========================================
  // 4. 🍕 3D CLAY CHEESY PIZZA SLICE
  // ==========================================
  void _drawPizza(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    // Pizza slice triangle with molten cheese drips
    final slicePath = Path()
      ..moveTo(cx - w * 0.38, h * 0.25)
      ..quadraticBezierTo(cx, h * 0.18, cx + w * 0.38, h * 0.25)
      ..lineTo(cx + w * 0.06, h * 0.86)
      ..quadraticBezierTo(cx, h * 0.92, cx - w * 0.06, h * 0.86)
      ..close();

    // Bottom bevel
    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(slicePath, Paint()..color = const Color(0xFFB45309));
    canvas.restore();

    // Molten Cheddar Cheese Body
    canvas.drawPath(
      slicePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD000), Color(0xFFFF9E00)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Puffy Baked Crust at top
    final crustPath = Path()
      ..moveTo(cx - w * 0.40, h * 0.26)
      ..quadraticBezierTo(cx, h * 0.16, cx + w * 0.40, h * 0.26)
      ..quadraticBezierTo(cx, h * 0.22, cx - w * 0.40, h * 0.26)
      ..close();
    canvas.drawPath(
      crustPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFE09F3E), Color(0xFF9E5A18)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // 3D Pepperoni Discs
    void drawPepperoni(Offset center, double r) {
      canvas.drawCircle(center + const Offset(0, 1), r, Paint()..color = const Color(0xFF7F1D1D));
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: const [Color(0xFFEF4444), Color(0xFFB91C1C)],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );
      // Shine spot
      canvas.drawCircle(center + Offset(-r * 0.3, -r * 0.3), r * 0.25, Paint()..color = Colors.white.withValues(alpha: 0.7));
    }

    drawPepperoni(Offset(cx - w * 0.12, h * 0.40), w * 0.09);
    drawPepperoni(Offset(cx + w * 0.14, h * 0.48), w * 0.08);
    drawPepperoni(Offset(cx - w * 0.04, h * 0.65), w * 0.075);
  }

  // ==========================================
  // 5. 🍦 3D CLAY SOFT SWIRL ICE CREAM
  // ==========================================
  void _drawIceCream(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    // 1. Waffle Cone
    final conePath = Path()
      ..moveTo(cx - w * 0.26, h * 0.50)
      ..lineTo(cx + w * 0.26, h * 0.50)
      ..lineTo(cx, h * 0.92)
      ..close();

    // Cone bevel & gradient
    canvas.save();
    canvas.translate(0, h * 0.04);
    canvas.drawPath(conePath, Paint()..color = const Color(0xFF8B5A2B));
    canvas.restore();

    canvas.drawPath(
      conePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8B67B), Color(0xFFB87834)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Cross-hatch waffle grid
    final gridPaint = Paint()
      ..color = const Color(0xFF7A4817).withValues(alpha: 0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(cx - w * 0.18, h * 0.56), Offset(cx + w * 0.08, h * 0.78), gridPaint);
    canvas.drawLine(Offset(cx + w * 0.18, h * 0.56), Offset(cx - w * 0.08, h * 0.78), gridPaint);

    // 2. Multi-tier Clay Cream Swirl (2 tầng phồng + ngọn xoắn)
    void drawSwirlTier(double cy, double width, double height, Color c1, Color c2) {
      final rect = Rect.fromCenter(center: Offset(cx, cy), width: width, height: height);
      final p = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(height * 0.5)));
      // tier shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.shift(const Offset(0, 1.5)), Radius.circular(height * 0.5)),
        Paint()..color = c2.withValues(alpha: 0.4),
      );
      canvas.drawPath(
        p,
        Paint()
          ..shader = LinearGradient(
            colors: [c1, c2],
          ).createShader(rect),
      );
      // Gloss arc
      canvas.drawCircle(
        Offset(cx - width * 0.3, cy - height * 0.15),
        height * 0.2,
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
    }

    // Bottom swirl: Duolingo Sky Blue
    drawSwirlTier(h * 0.47, w * 0.62, h * 0.20, const Color(0xFF70D6FF), const Color(0xFF0096C7));
    // Mid swirl: Strawberry Milk Pink
    drawSwirlTier(h * 0.33, w * 0.50, h * 0.18, const Color(0xFFFF99C8), const Color(0xFFFF5C8D));

    // Top spiral tip (Đỉnh xoắn ngộ nghĩnh)
    final tipPath = Path()
      ..moveTo(cx - w * 0.16, h * 0.27)
      ..quadraticBezierTo(cx - w * 0.05, h * 0.10, cx + w * 0.08, h * 0.12)
      ..quadraticBezierTo(cx + w * 0.18, h * 0.16, cx + w * 0.12, h * 0.27)
      ..close();
    canvas.drawPath(
      tipPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFE5F6FD), Color(0xFF70D6FF)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
  }

  // ==========================================
  // 6. 🍳 3D CLAY SUNNY-SIDE UP EGG
  // ==========================================
  void _drawSunnyEgg(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.52;

    // Organic wavy egg white path (lòng trắng uốn lượn tự nhiên)
    final whitePath = Path()
      ..moveTo(cx - w * 0.35, cy - h * 0.22)
      ..cubicTo(cx - w * 0.45, cy - h * 0.05, cx - w * 0.42, cy + h * 0.28, cx - w * 0.15, cy + h * 0.38)
      ..cubicTo(cx + w * 0.12, cy + h * 0.44, cx + w * 0.40, cy + h * 0.32, cx + w * 0.42, cy + h * 0.08)
      ..cubicTo(cx + w * 0.44, cy - h * 0.18, cx + w * 0.22, cy - h * 0.38, cx, cy - h * 0.35)
      ..cubicTo(cx - w * 0.18, cy - h * 0.32, cx - w * 0.25, cy - h * 0.30, cx - w * 0.35, cy - h * 0.22)
      ..close();

    // 3D bottom bevel
    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(whitePath, Paint()..color = const Color(0xFFD1D5DB));
    canvas.restore();

    // Egg white surface
    canvas.drawPath(
      whitePath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF3F4F6)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Golden Spherical Yolk Dome (Lòng đỏ cam óng ánh nổi vồng)
    final yolkCenter = Offset(cx, cy + h * 0.02);
    final yolkR = w * 0.22;

    // Yolk drop shadow
    canvas.drawCircle(yolkCenter + const Offset(0, 2), yolkR, Paint()..color = const Color(0x28000000));

    // Yolk 3D gradient
    canvas.drawCircle(
      yolkCenter,
      yolkR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.85,
          colors: const [Color(0xFFFFDD00), Color(0xFFFF9500), Color(0xFFE85D04)],
        ).createShader(Rect.fromCircle(center: yolkCenter, radius: yolkR)),
    );

    // Yolk Specular Highlight spot
    canvas.drawCircle(
      yolkCenter + Offset(-yolkR * 0.35, -yolkR * 0.35),
      yolkR * 0.26,
      Paint()..color = Colors.white.withValues(alpha: 0.88),
    );
  }

  // ==========================================
  // 7. 🍪 3D CLAY CHOCOLATE COOKIE
  // ==========================================
  void _drawCookie(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.5;
    final r = w * 0.38;

    // Cookie base with bevel
    canvas.drawCircle(Offset(cx, cy + h * 0.06), r, Paint()..color = const Color(0xFF8B4B0C));

    // Baked biscuit dough
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: const [Color(0xFFE29547), Color(0xFFB86B1E), Color(0xFF944B0C)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );

    // 3D Chocolate Morsels (Hạt chocolate sẫm dập chìm)
    void drawChip(Offset c, double cr) {
      canvas.drawCircle(c + const Offset(0, 1), cr, Paint()..color = const Color(0xFF1E0E06));
      canvas.drawCircle(
        c,
        cr,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.2, -0.2),
            colors: const [Color(0xFF4A2810), Color(0xFF2B1408)],
          ).createShader(Rect.fromCircle(center: c, radius: cr)),
      );
      canvas.drawCircle(c + Offset(-cr * 0.25, -cr * 0.25), cr * 0.25, Paint()..color = Colors.white.withValues(alpha: 0.6));
    }

    drawChip(Offset(cx - r * 0.45, cy - r * 0.35), w * 0.08);
    drawChip(Offset(cx + r * 0.38, cy - r * 0.25), w * 0.075);
    drawChip(Offset(cx - r * 0.15, cy + r * 0.15), w * 0.09);
    drawChip(Offset(cx + r * 0.42, cy + r * 0.35), w * 0.08);
    drawChip(Offset(cx - r * 0.42, cy + r * 0.45), w * 0.07);
  }

  // ==========================================
  // 8. 🍜 3D CLAY STEAMING RAMEN BOWL
  // ==========================================
  void _drawRamen(Canvas canvas, double w, double h) {
    final cx = w * 0.5;

    // Steam wisps (làn khói thơm bốc lên)
    final steamPaint = Paint()
      ..color = const Color(0xFF9D65FF).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final steam1 = Path()
      ..moveTo(cx - w * 0.14, h * 0.28)
      ..cubicTo(cx - w * 0.20, h * 0.20, cx - w * 0.08, h * 0.14, cx - w * 0.12, h * 0.08);
    final steam2 = Path()
      ..moveTo(cx + w * 0.12, h * 0.28)
      ..cubicTo(cx + w * 0.06, h * 0.20, cx + w * 0.18, h * 0.14, cx + w * 0.14, h * 0.08);
    canvas.drawPath(steam1, steamPaint);
    canvas.drawPath(steam2, steamPaint);

    // Ceramic Bowl (Bát sứ bo tròn)
    final bowlPath = Path()
      ..moveTo(cx - w * 0.38, h * 0.42)
      ..lineTo(cx + w * 0.38, h * 0.42)
      ..cubicTo(cx + w * 0.36, h * 0.78, cx + w * 0.20, h * 0.88, cx, h * 0.88)
      ..cubicTo(cx - w * 0.20, h * 0.88, cx - w * 0.36, h * 0.78, cx - w * 0.38, h * 0.42)
      ..close();

    // Bowl bevel
    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawPath(bowlPath, Paint()..color = const Color(0xFF6B21A8));
    canvas.restore();

    // Bowl Body
    canvas.drawPath(
      bowlPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF3E8FF), Color(0xFFC084FC), Color(0xFF9333EA)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Soup surface & curly noodles
    final soupRect = Rect.fromCenter(center: Offset(cx, h * 0.42), width: w * 0.72, height: h * 0.18);
    canvas.drawOval(
      soupRect,
      Paint()..color = const Color(0xFFD97706),
    );

    // Boiled egg half in soup
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.14, h * 0.42), width: w * 0.20, height: h * 0.12),
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(cx - w * 0.14, h * 0.42),
      w * 0.05,
      Paint()..color = const Color(0xFFF59E0B),
    );

    // Chopsticks (Đôi đũa gỗ gác ngang)
    final chopPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.10, h * 0.48), Offset(cx + w * 0.42, h * 0.32), chopPaint);
    canvas.drawLine(Offset(cx - w * 0.08, h * 0.52), Offset(cx + w * 0.44, h * 0.36), chopPaint);
  }

  // ==========================================
  // 9. ☕ 3D CLAY HOT COFFEE MUG
  // ==========================================
  void _drawCoffee(Canvas canvas, double w, double h) {
    final cx = w * 0.46;

    // Steam wisps
    final steamPaint = Paint()
      ..color = const Color(0xFF8D5B4C).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final steam = Path()
      ..moveTo(cx, h * 0.28)
      ..cubicTo(cx - w * 0.08, h * 0.20, cx + w * 0.08, h * 0.14, cx, h * 0.08);
    canvas.drawPath(steam, steamPaint);

    // Mug Handle (Quai cốc tròn)
    final handlePaint = Paint()
      ..color = const Color(0xFF8D5B4C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + w * 0.32, h * 0.58), width: w * 0.26, height: h * 0.32),
      -math.pi * 0.5,
      math.pi,
      false,
      handlePaint,
    );

    // Mug Body (Thân cốc gốm đất nung)
    final mugRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(cx - w * 0.30, h * 0.40, w * 0.58, h * 0.44),
      bottomLeft: Radius.circular(w * 0.16),
      bottomRight: Radius.circular(w * 0.16),
    );

    // Bevel
    canvas.save();
    canvas.translate(0, h * 0.05);
    canvas.drawRRect(mugRect, Paint()..color = const Color(0xFF5C382E));
    canvas.restore();

    canvas.drawRRect(
      mugRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE2C9BE), Color(0xFF8D5B4C)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Dark rich coffee surface with latte crema dot
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.01, h * 0.40), width: w * 0.56, height: h * 0.14),
      Paint()..color = const Color(0xFF381E14),
    );
    canvas.drawCircle(
      Offset(cx - w * 0.01, h * 0.40),
      w * 0.06,
      Paint()..color = const Color(0xFFEED7C5),
    );
  }

  // ==========================================
  // 10. ✨ 3D CLAY COSMIC SPARKLE STAR
  // ==========================================
  void _drawCosmicStar(Canvas canvas, double w, double h) {
    final cx = w * 0.5;
    final cy = h * 0.5;
    final outerR = w * 0.44;
    final innerR = w * 0.18;

    // 4-pointed chubby star path
    Path createStarPath(double offsetDown) {
      final path = Path();
      for (int i = 0; i < 8; i++) {
        final angle = (i * math.pi / 4) - math.pi / 2;
        final r = (i % 2 == 0) ? outerR : innerR;
        final x = cx + r * math.cos(angle);
        final y = cy + offsetDown + r * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      return path;
    }

    // 3D bottom bevel
    canvas.drawPath(createStarPath(h * 0.06), Paint()..color = const Color(0xFFB45309));

    // Radiant Gold Clay Star Body
    canvas.drawPath(
      createStarPath(0),
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.25, -0.25),
          radius: 0.85,
          colors: const [Color(0xFFFFF07C), Color(0xFFFFD166), Color(0xFFF59E0B)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: outerR)),
    );

    // Specular star shine center
    canvas.drawCircle(
      Offset(cx - w * 0.06, cy - h * 0.06),
      w * 0.11,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
  }

  @override
  bool shouldRepaint(covariant _Clay3DFoodPainter oldDelegate) {
    return oldDelegate.foodType != foodType;
  }
}
