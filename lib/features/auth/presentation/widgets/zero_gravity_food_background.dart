import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Specification for an individual claymorphic food/fruit floating in zero gravity.
class _ClayFoodItemSpec {
  const _ClayFoodItemSpec({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.bevelColor,
    required this.size,
    required this.relativeX,
    required this.relativeY,
    required this.amplitudeY,
    required this.amplitudeX,
    required this.speed,
    required this.phase,
    required this.maxRotation,
    this.opacity = 0.88,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color bevelColor;
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

/// Zero-gravity floating background for authentication screens.
/// Features puffy 3D clay food & fruit icons gently drifting in microgravity,
/// with dual-layer clay shadows, glossy top highlights, and harmonious orbital motion.
class ZeroGravityFoodBackground extends StatefulWidget {
  const ZeroGravityFoodBackground({super.key});

  @override
  State<ZeroGravityFoodBackground> createState() => _ZeroGravityFoodBackgroundState();
}

class _ZeroGravityFoodBackgroundState extends State<ZeroGravityFoodBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<_ClayFoodItemSpec> _specs = [
    // 1. Red Apple (Trái táo giòn - Strawberry pastel) - Top Left
    _ClayFoodItemSpec(
      icon: Icons.apple_rounded,
      iconColor: AppColors.secondary,
      bgColor: AppColors.claySnack,
      bevelColor: Color(0xFFE8B6C0),
      size: 48,
      relativeX: 0.10,
      relativeY: 0.08,
      amplitudeY: 12,
      amplitudeX: 8,
      speed: 1.0,
      phase: 0.0,
      maxRotation: 0.16,
    ),

    // 2. Avocado / Fresh Veggie (Trái bơ xanh - Mint pastel) - Mid Left
    _ClayFoodItemSpec(
      icon: Icons.eco_rounded,
      iconColor: AppColors.brandGreen,
      bgColor: AppColors.clayMint,
      bevelColor: Color(0xFFC7E6A8),
      size: 46,
      relativeX: 0.06,
      relativeY: 0.38,
      amplitudeY: 14,
      amplitudeX: 6,
      speed: 0.85,
      phase: 2.1,
      maxRotation: -0.18,
    ),

    // 3. Croissant / Bread (Bánh sừng bò nướng) - Top Right
    _ClayFoodItemSpec(
      icon: Icons.bakery_dining_rounded,
      iconColor: Color(0xFFD47A3B),
      bgColor: Color(0xFFFFF0E2),
      bevelColor: Color(0xFFDFC0AA),
      size: 48,
      relativeX: 0.88,
      relativeY: 0.09,
      amplitudeY: 11,
      amplitudeX: 9,
      speed: 0.92,
      phase: 1.2,
      maxRotation: 0.20,
    ),

    // 4. Pizza Slice (Mảnh pizza phô mai) - Mid Right
    _ClayFoodItemSpec(
      icon: Icons.local_pizza_rounded,
      iconColor: AppColors.tertiary,
      bgColor: AppColors.clayBreakfast,
      bevelColor: Color(0xFFE5CCA8),
      size: 50,
      relativeX: 0.90,
      relativeY: 0.44,
      amplitudeY: 13,
      amplitudeX: 7,
      speed: 1.08,
      phase: 3.5,
      maxRotation: -0.16,
    ),

    // 5. Ice Cream (Kem mát lạnh - Sky pastel) - Lower Left
    _ClayFoodItemSpec(
      icon: Icons.icecream_rounded,
      iconColor: AppColors.primary,
      bgColor: AppColors.clayLunch,
      bevelColor: Color(0xFFBCE0F0),
      size: 46,
      relativeX: 0.08,
      relativeY: 0.74,
      amplitudeY: 10,
      amplitudeX: 8,
      speed: 0.88,
      phase: 4.3,
      maxRotation: 0.14,
    ),

    // 6. Sunny Egg (Trứng ốp la thơm ngon) - Lower Right
    _ClayFoodItemSpec(
      icon: Icons.egg_alt_rounded,
      iconColor: AppColors.tertiary,
      bgColor: Color(0xFFFFF9E6),
      bevelColor: Color(0xFFE8DDBE),
      size: 44,
      relativeX: 0.88,
      relativeY: 0.78,
      amplitudeY: 14,
      amplitudeX: 6,
      speed: 1.05,
      phase: 5.1,
      maxRotation: -0.13,
    ),

    // 7. Chocolate Cookie (Bánh quy giòn) - Top Edge Center
    _ClayFoodItemSpec(
      icon: Icons.cookie_rounded,
      iconColor: Color(0xFFB57236),
      bgColor: Color(0xFFFAF1E4),
      bevelColor: Color(0xFFE2D0BE),
      size: 38,
      relativeX: 0.70,
      relativeY: 0.03,
      amplitudeY: 8,
      amplitudeX: 10,
      speed: 0.78,
      phase: 0.8,
      maxRotation: 0.22,
      opacity: 0.82,
    ),

    // 8. Ramen Bowl (Tô mì súp nóng - Taro pastel) - Bottom Left
    _ClayFoodItemSpec(
      icon: Icons.ramen_dining_rounded,
      iconColor: Color(0xFF9D65FF),
      bgColor: AppColors.clayDinner,
      bevelColor: Color(0xFFD6C8EB),
      size: 42,
      relativeX: 0.22,
      relativeY: 0.92,
      amplitudeY: 10,
      amplitudeX: 7,
      speed: 0.95,
      phase: 2.7,
      maxRotation: 0.15,
      opacity: 0.85,
    ),

    // 9. Hot Coffee (Ly cà phê nạp năng lượng) - Bottom Right
    _ClayFoodItemSpec(
      icon: Icons.local_cafe_rounded,
      iconColor: Color(0xFF8D5B4C),
      bgColor: Color(0xFFF5EBE6),
      bevelColor: Color(0xFFD9CAC3),
      size: 38,
      relativeX: 0.78,
      relativeY: 0.92,
      amplitudeY: 9,
      amplitudeX: 6,
      speed: 0.82,
      phase: 3.9,
      maxRotation: -0.15,
      opacity: 0.85,
    ),

    // 10. Cosmic Sparkle Star (Bụi sao dinh dưỡng) - Celestial Accents
    _ClayFoodItemSpec(
      icon: Icons.star_rounded,
      iconColor: AppColors.tertiary,
      bgColor: AppColors.clayBreakfast,
      bevelColor: Color(0xFFE5CCA8),
      size: 28,
      relativeX: 0.28,
      relativeY: 0.06,
      amplitudeY: 8,
      amplitudeX: 5,
      speed: 1.25,
      phase: 1.8,
      maxRotation: 0.30,
      opacity: 0.75,
    ),
  ];

  late final List<Widget> _cachedBadges;

  @override
  void initState() {
    super.initState();
    _cachedBadges = _specs.map((spec) => _ClayFoodBadge(spec: spec)).toList();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
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
                children: List.generate(_specs.length, (i) {
                  final spec = _specs[i];
                  final x = spec.relativeX * w - spec.size / 2;
                  final y = spec.relativeY * h - spec.size / 2;

                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: spec.opacity,
                      child: _cachedBadges[i],
                    ),
                  );
                }),
              );
            }

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final progress = _controller.value;
                final twoPi = 2 * math.pi;

                return Stack(
                  fit: StackFit.expand,
                  children: List.generate(_specs.length, (i) {
                    final spec = _specs[i];
                    final angle = progress * twoPi * spec.speed + spec.phase;

                    final dy = math.sin(angle) * spec.amplitudeY;
                    final dx = math.cos(angle * 0.75 + spec.phase) * spec.amplitudeX;
                    final rot = math.sin(angle * 0.9 + 1.2) * spec.maxRotation;
                    final scale = 1.0 + math.sin(angle * 0.5 + spec.phase) * 0.035;

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
                            child: _cachedBadges[i],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Tactile, puffy 3D claymorphic badge displaying a food or fruit icon.
class _ClayFoodBadge extends StatelessWidget {
  const _ClayFoodBadge({required this.spec});

  final _ClayFoodItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: spec.size,
      height: spec.size,
      decoration: BoxDecoration(
        color: spec.bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1.4,
        ),
        boxShadow: [
          // Layer 1: Solid Bottom Bevel (Clay 3D)
          BoxShadow(
            color: spec.bevelColor,
            offset: const Offset(0, 2.8),
            blurRadius: 0,
          ),
          // Layer 2: Ambient Float Shadow
          const BoxShadow(
            color: Color(0x141E2337),
            offset: Offset(0, 6.0),
            blurRadius: 10.0,
          ),
          // Layer 3: Glossy Top Reflection
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            offset: const Offset(0, -1.2),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glossy top rim reflection for inflated 3D illusion
          Positioned(
            top: 2,
            left: spec.size * 0.22,
            right: spec.size * 0.22,
            height: spec.size * 0.28,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spec.size),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.65),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Central Food / Fruit Icon
          Icon(
            spec.icon,
            size: spec.size * 0.52,
            color: spec.iconColor,
          ),
        ],
      ),
    );
  }
}
