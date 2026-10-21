import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// 60 FPS Animated Fluid Wave Indicator for Water Tracker
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: waveColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: waveColor.withValues(alpha: 0.35),
                  width: 2.0,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _WavePainter(
                    animationValue: _controller.value,
                    progress: clampedProgress,
                    color: waveColor,
                  ),
                );
              },
            ),
            Text(
              '${(widget.progress * 100).round()}%',
              style: TextStyle(
                fontSize: widget.size * 0.22,
                fontWeight: FontWeight.w800,
                color: clampedProgress > 0.55 ? Colors.white : AppColors.onSurface,
                shadows: clampedProgress > 0.55
                    ? [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        )
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({
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

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.85),
          color,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final waterHeight = size.height * (1.0 - progress);
    final waveAmplitude = 4.0 * (1.0 - (progress - 0.5).abs() * 1.5).clamp(0.2, 1.0);

    path.moveTo(0, waterHeight);
    for (double x = 0; x <= size.width; x += 1.0) {
      final dx = x / size.width;
      final radians = (dx * 2 * math.pi) + (animationValue * 2 * math.pi);
      final y = waterHeight + math.sin(radians) * waveAmplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.progress != progress ||
      oldDelegate.color != color;
}
