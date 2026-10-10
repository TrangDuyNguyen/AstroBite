import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../../domain/entities/scan_result.dart';
import 'broth_toggle_chip.dart';
import 'scan_macro_gauge_section.dart';
import 'topping_checklist_wrap.dart';

/// Sub-card representing an individual dish in multi-dish scans.
class ScanDishItemCard extends StatelessWidget {
  const ScanDishItemCard({
    super.key,
    required this.dish,
    required this.onToggle,
    required this.onWeightChanged,
    required this.onRemove,
    this.onBrothToggle,
    this.onSubItemToggle,
  });

  final DishItem dish;
  final ValueChanged<bool?> onToggle;
  final ValueChanged<int> onWeightChanged;
  final VoidCallback onRemove;
  final ValueChanged<bool>? onBrothToggle;
  final void Function(int index, bool isSelected)? onSubItemToggle;

  @override
  Widget build(BuildContext context) {
    final isSelected = dish.isSelected;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isSelected ? 1.0 : 0.45,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppValues.spacing12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppValues.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.35)
                : AppColors.outline.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4CEBF).withValues(alpha: 0.7),
              offset: const Offset(0, 2.5),
              blurRadius: 0,
            ),
            const BoxShadow(
              color: Color(0x081E2337),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppValues.spacing12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: onToggle,
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      dish.dishName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: isSelected
                                ? TextDecoration.none
                                : TextDecoration.lineThrough,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.spacing8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppValues.radius8),
                    ),
                    child: Text(
                      '${(dish.confidenceScore * 100).toInt()}% tin cậy',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: 'Xóa món',
                    onPressed: onRemove,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.spacing8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dish.estimatedWeightG}g • ${dish.calories} kcal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                    ),
                    Row(
                      children: [
                        ScanMiniMacro(label: 'C', value: '${dish.carbsG}g', color: AppColors.primary),
                        const SizedBox(width: AppValues.spacing8),
                        ScanMiniMacro(label: 'P', value: '${dish.proteinG}g', color: AppColors.tertiary),
                        const SizedBox(width: AppValues.spacing8),
                        ScanMiniMacro(label: 'F', value: '${dish.fatG}g', color: AppColors.secondary),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: AppValues.spacing4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.outline.withValues(alpha: 0.3),
                    thumbColor: AppColors.primary,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: dish.estimatedWeightG.toDouble().clamp(20.0, 800.0),
                    min: 20.0,
                    max: 800.0,
                    divisions: 156,
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      onWeightChanged(val.round());
                    },
                  ),
                ),
                if (dish.hasBroth) ...[
                  BrothToggleChip(
                    hasBroth: dish.hasBroth,
                    includeBroth: dish.includeBroth,
                    brothCalories: dish.brothCalories,
                    brothSodiumMg: dish.brothSodiumMg,
                    onToggle: onBrothToggle ?? (_) {},
                  ),
                ],
                if (dish.subItems.isNotEmpty) ...[
                  ToppingChecklistWrap(
                    subItems: dish.subItems,
                    onToggleSubItem: onSubItemToggle ?? (_, __) {},
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
