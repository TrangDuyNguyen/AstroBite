import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Overview card on MealDetailPage showing total calories and 3 macro pills.
class MealDetailOverviewCard extends StatelessWidget {
  final Color mealTint;
  final IconData mealIcon;
  final int totalCalories;
  final int totalCarbs;
  final int totalFat;
  final int totalProtein;

  const MealDetailOverviewCard({
    super.key,
    required this.mealTint,
    required this.mealIcon,
    required this.totalCalories,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalProtein,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      backgroundColor: mealTint,
      padding: const EdgeInsets.all(AppValues.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(mealIcon, color: AppColors.primary, size: 24),
                  const SizedBox(width: AppValues.spacing8),
                  Text(
                    'Tổng quan dinh dưỡng',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$totalCalories kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),
          // 3 Macro distribution
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroPill(
                label: AppStrings.carbs,
                grams: totalCarbs,
                color: AppColors.primary,
              ),
              _MacroPill(
                label: AppStrings.fat,
                grams: totalFat,
                color: AppColors.secondary,
              ),
              _MacroPill(
                label: AppStrings.protein,
                grams: totalProtein,
                color: AppColors.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.grams,
    required this.color,
  });

  final String label;
  final int grams;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${grams}g',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
