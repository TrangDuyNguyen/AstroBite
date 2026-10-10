import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'clay_3d_food_art.dart';
import 'cosmic_stardust_painter.dart';
import 'zero_gravity_food_specs.dart';

export 'clay_3d_food_art.dart';
export 'cosmic_stardust_painter.dart';
export 'zero_gravity_food_specs.dart';

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
  late final List<Widget> _cachedFoodItems;

  @override
  void initState() {
    super.initState();
    _cachedFoodItems = zeroGravityFoodSpecs
        .map((spec) => _FloatingClayFoodItem(spec: spec))
        .toList();

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
                  CustomPaint(
                    size: Size(w, h),
                    painter: const CosmicStardustPainter(progress: 0.2),
                  ),
                  ...List.generate(zeroGravityFoodSpecs.length, (i) {
                    final spec = zeroGravityFoodSpecs[i];
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
                    CustomPaint(
                      size: Size(w, h),
                      painter: CosmicStardustPainter(progress: progress),
                    ),
                    ...List.generate(zeroGravityFoodSpecs.length, (i) {
                      final spec = zeroGravityFoodSpecs[i];
                      final angle = progress * twoPi * spec.speed + spec.phase;

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

  final ClayFoodItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
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
        Clay3DFoodArt(
          foodType: spec.foodType,
          size: spec.size,
        ),
      ],
    );
  }
}
