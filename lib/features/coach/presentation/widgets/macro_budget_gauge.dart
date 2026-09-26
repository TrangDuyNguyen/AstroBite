import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';

/// Props for [MacroBudgetGauge].
class MacroBudgetGaugeProps {
  const MacroBudgetGaugeProps({
    required this.projectedCalories,
    required this.remainingCalories,
    required this.targetCalories,
  });

  final int projectedCalories;
  final int remainingCalories;
  final int targetCalories;

  factory MacroBudgetGaugeProps.fromMap(Map<String, dynamic> map) {
    final rawProj = map['projectedCalories'] ?? map['projected_calories'] ?? map['calories'];
    final rawRem = map['remainingCalories'] ?? map['remaining_calories'];
    final rawTar = map['targetCalories'] ?? map['target_calories'];

    return MacroBudgetGaugeProps(
      projectedCalories: (rawProj is num ? rawProj.round() : int.tryParse('$rawProj')) ?? 0,
      remainingCalories: (rawRem is num ? rawRem.round() : int.tryParse('$rawRem')) ?? 0,
      targetCalories: (rawTar is num ? rawTar.round() : int.tryParse('$rawTar')) ?? 2000,
    );
  }

  Map<String, dynamic> toMap() => {
        'projectedCalories': projectedCalories,
        'remainingCalories': remainingCalories,
        'targetCalories': targetCalories,
      };
}

/// CatalogItem widget showing projected calorie impact vs daily calorie budget.
class MacroBudgetGauge extends StatelessWidget {
  const MacroBudgetGauge({
    super.key,
    required this.props,
  });

  final MacroBudgetGaugeProps props;

  @override
  Widget build(BuildContext context) {
    final afterEatingRemaining = props.remainingCalories - props.projectedCalories;
    final isExceeded = afterEatingRemaining < 0;

    final double progress = props.targetCalories > 0
        ? (props.projectedCalories / props.targetCalories).clamp(0.0, 1.0)
        : 0.0;

    return GlassCard(
      padding: const EdgeInsets.all(AppValues.cardPadding),
      borderRadius: 14,
      borderColor: isExceeded
          ? AppColors.tertiary.withValues(alpha: 0.4)
          : AppColors.primary.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isExceeded ? Icons.warning_amber_rounded : Icons.pie_chart_rounded,
                    size: 16,
                    color: isExceeded ? AppColors.tertiary : AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'TÁC ĐỘNG NGÂN SÁCH NGÀY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Text(
                '+${props.projectedCalories} kcal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isExceeded ? AppColors.tertiary : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Double Layer Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceBlur,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isExceeded ? AppColors.tertiary : AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isExceeded
                    ? '⚠️ Vượt ${afterEatingRemaining.abs()} kcal mục tiêu'
                    : 'Còn lại sau bữa: $afterEatingRemaining kcal',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isExceeded ? AppColors.tertiary : AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                'Mục tiêu: ${props.targetCalories} kcal',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
