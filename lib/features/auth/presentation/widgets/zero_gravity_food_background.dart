import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'clay_3d_food_art.dart';

export 'clay_3d_food_art.dart';

/// Specification for an individual 3D clay food/fruit item floating directly in zero gravity.
class _ClayFoodItemSpec {
  const _ClayFoodItemSpec({
    required this.foodType,
    required this.auraColor,
    required this.size,
    required this.relativeX,
    required this.relativeY,
    required this.amplitudeY,
    required this.amplitudeX,
    required this.speed,
    required this.phase,
    required this.maxRotation,
    this.opacity = 0.95,
  });

  final Clay3DFoodType foodType;
  final Color auraColor;
  final double size;
  final double relativeX;
  final double relativeY;
  final double amplitudeY;
  final double amplitudeX;
  final double speed;
  final double phase;
  final double maxRotation;
  final double opacity;
}

/// Zero-gravity floating cosmic background for authentication screens.
/// Features standalone puffy 3D clay food & fruit sculptures gently drifting through a celestial galaxy,
/// accompanied by twinkling cosmic stardust and soft atmospheric nebula glows.
class ZeroGravityFoodBackground extends StatefulWidget {
  const ZeroGravityFoodBackground({super.key});

  @override
  State<ZeroGravityFoodBackground> createState() => _ZeroGravityFoodBackgroundState();
}

class _ZeroGravityFoodBackgroundState extends State<ZeroGravityFoodBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<_ClayFoodItemSpec> _specs = [
    // 1. 🍎 Red Apple (Trái táo giòn 3D) - Top Left Constellation
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.apple,
      auraColor: Color(0x35FF5C8D),
      size: 46,
      relativeX: 0.12,
      relativeY: 0.10,
      amplitudeY: 14,
      amplitudeX: 9,
      speed: 1.0,
      phase: 0.0,
      maxRotation: 0.18,
    ),

    // 2. ✨ Cosmic Sparkle Star (Bụi sao dinh dưỡng 3D) - Top Center-Left
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.cosmicStar,
      auraColor: Color(0x45FFB703),
      size: 30,
      relativeX: 0.32,
      relativeY: 0.065,
      amplitudeY: 10,
      amplitudeX: 6,
      speed: 1.25,
      phase: 1.8,
      maxRotation: 0.35,
      opacity: 0.90,
    ),

    // 3. 🍪 Chocolate Cookie (Bánh quy sô-cô-la 3D) - Top Center-Right (clear of notch)
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.cookie,
      auraColor: Color(0x30D47A3B),
      size: 38,
      relativeX: 0.68,
      relativeY: 0.075,
      amplitudeY: 11,
      amplitudeX: 10,
      speed: 0.85,
      phase: 0.8,
      maxRotation: 0.22,
    ),

    // 4. 🥐 Croissant / Bread (Bánh sừng bò nướng 3D) - Top Right Constellation
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.croissant,
      auraColor: Color(0x35FFAA00),
      size: 46,
      relativeX: 0.86,
      relativeY: 0.11,
      amplitudeY: 13,
      amplitudeX: 10,
      speed: 0.92,
      phase: 1.2,
      maxRotation: 0.22,
    ),

    // 5. 🥑 Avocado / Fresh Veggie (Trái bơ sáp 3D) - Upper-Mid Left (flanking card)
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.avocado,
      auraColor: Color(0x3558CC02),
      size: 44,
      relativeX: 0.07,
      relativeY: 0.26,
      amplitudeY: 15,
      amplitudeX: 8,
      speed: 0.88,
      phase: 2.1,
      maxRotation: -0.20,
    ),

    // 6. 🍕 Pizza Slice (Mảnh pizza phô mai 3D) - Upper-Mid Right (flanking card)
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.pizza,
      auraColor: Color(0x35FF9600),
      size: 48,
      relativeX: 0.93,
      relativeY: 0.28,
      amplitudeY: 14,
      amplitudeX: 8,
      speed: 1.05,
      phase: 3.5,
      maxRotation: -0.18,
    ),

    // 7. 🍦 Ice Cream (Kem xoắn mát lạnh 3D) - Lower-Mid Left
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.iceCream,
      auraColor: Color(0x351CB0F6),
      size: 44,
      relativeX: 0.07,
      relativeY: 0.70,
      amplitudeY: 12,
      amplitudeX: 9,
      speed: 0.90,
      phase: 4.3,
      maxRotation: 0.16,
    ),

    // 8. 🍳 Sunny Egg (Trứng ốp la 3D) - Lower-Mid Right
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.sunnyEgg,
      auraColor: Color(0x40FFD000),
      size: 44,
      relativeX: 0.93,
      relativeY: 0.68,
      amplitudeY: 15,
      amplitudeX: 7,
      speed: 1.02,
      phase: 5.1,
      maxRotation: -0.15,
    ),

    // 9. 🍜 Ramen Bowl (Tô mì súp nóng 3D) - Bottom Left Constellation
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.ramen,
      auraColor: Color(0x359D65FF),
      size: 44,
      relativeX: 0.20,
      relativeY: 0.88,
      amplitudeY: 12,
      amplitudeX: 8,
      speed: 0.95,
      phase: 2.7,
      maxRotation: 0.16,
    ),

    // 10. ☕ Hot Coffee (Ly cà phê nạp năng lượng 3D) - Bottom Right Constellation
    _ClayFoodItemSpec(
      foodType: Clay3DFoodType.coffee,
      auraColor: Color(0x308D5B4C),
      size: 38,
      relativeX: 0.80,
      relativeY: 0.88,
      amplitudeY: 11,
      amplitudeX: 8,
      speed: 0.82,
      phase: 3.9,
      maxRotation: -0.16,
    ),
  ];

  late final List<Widget> _cachedFoodItems;

  @override
  void initState() {
    super.initState();
    _cachedFoodItems = _specs.map((spec) => _FloatingClayFoodItem(spec: spec)).toList();

    // Slow, majestic 18s orbital drift tempo
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    final shouldAnimate = !disableAnimations && !isTest;

    return IgnorePointer(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            if (!shouldAnimate) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Static cosmic stardust
                  CustomPaint(
                    size: Size(w, h),
                    painter: const CosmicStardustPainter(progress: 0.2),
                  ),
                  // Static resting food items
                  ...List.generate(_specs.length, (i) {
                    final spec = _specs[i];
                    final x = spec.relativeX * w - spec.size / 2;
                    final y = spec.relativeY * h - spec.size / 2;

                    return Positioned(
                      left: x,
                      top: y,
                      child: Opacity(
                        opacity: spec.opacity,
                        child: _cachedFoodItems[i],
                      ),
                    );
                  }),
                ],
              );
            }

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final progress = _controller.value;
                final twoPi = 2 * math.pi;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Twinkling cosmic stardust starfield
                    CustomPaint(
                      size: Size(w, h),
                      painter: CosmicStardustPainter(progress: progress),
                    ),
                    // Floating 3D zero-gravity food sculptures
                    ...List.generate(_specs.length, (i) {
                      final spec = _specs[i];
                      final angle = progress * twoPi * spec.speed + spec.phase;

                      // Weightless orbital drifting physics (Lissajous curves)
                      final dy = math.sin(angle) * spec.amplitudeY;
                      final dx = math.cos(angle * 0.75 + spec.phase) * spec.amplitudeX;
                      final rot = math.sin(angle * 0.85 + spec.phase) * spec.maxRotation;
                      final scale = 1.0 + math.sin(angle * 0.5 + spec.phase) * 0.04;

                      final x = spec.relativeX * w - spec.size / 2 + dx;
                      final y = spec.relativeY * h - spec.size / 2 + dy;

                      return Positioned(
                        left: x,
                        top: y,
                        child: Opacity(
                          opacity: spec.opacity,
                          child: Transform.rotate(
                            angle: rot,
                            child: Transform.scale(
                              scale: scale,
                              child: _cachedFoodItems[i],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Standalone 3D clay food & fruit item floating in zero gravity,
/// with an ethereal celestial nebula aura glowing softly beneath it.
class _FloatingClayFoodItem extends StatelessWidget {
  const _FloatingClayFoodItem({required this.spec});

  final _ClayFoodItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft Celestial Nebula Aura Glow (Hào quang vũ trụ tỏa nhẹ dưới vật thể)
        Container(
          width: spec.size * 0.90,
          height: spec.size * 0.90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: spec.auraColor,
                blurRadius: spec.size * 0.45,
                spreadRadius: 2.0,
              ),
            ],
          ),
        ),
        // 3D Sculpted Clay Food Item
        Clay3DFoodArt(
          foodType: spec.foodType,
          size: spec.size,
        ),
      ],
    );
  }
}

