import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Average Macro Distribution Breakdown Card with 3 ChunkyMacroBars.
class AnalyticsMacroBreakdownCard extends StatelessWidget {
  const AnalyticsMacroBreakdownCard({
    super.key,
    this.carbsG = 215,
    this.targetCarbsG = 250,
    this.proteinG = 120,
    this.targetProteinG = 140,
    this.fatG = 50,
    this.targetFatG = 65,
  });

  final int carbsG;
  final int targetCarbsG;
  final int proteinG;
  final int targetProteinG;
  final int fatG;
  final int targetFatG;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.macroBreakdownTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.macroBreakdownSubtitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.clayMint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.l10n.balanced,
                  style: const TextStyle(
                    color: AppColors.brandGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          ChunkyMacroBar(
            label: context.l10n.carbs,
            currentG: carbsG,
            targetG: targetCarbsG,
            color: AppColors.carbs,
          ),
          const SizedBox(height: AppValues.spacing12),
          ChunkyMacroBar(
            label: context.l10n.protein,
            currentG: proteinG,
            targetG: targetProteinG,
            color: AppColors.protein,
          ),
          const SizedBox(height: AppValues.spacing12),
          ChunkyMacroBar(
            label: context.l10n.fat,
            currentG: fatG,
            targetG: targetFatG,
            color: AppColors.fat,
          ),
        ],
      ),
    );
  }
}
