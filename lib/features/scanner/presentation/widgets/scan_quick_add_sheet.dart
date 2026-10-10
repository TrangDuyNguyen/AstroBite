import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../../domain/entities/scan_result.dart';

/// Modal bottom sheet allowing the user to manually add a side dish to the meal.
class ScanQuickAddSheet {
  static void show(
    BuildContext context, {
    required ValueChanged<DishItem> onAdd,
  }) {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final weightController = TextEditingController(text: '150');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.cardRadius)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppValues.screenPadding,
          right: AppValues.screenPadding,
          top: AppValues.screenPadding,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppValues.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ctx.l10n.manualAddDishTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: ctx.l10n.dishNameLabel,
                hintText: ctx.l10n.dishNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppValues.spacing12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: calController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: ctx.l10n.caloriesKcalLabel,
                      hintText: ctx.l10n.caloriesHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppValues.spacing12),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: ctx.l10n.portionGramsLabel,
                      hintText: ctx.l10n.portionHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing16),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final cal = int.tryParse(calController.text.trim()) ?? 0;
                final weight = int.tryParse(weightController.text.trim()) ?? 150;
                if (name.isNotEmpty && cal > 0) {
                  onAdd(DishItem(
                    dishName: name,
                    confidenceScore: 1.0,
                    estimatedWeightG: weight,
                    calories: cal,
                    carbsG: (cal * 0.5 / 4).round(),
                    proteinG: (cal * 0.3 / 4).round(),
                    fatG: (cal * 0.2 / 9).round(),
                    isSelected: true,
                  ));
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(ctx.l10n.addToMealPlatter),
            ),
          ],
        ),
      ),
    );
  }
}
