import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import '../../domain/daily_summary.dart';

class DailyMicronutrientCard extends StatefulWidget {
  const DailyMicronutrientCard({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  State<DailyMicronutrientCard> createState() => _DailyMicronutrientCardState();
}

class _DailyMicronutrientCardState extends State<DailyMicronutrientCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;

    final sodiumColor = summary.totalSodiumMg > summary.targetSodiumMg
        ? const Color(0xFFFF5252)
        : (summary.totalSodiumMg >= 1800.0
            ? const Color(0xFFFF9100)
            : const Color(0xFF00E5FF));

    final fiberReached = summary.totalFiberG >= summary.targetFiberG;
    const fiberColor = Color(0xFF00E676);

    final sugarColor = summary.totalSugarG > summary.targetSugarG
        ? const Color(0xFFFF5252)
        : (summary.totalSugarG >= 25.0
            ? const Color(0xFFFF9100)
            : const Color(0xFFE0E0E0));

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(AppValues.radius8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.science_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    Text(
                      'Vi Chất Dinh Dưỡng Hôm Nay',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                    ),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: AppValues.spacing16),
            // 1. Sodium Bar
            _MicroProgressBar(
              label:
                  'Natri: ${summary.totalSodiumMg.toInt()} / ${summary.targetSodiumMg.toInt()} mg',
              current: summary.totalSodiumMg,
              target: summary.targetSodiumMg,
              color: sodiumColor,
            ),
            const SizedBox(height: AppValues.spacing12),
            // 2. Fiber Bar
            _MicroProgressBar(
              label:
                  'Chất xơ: ${summary.totalFiberG.toStringAsFixed(1)} / ${summary.targetFiberG.toInt()} g',
              current: summary.totalFiberG,
              target: summary.targetFiberG,
              color: fiberColor,
              trailingIcon: fiberReached ? Icons.star_rounded : null,
            ),
            const SizedBox(height: AppValues.spacing12),
            // 3. Sugar Bar
            _MicroProgressBar(
              label:
                  'Đường: ${summary.totalSugarG.toStringAsFixed(1)} / ${summary.targetSugarG.toInt()} g',
              current: summary.totalSugarG,
              target: summary.targetSugarG,
              color: sugarColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _MicroProgressBar extends StatelessWidget {
  const _MicroProgressBar({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
    this.trailingIcon,
  });

  final String label;
  final double current;
  final double target;
  final Color color;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final ratio = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
            ),
            if (trailingIcon != null)
              Icon(
                trailingIcon,
                size: 16,
                color: color,
              ),
          ],
        ),
        const SizedBox(height: AppValues.spacing4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: AppColors.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
