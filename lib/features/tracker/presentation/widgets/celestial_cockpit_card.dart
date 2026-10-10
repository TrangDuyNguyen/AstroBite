import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/daily_summary.dart';
import 'cockpit_components/cockpit_micronutrients_drawer.dart';

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

    return ClayCard(
      borderRadius: 24,
      borderColor: isOverBudget ? AppColors.tertiary : const Color(0xFFEDE9E1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Cockpit Badge & Calorie Target
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE5F6FD),
                      border: Border.all(
                        color: const Color(0xFFBCE3F7),
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFBCE3F7),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x181CB0F6),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Clay3DRocket(size: 18),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  Text(
                    'CELESTIAL COCKPIT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
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
                      label: context.l10n.carbs,
                      currentG: summary.totalCarbsG,
                      targetG: summary.targetCarbsG,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    MacroBar(
                      label: context.l10n.protein,
                      currentG: summary.totalProteinG,
                      targetG: summary.targetProteinG,
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    MacroBar(
                      label: context.l10n.fat,
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
          const Divider(height: 1, color: Color(0xFFEDE9E1)),
          const SizedBox(height: AppValues.spacing8),

          // Collapsible Micronutrients Drawer
          CockpitMicronutrientsDrawer(
            summary: summary,
            isExpanded: _isMicrosExpanded,
            onToggle: () => setState(() => _isMicrosExpanded = !_isMicrosExpanded),
          ),
        ],
      ),
    );
  }
}
