import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/calorie_progress_arc.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import 'package:astrobite/shared/widgets/macro_bar.dart';
import '../../domain/daily_summary.dart';

class DailySummaryCard extends StatelessWidget {
  const DailySummaryCard({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final isOverBudget = summary.totalCalories > summary.targetCalories;

    return GlassCard(
      borderColor: isOverBudget ? AppColors.tertiary.withValues(alpha: 0.8) : null,
      child: Column(
        children: [
          CalorieProgressArc(
            consumed: summary.totalCalories,
            target: summary.targetCalories,
          ),
          const SizedBox(height: AppValues.spacing24),
          MacroBar(
            label: AppStrings.protein,
            currentG: summary.totalProteinG,
            targetG: summary.targetProteinG,
            color: AppColors.tertiary,
          ),
          const SizedBox(height: AppValues.spacing12),
          MacroBar(
            label: AppStrings.carbs,
            currentG: summary.totalCarbsG,
            targetG: summary.targetCarbsG,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppValues.spacing12),
          MacroBar(
            label: AppStrings.fat,
            currentG: summary.totalFatG,
            targetG: summary.targetFatG,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
