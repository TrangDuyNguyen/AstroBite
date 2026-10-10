import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../../domain/entities/scan_result.dart';
import 'broth_toggle_chip.dart';
import 'scan_quick_weight_stepper.dart';
import 'topping_checklist_wrap.dart';

/// Portion adjustment card for single-dish scans.
class ScanPortionCard extends StatelessWidget {
  const ScanPortionCard({
    super.key,
    required this.effectiveWeight,
    required this.onWeightChanged,
    required this.dishes,
    required this.onBrothToggle,
    required this.onSubItemToggle,
  });

  final int effectiveWeight;
  final ValueChanged<int> onWeightChanged;
  final List<DishItem> dishes;
  final ValueChanged<bool> onBrothToggle;
  final void Function(int index, bool isSelected) onSubItemToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppValues.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppValues.spacing20),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.6),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFD4CEBF),
                offset: Offset(0, 3.0),
                blurRadius: 0,
              ),
              BoxShadow(
                color: Color(0x0A1E2337),
                offset: Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.portionEstimated,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.spacing12,
                      vertical: AppValues.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(AppValues.radius8),
                      border: Border.all(
                        color: const Color(0xFFBAE6FD),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${effectiveWeight}g',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing12),

              // Quick Weight Steppers (US-02 / BVA Presets)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    QuickReviewWeightChip(
                      label: '-50g',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onWeightChanged((effectiveWeight - 50).clamp(50, 1000));
                      },
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    QuickReviewWeightChip(
                      label: '+50g',
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onWeightChanged((effectiveWeight + 50).clamp(50, 1000));
                      },
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    QuickReviewWeightChip(
                      label: context.l10n.portionBowl,
                      isSelected: effectiveWeight == 150,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onWeightChanged(150);
                      },
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    QuickReviewWeightChip(
                      label: context.l10n.portionPlate,
                      isSelected: effectiveWeight == 300,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onWeightChanged(300);
                      },
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    QuickReviewWeightChip(
                      label: context.l10n.portionStandard,
                      isSelected: effectiveWeight == 350,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onWeightChanged(350);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppValues.spacing8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.outline.withValues(alpha: 0.35),
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.15),
                  trackHeight: 5,
                ),
                child: Slider(
                  value: effectiveWeight.toDouble().clamp(50.0, 1000.0),
                  min: 50.0,
                  max: 1000.0,
                  divisions: 95,
                  onChanged: (val) {
                    HapticFeedback.selectionClick();
                    onWeightChanged(val.round());
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '50g',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '1000g',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (dishes.isNotEmpty && (dishes.first.hasBroth || dishes.first.subItems.isNotEmpty)) ...[
          const SizedBox(height: AppValues.spacing12),
          BrothToggleChip(
            hasBroth: dishes.first.hasBroth,
            includeBroth: dishes.first.includeBroth,
            brothCalories: dishes.first.brothCalories,
            brothSodiumMg: dishes.first.brothSodiumMg,
            onToggle: onBrothToggle,
          ),
          ToppingChecklistWrap(
            subItems: dishes.first.subItems,
            onToggleSubItem: onSubItemToggle,
          ),
        ],
        const SizedBox(height: AppValues.spacing16),
      ],
    );
  }
}
