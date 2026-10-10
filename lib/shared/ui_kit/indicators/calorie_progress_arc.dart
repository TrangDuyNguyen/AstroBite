import 'dart:math';
import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Circular progress arc for daily calorie budget.
/// Renders blue normally, transitions to orange/gold when over budget.
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

    final coinSize = size * 0.72;

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
              color: const Color(0xFFEDE9E1),
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
          // Center Clay Tactile Dial
          Container(
            width: coinSize,
            height: coinSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainer,
              border: Border.all(
                color: const Color(0xFFEDE9E1),
                width: 1.2,
              ),
              boxShadow: const [
                // 3D bottom bevel
                BoxShadow(
                  color: Color(0xFFDDD8CE),
                  offset: Offset(0, 2.5),
                  blurRadius: 0,
                ),
                // Soft ambient shadow
                BoxShadow(
                  color: Color(0x101E2337),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isOverBudget ? '+${consumed - target} kcal' : '$remaining kcal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: size < 160 ? 17 : 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: progressColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isOverBudget ? context.l10n.overBudget : context.l10n.kcalRemaining,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: size < 160 ? 10 : 12,
                      fontWeight: FontWeight.w600,
                      color: isOverBudget ? AppColors.tertiary : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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
