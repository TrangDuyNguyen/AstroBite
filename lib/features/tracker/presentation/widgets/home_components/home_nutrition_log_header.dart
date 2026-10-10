import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Nutrition log section header for HomePage.
class HomeNutritionLogHeader extends StatelessWidget {
  final DailySummary summary;

  const HomeNutritionLogHeader({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: const Color(0xFFEDE8DD),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Clay3DCookbook(size: 22),
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.nutritionLog,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4 bữa • Cần nạp đủ để duy trì năng lượng',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppValues.spacing8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F5EE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE8E3D7),
              width: 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                offset: Offset(0, 1.5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            '${summary.totalCalories} / ${summary.targetCalories} kcal',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  letterSpacing: 0.3,
                ),
          ),
        ),
      ],
    );
  }
}
