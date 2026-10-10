import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/meal_enums.dart';

import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Bottom bar for ManualEntryPage with one-thumb meal selector and sticky save CTA button.
class ManualEntryBottomBar extends StatelessWidget {
  const ManualEntryBottomBar({
    super.key,
    required this.selectedMeal,
    required this.onMealChanged,
    required this.isSaving,
    required this.canSave,
    required this.onSave,
    required this.totalCalories,
  });

  final MealType selectedMeal;
  final ValueChanged<MealType> onMealChanged;
  final bool isSaving;
  final bool canSave;
  final VoidCallback? onSave;
  final int totalCalories;

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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x121E2337),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: AppColors.outline, width: 1.2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // One-Thumb Meal Type Selector using MealType.values
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: MealType.values.map((m) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: MealTypeChip(
                      mealType: m.value,
                      isSelected: selectedMeal == m,
                      onTap: () => onMealChanged(m),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppValues.spacing12),

            // Sticky Save CTA Button
            ClayButton(
              width: double.infinity,
              height: 52,
              isLoading: isSaving,
              onPressed: (!canSave || isSaving) ? null : onSave,
              icon: const Icon(Icons.bookmark_add_rounded, color: Colors.white, size: 20),
              text: isSaving
                  ? 'Đang lưu...'
                  : 'Lưu vào ${selectedMeal.label} ($totalCalories kcal)',
            ),
          ],
        ),
      ),
    );
  }
}
