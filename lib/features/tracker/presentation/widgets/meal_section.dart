import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';

import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/presentation/controllers/tracker_controller.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'food_detail_sheet.dart';
import 'meal_card_header.dart';
import 'meal_food_item_tile.dart';

/// Claymorphic Meal Card displaying food logs, macro breakdown, and quick add action for a specific meal.
class MealSection extends ConsumerWidget {
  const MealSection({
    super.key,
    required this.mealType,
    required this.summary,
    required this.onAddTap,
  });

  final String mealType;
  final DailySummary summary;
  final VoidCallback onAddTap;

  MealType get _mealTypeEnum => MealType.fromValue(mealType);

  Future<bool?> _showDeleteConfirmationDialog(
    BuildContext context,
    String dishName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.confirmDelete),
        content: Text(context.l10n.deleteFoodConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = _mealTypeEnum;
    final logs = summary.getMealLogs(mealType);
    final totalCalories = summary.getMealCalories(mealType);
    final totalCarbs = summary.getMealCarbs(mealType);
    final totalProtein = summary.getMealProtein(mealType);
    final totalFat = summary.getMealFat(mealType);
    final isCompleted = logs.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacing12),
      child: ClayCard(
        backgroundColor: type.clayBgColor,
        elevation: 3.5,
        borderRadius: 22,
        padding: const EdgeInsets.all(AppValues.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MealCardHeader(
              mealType: type,
              isCompleted: isCompleted,
              totalCalories: totalCalories,
              totalCarbs: totalCarbs,
              totalProtein: totalProtein,
              totalFat: totalFat,
              suggestedCalories: type.calculateSuggestedCalories(summary.targetCalories),
              onAddTap: onAddTap,
            ),
            if (logs.isNotEmpty) ...[
              const SizedBox(height: AppValues.spacing12),
              Divider(
                height: 1,
                color: AppColors.outline.withValues(alpha: 0.15),
              ),
              const SizedBox(height: AppValues.spacing8),
              ...logs.map((log) => MealFoodItemTile(
                    log: log,
                    mealType: type,
                    onTap: () => FoodDetailSheet.show(
                      context: context,
                      ref: ref,
                      log: log,
                      mealType: type,
                      targetCalories: summary.targetCalories,
                    ),
                    onConfirmDelete: (dishName) => _showDeleteConfirmationDialog(context, dishName),
                    onDismissed: () {
                      final user = ref.read(authStateProvider).value;
                      if (user != null) {
                        ref.read(trackerControllerProvider.notifier).deleteFoodLog(
                              userId: user.uid,
                              logId: log.id,
                            );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xóa món ${log.dishName}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
