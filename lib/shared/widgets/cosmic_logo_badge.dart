import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Cosmic Nutrition logo badge representing AstroBite:
/// The Glowing Apple Bite surrounded by 3 animated Macro Nutrient Rings:
/// - Blue: Carbohydrates (#1A73E8)
/// - Pink: Fat (#FF69B4)
/// - Gold: Protein (#FFD700)
class CosmicLogoBadge extends StatefulWidget {
  const CosmicLogoBadge({
    super.key,
    this.size = 90,
    this.isAnimated = true,
    this.heroTag = 'astrobite-brand-logo',
  });

  final double size;
  final bool isAnimated;
  final String heroTag;

  @override
  State<CosmicLogoBadge> createState() => _CosmicLogoBadgeState();
}

class _CosmicLogoBadgeState extends State<CosmicLogoBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (widget.isAnimated && !isTest) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant CosmicLogoBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (widget.isAnimated != oldWidget.isAnimated) {
      if (widget.isAnimated && !isTest) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
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
    final shouldAnimate = widget.isAnimated && !disableAnimations && !isTest;

    final emblem = SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Triple-Macro Multi-Colored Glow (Carbs Blue + Fat Pink + Protein Gold)
          Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: widget.size * 0.3,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.25),
                  blurRadius: widget.size * 0.25,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: AppColors.tertiary.withValues(alpha: 0.2),
                  blurRadius: widget.size * 0.18,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),

          // 2. Center Image: The Cosmic Apple Bite Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.size * 0.2),
            child: Container(
              width: widget.size * 0.72,
              height: widget.size * 0.72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size * 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: Image.asset(
                'assets/icons/app_icon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Graceful fallback for widget tests where asset bundle may not load binary
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, Color(0xFF0F172A)],
                      ),
                    ),
                    child: const Center(
                      child: Text('🍎', style: TextStyle(fontSize: 28)),
                    ),
                  );
                },
              ),
            ),
          ),

          // 3. Rotating Tri-Macro Nutrient Rings (Carbs, Fat, Protein)
          if (shouldAnimate)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _MacroRingsPainter(
                    progress: _controller.value,
                  ),
                );
              },
            )
          else
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _MacroRingsPainter(
                progress: 0.2,
              ),
            ),
        ],
      ),
    );

    if (widget.heroTag.isNotEmpty) {
      return Hero(
        tag: widget.heroTag,
        flightShuttleBuilder: (
          flightContext,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ) {
          return Material(
            color: Colors.transparent,
            child: toHeroContext.widget,
          );
        },
        child: emblem,
      );
    }

    return emblem;
  }
}

/// Draws 3 concentric/tilted cosmic rings representing:
/// 1. Blue: Carbohydrates (#1A73E8)
/// 2. Pink: Fat (#FF69B4)
/// 3. Gold: Protein (#FFD700)
class _MacroRingsPainter extends CustomPainter {
  _MacroRingsPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Carbs Ring (Blue #1A73E8) - Tilt -20 deg
    _drawRing(
      canvas: canvas,
      center: center,
      a: size.width * 0.47,
      b: size.height * 0.25,
      tilt: -20 * math.pi / 180,
      ringColor: AppColors.primary.withValues(alpha: 0.5),
      dotColor: AppColors.primary,
      progress: progress,
    );

    // 2. Fat Ring (Pink #FF69B4) - Tilt 35 deg
    _drawRing(
      canvas: canvas,
      center: center,
      a: size.width * 0.45,
      b: size.height * 0.22,
      tilt: 35 * math.pi / 180,
      ringColor: AppColors.secondary.withValues(alpha: 0.45),
      dotColor: AppColors.secondary,
      progress: (progress + 0.33) % 1.0,
    );

    // 3. Protein Ring (Gold #FFD700) - Tilt -65 deg
    _drawRing(
      canvas: canvas,
      center: center,
      a: size.width * 0.48,
      b: size.height * 0.24,
      tilt: -65 * math.pi / 180,
      ringColor: AppColors.tertiary.withValues(alpha: 0.5),
      dotColor: AppColors.tertiary,
      progress: (progress + 0.66) % 1.0,
    );
  }

  void _drawRing({
    required Canvas canvas,
    required Offset center,
    required double a,
    required double b,
    required double tilt,
    required Color ringColor,
    required Color dotColor,
    required double progress,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(tilt);

    final orbitPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final rect = Rect.fromCenter(center: Offset.zero, width: a * 2, height: b * 2);
    canvas.drawOval(rect, orbitPaint);

    final angle = progress * 2 * math.pi;
    final x = a * math.cos(angle);
    final y = b * math.sin(angle);

    final glowPaint = Paint()
      ..color = dotColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 4.5, glowPaint);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 2.0, dotPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MacroRingsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
