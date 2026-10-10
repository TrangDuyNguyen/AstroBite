import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/scan_result.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'scan_tactile_action_button.dart';

/// Bottom sticky navigation bar with MealTypeChip row and Save / Rescan actions.
class ScanReviewActionBar extends StatelessWidget {
  const ScanReviewActionBar({
    super.key,
    required this.selectedMeal,
    required this.onMealSelected,
    required this.onRescan,
    required this.onSave,
    required this.isSaving,
    required this.scaled,
    required this.mealLabel,
  });

  final String selectedMeal;
  final ValueChanged<String> onMealSelected;
  final VoidCallback onRescan;
  final VoidCallback onSave;
  final bool isSaving;
  final ScanResult scaled;
  final String Function(String meal) mealLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.spacing12,
        AppValues.screenPadding,
        AppValues.spacing16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1E2337),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppColors.outline.withValues(alpha: 0.5),
            width: 1.2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // One-Thumb Meal Type Selector (US-03)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MealTypeChip(
                    mealType: 'breakfast',
                    isSelected: selectedMeal == 'breakfast',
                    onTap: () => onMealSelected('breakfast'),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  MealTypeChip(
                    mealType: 'lunch',
                    isSelected: selectedMeal == 'lunch',
                    onTap: () => onMealSelected('lunch'),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  MealTypeChip(
                    mealType: 'dinner',
                    isSelected: selectedMeal == 'dinner',
                    onTap: () => onMealSelected('dinner'),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  MealTypeChip(
                    mealType: 'snack',
                    isSelected: selectedMeal == 'snack',
                    onTap: () => onMealSelected('snack'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.spacing12),
            // Sticky Save CTA Button Row with Re-scan
            Row(
              children: [
                // Tactile Re-scan button
                ScanTactileActionButton(
                  icon: Icons.refresh_rounded,
                  iconSize: 24,
                  tooltip: 'Quét lại',
                  onPressed: onRescan,
                ),
                const SizedBox(width: AppValues.spacing12),
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF388002),
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x18000000),
                          offset: Offset(0, 6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: isSaving
                          ? null
                          : () {
                              HapticFeedback.lightImpact();
                              onSave();
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.brandGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSaving)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            const Icon(Icons.check_circle_outline, size: 20),
                          const SizedBox(width: AppValues.spacing8),
                          Text(
                            isSaving
                                ? 'Đang lưu...'
                                : 'Lưu vào ${mealLabel(selectedMeal)} (${scaled.activeCalories} kcal)',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
