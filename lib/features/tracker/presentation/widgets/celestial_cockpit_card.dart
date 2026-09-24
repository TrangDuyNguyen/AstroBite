import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/calorie_progress_arc.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import 'package:astrobite/shared/widgets/macro_bar.dart';
import '../../domain/daily_summary.dart';

/// The signature Glanceable Celestial Cockpit Card.
/// Unifies Calorie Progress Arc and 3 Macro indicators side-by-side into a single compact card,
/// with an integrated collapsible micronutrient drawer.
class CelestialCockpitCard extends StatefulWidget {
  const CelestialCockpitCard({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  State<CelestialCockpitCard> createState() => _CelestialCockpitCardState();
}

class _CelestialCockpitCardState extends State<CelestialCockpitCard> {
  bool _isMicrosExpanded = false;

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final isOverBudget = summary.totalCalories > summary.targetCalories;

    return GlassCard(
      borderColor: isOverBudget
          ? AppColors.tertiary.withValues(alpha: 0.8)
          : AppColors.primary.withValues(alpha: 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Cockpit Badge & Calorie Target
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.rocket_launch_outlined,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppValues.spacing4),
                  Text(
                    'CELESTIAL COCKPIT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                  ),
                ],
              ),
              Text(
                'Mục tiêu: ${summary.targetCalories} kcal',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),

          // Main Cockpit Row: Left Calorie Arc & Right 3 Macro Bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Calorie Radial Arc
              CalorieProgressArc(
                consumed: summary.totalCalories,
                target: summary.targetCalories,
                size: 130,
                strokeWidth: 10,
              ),
              const SizedBox(width: AppValues.spacing16),

              // Right: 3 Macro Bars (Carbs, Protein, Fat)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MacroBar(
                      label: AppStrings.carbs,
                      currentG: summary.totalCarbsG,
                      targetG: summary.targetCarbsG,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    MacroBar(
                      label: AppStrings.protein,
                      currentG: summary.totalProteinG,
                      targetG: summary.targetProteinG,
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    MacroBar(
                      label: AppStrings.fat,
                      currentG: summary.totalFatG,
                      targetG: summary.targetFatG,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppValues.spacing12),
          const Divider(height: 1, color: Color(0x1FFFFFFF)),
          const SizedBox(height: AppValues.spacing8),

          // Collapsible Micronutrients Pill / Button
          InkWell(
            onTap: () => setState(() => _isMicrosExpanded = !_isMicrosExpanded),
            borderRadius: BorderRadius.circular(AppValues.radius8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.science_outlined,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppValues.spacing4),
                        Expanded(
                          child: Text(
                            'Vi chất: Natri ${summary.totalSodiumMg.toInt()}mg • Xơ ${summary.totalFiberG.toInt()}g • Đường ${summary.totalSugarG.toInt()}g',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isMicrosExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Micronutrient details
          if (_isMicrosExpanded)
            Padding(
              padding: const EdgeInsets.only(top: AppValues.spacing8),
              child: Column(
                children: [
                  _MicroNutrientRow(
                    label: 'Natri (Sodium)',
                    current: '${summary.totalSodiumMg.toInt()} mg',
                    limit: 'Tối đa ${summary.targetSodiumMg.toInt()} mg',
                    isWarning: summary.totalSodiumMg > summary.targetSodiumMg,
                    accentColor: summary.totalSodiumMg > summary.targetSodiumMg
                        ? AppColors.error
                        : const Color(0xFF00E5FF),
                  ),
                  const SizedBox(height: 6),
                  _MicroNutrientRow(
                    label: 'Chất xơ (Fiber)',
                    current: '${summary.totalFiberG.toInt()} g',
                    limit: 'Mục tiêu ${summary.targetFiberG.toInt()} g',
                    isWarning: false,
                    accentColor: const Color(0xFF00E676),
                  ),
                  const SizedBox(height: 6),
                  _MicroNutrientRow(
                    label: 'Lượng đường (Sugar)',
                    current: '${summary.totalSugarG.toInt()} g',
                    limit: 'Tối đa ${summary.targetSugarG.toInt()} g',
                    isWarning: summary.totalSugarG > summary.targetSugarG,
                    accentColor: summary.totalSugarG > summary.targetSugarG
                        ? AppColors.error
                        : const Color(0xFFFF9100),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MicroNutrientRow extends StatelessWidget {
  const _MicroNutrientRow({
    required this.label,
    required this.current,
    required this.limit,
    required this.isWarning,
    required this.accentColor,
  });

  final String label;
  final String current;
  final String limit;
  final bool isWarning;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppValues.radius8),
        border: Border.all(
          color: isWarning ? AppColors.error : AppColors.outline.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                current,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isWarning ? AppColors.error : AppColors.onSurface,
                    ),
              ),
              const SizedBox(width: 6),
              Text(
                '($limit)',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