/// Paints twinkling cosmic stardust and micro-stars drifting across the cosmos.
class CosmicStardustPainter extends CustomPainter {
  const CosmicStardustPainter({required this.progress});

  final double progress;

  // Normalized (x, y, radius, color, seed)
  static const List<(double, double, double, Color, double)> _stars = [
    (0.24, 0.19, 2.5, Color(0xFFF59E0B), 0.1), // Golden micro-star
    (0.78, 0.20, 2.2, Color(0xFF1CB0F6), 0.7), // Sky blue stardust
    (0.48, 0.04, 2.8, Color(0xFFF59E0B), 1.3), // Top gold star
    (0.04, 0.48, 2.0, Color(0xFFFF5C8D), 2.2), // Pink stardust
    (0.96, 0.48, 2.4, Color(0xFF58CC02), 3.0), // Mint stardust
    (0.12, 0.82, 2.6, Color(0xFFF59E0B), 0.4), // Golden star
    (0.88, 0.82, 2.2, Color(0xFF9D65FF), 1.9), // Taro stardust
    (0.38, 0.84, 2.0, Color(0xFF1CB0F6), 2.5), // Sky stardust
    (0.64, 0.84, 2.2, Color(0xFFFF5C8D), 3.4), // Pink stardust
    (0.50, 0.93, 2.6, Color(0xFFF59E0B), 1.1), // Bottom star
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final twoPi = 2 * math.pi;

    for (final star in _stars) {
      final x = star.$1 * size.width;
      final y = star.$2 * size.height;
      final baseR = star.$3;
      final color = star.$4;
      final seed = star.$5;

      // Soft twinkle pulsing
      final pulse = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(progress * twoPi * 1.5 + seed));
      final currentR = baseR * (0.85 + 0.3 * pulse);

      final paint = Paint()
        ..color = color.withValues(alpha: pulse * 0.75)
        ..style = PaintingStyle.fill;

      // Draw 4-pointed micro diamond sparkle
      final path = Path()
        ..moveTo(x, y - currentR * 1.4)
        ..quadraticBezierTo(x, y, x + currentR * 1.4, y)
        ..quadraticBezierTo(x, y, x, y + currentR * 1.4)
        ..quadraticBezierTo(x, y, x - currentR * 1.4, y)
        ..quadraticBezierTo(x, y, x, y - currentR * 1.4)
        ..close();

      canvas.drawPath(path, paint);

      // Core white sparkle dot
      canvas.drawCircle(
        Offset(x, y),
        currentR * 0.4,
        Paint()..color = Colors.white.withValues(alpha: pulse * 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CosmicStardustPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

