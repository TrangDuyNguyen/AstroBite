import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Puffy 3D Claymorphic Water Reservoir Dial with 60 FPS Fluid Waves
class WaterWaveIndicator extends StatefulWidget {
  const WaterWaveIndicator({
    super.key,
    required this.progress,
    this.size = 84.0,
    this.isGoalReached = false,
  });

  final double progress;
  final double size;
  final bool isGoalReached;

  @override
  State<WaterWaveIndicator> createState() => _WaterWaveIndicatorState();
}

class _WaterWaveIndicatorState extends State<WaterWaveIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedProgress = widget.progress.clamp(0.0, 1.0);
    final waveColor = widget.isGoalReached ? AppColors.brandGreen : AppColors.primary;
    final bezelColor = widget.isGoalReached ? const Color(0xFFC7EBB2) : const Color(0xFFDDD8CE);

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF7F4EE)],
        ),
        border: Border.all(
          color: widget.isGoalReached ? const Color(0xFFBCE3A1) : const Color(0xFFEDE9E1),
          width: 1.5,
        ),
        boxShadow: [
          // Layer 1: Solid 3D tactile bottom bevel
          BoxShadow(
            color: bezelColor,
            offset: const Offset(0, 3.5),
            blurRadius: 0,
          ),
          // Layer 2: Glossy top reflection
          const BoxShadow(
            color: Colors.white,
            offset: Offset(0, -1.5),
            blurRadius: 2.5,
          ),
          // Layer 3: Warm ambient float shadow
          const BoxShadow(
            color: Color(0x181E2337),
            offset: Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size / 2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Reservoir well background
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isGoalReached
                      ? const Color(0xFFF0F9EA)
                      : const Color(0xFFEBF6FD),
                ),
              ),
              // Animated dual-layer fluid wave
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _ClayWavePainter(
                      animationValue: _controller.value,
                      progress: clampedProgress,
                      color: waveColor,
                    ),
                  );
                },
              ),
              // Top glossy 3D glass highlight
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: widget.size * 0.38,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Center percentage label with depth shadow
              Text(
                '${(widget.progress * 100).round()}%',
                style: TextStyle(
                  fontSize: widget.size * 0.22,
                  fontWeight: FontWeight.w900,
                  color: clampedProgress > 0.52 ? Colors.white : AppColors.onSurface,
                  shadows: clampedProgress > 0.52
                      ? const [
                          Shadow(
                            color: Color(0x40000000),
                            blurRadius: 3,
                            offset: Offset(0, 1.2),
                          ),
                        ]
                      : const [
                          Shadow(
                            color: Colors.white,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClayWavePainter extends CustomPainter {
  const _ClayWavePainter({
    required this.animationValue,
    required this.progress,
    required this.color,
  });

  final double animationValue;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final waterHeight = size.height * (1.0 - progress);
    final waveAmplitude = 3.8 * (1.0 - (progress - 0.5).abs() * 1.4).clamp(0.2, 1.0);

    // Layer A: Secondary subtle back wave
    final backPaint = Paint()..color = color.withValues(alpha: 0.38);
    final backPath = Path()..moveTo(0, waterHeight);
    for (double x = 0; x <= size.width; x += 1.0) {
      final dx = x / size.width;
      final radians = (dx * 2 * math.pi) + ((animationValue + 0.45) * 2 * math.pi);
      final y = waterHeight + math.sin(radians) * (waveAmplitude * 0.85);
      backPath.lineTo(x, y);
    }
    backPath.lineTo(size.width, size.height);
    backPath.lineTo(0, size.height);
    backPath.close();
    canvas.drawPath(backPath, backPaint);

    // Layer B: Primary vibrant wave with 3D depth gradient
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(color, Colors.white, 0.18)!,
          color,
          Color.lerp(color, Colors.black, 0.16)!,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final frontPath = Path()..moveTo(0, waterHeight);
    for (double x = 0; x <= size.width; x += 1.0) {
      final dx = x / size.width;
      final radians = (dx * 2 * math.pi) + (animationValue * 2 * math.pi);
      final y = waterHeight + math.sin(radians) * waveAmplitude;
      frontPath.lineTo(x, y);
    }
    frontPath.lineTo(size.width, size.height);
    frontPath.lineTo(0, size.height);
    frontPath.close();
    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant _ClayWavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.progress != progress ||
      oldDelegate.color != color;
}
