import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../../domain/entities/scan_result.dart';
import 'micronutrient_chips_row.dart';
import 'scan_macro_gauge_section.dart';

/// Hero Calorie Card displaying active calories, radial target gauge, 3 macro indicators, and micronutrients.
class ScanReviewHeroCard extends StatelessWidget {
  const ScanReviewHeroCard({
    super.key,
    required this.scaled,
    required this.effectiveWeight,
  });

  final ScanResult scaled;
  final int effectiveWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppValues.spacing24),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD4CEBF),
            offset: Offset(0, 3.5),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0x0C1E2337),
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${scaled.activeCalories} kcal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: AppValues.calorieLetterSpacing,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Khẩu phần tiêu chuẩn • ${effectiveWeight}g',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              ScanCalorieTargetRadialGauge(
                calories: scaled.activeCalories,
                targetCalories: 2100,
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          // Strict Nutrient Color Semantics - Macro Triad (Carbs, Protein, Fat)
          Row(
            children: [
              Expanded(
                child: ScanMacroIndicator(
                  label: 'Tinh bột',
                  value: '${scaled.activeCarbsG}g',
                  color: AppColors.primary,
                  ratio: (scaled.activeCalories > 0
                      ? (scaled.activeCarbsG * 4) / scaled.activeCalories
                      : 0.48).clamp(0.0, 1.0),
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Expanded(
                child: ScanMacroIndicator(
                  label: 'Chất đạm',
                  value: '${scaled.activeProteinG}g',
                  color: AppColors.tertiary,
                  ratio: (scaled.activeCalories > 0
                      ? (scaled.activeProteinG * 4) / scaled.activeCalories
                      : 0.24).clamp(0.0, 1.0),
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Expanded(
                child: ScanMacroIndicator(
                  label: 'Chất béo',
                  value: '${scaled.activeFatG}g',
                  color: AppColors.secondary,
                  ratio: (scaled.activeCalories > 0
                      ? (scaled.activeFatG * 9) / scaled.activeCalories
                      : 0.28).clamp(0.0, 1.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          MicronutrientChipsRow(
            sodiumMg: scaled.activeSodiumMg,
            fiberG: scaled.activeFiberG,
            sugarG: scaled.activeSugarG,
          ),
        ],
      ),
    );
  }
}
