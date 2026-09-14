import 'dart:math';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Circular progress arc for daily calorie budget.
/// Glows blue normally, transitions to gold when over budget.
class CalorieProgressArc extends StatelessWidget {
  const CalorieProgressArc({
    super.key,
    required this.consumed,
    required this.target,
    this.size = 200,
    this.strokeWidth = 12,
  });

  final int consumed;
  final int target;
  final double size;
  final double strokeWidth;

  double get progress => target > 0 ? consumed / target : 0;
  bool get isOverBudget => consumed > target;
  int get remaining => max(0, target - consumed);

  @override
  Widget build(BuildContext context) {
    final progressColor = isOverBudget ? AppColors.tertiary : AppColors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          CustomPaint(
            size: Size(size, size),
            painter: _ArcPainter(
              progress: 1.0,
              color: AppColors.outline.withValues(alpha: 0.2),
              strokeWidth: strokeWidth,
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: _ArcPainter(
              progress: progress.clamp(0, 1),
              color: progressColor,
              strokeWidth: strokeWidth,
              withGlow: true,
            ),
          ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isOverBudget ? '+${consumed - target} kcal' : '$remaining kcal',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: progressColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isOverBudget ? AppStrings.overBudget : AppStrings.kcalRemaining,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isOverBudget ? AppColors.tertiary : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.withGlow = false,
  });

  final double progress;
  final Color color;
  final double strokeWidth;
  final bool withGlow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    if (withGlow) {
      // Glow layer
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, glowPaint);
    }

    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) =>
      old.progress != progress || old.color != color;
}
