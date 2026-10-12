import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/entities/meal_slot.dart';
import 'package:astrobite/features/tracker/presentation/controllers/tracker_controller.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'food_detail_sheet.dart';
import 'meal_food_item_tile.dart';

/// Next-Gen Cosmic Meal Capsule.
/// Features 2 visual states:
/// 1. Empty State: Ultra-compact Slim Tile (58pt) with 3D tactile icon, suggested kcal, (+) button, and optional trash button.
/// 2. Filled State: Expanded card with header macro progress, list of food items, and quick action buttons.
class CosmicMealCapsule extends ConsumerWidget {
  const CosmicMealCapsule({
    super.key,
    required this.slot,
    required this.summary,
    required this.onAddTap,
    this.onDeleteTap,
  });

  final MealSlot slot;
  final DailySummary summary;
  final VoidCallback onAddTap;
  final VoidCallback? onDeleteTap;

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
    final logs = summary.getMealLogs(slot.id);
    final totalCalories = summary.getMealCalories(slot.id);
    final totalCarbs = summary.getMealCarbs(slot.id);
    final totalProtein = summary.getMealProtein(slot.id);
    final totalFat = summary.getMealFat(slot.id);
    final isCompleted = logs.isNotEmpty;
    final suggestedKcal = slot.calculateSuggestedCalories(summary.targetCalories);
    final mealTypeEnum = MealType.fromValue(slot.baseMealType);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacing12),
      child: ClayCard(
        backgroundColor: slot.clayBgColor,
        elevation: 3.0,
        borderRadius: 22,
        padding: isCompleted
            ? const EdgeInsets.all(AppValues.cardPadding)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: isCompleted
            ? _buildExpandedContent(
                context: context,
                ref: ref,
                logs: logs,
                totalCalories: totalCalories,
                totalCarbs: totalCarbs,
                totalProtein: totalProtein,
                totalFat: totalFat,
                suggestedKcal: suggestedKcal,
                mealTypeEnum: mealTypeEnum,
              )
            : _buildSlimContent(
                context: context,
                suggestedKcal: suggestedKcal,
              ),
      ),
    );
  }

  /// Ultra-compact Slim Tile when no foods have been logged yet.
  Widget _buildSlimContent({
    required BuildContext context,
    required int suggestedKcal,
  }) {
    return Row(
      children: [
        // 3D Beveled Icon Container
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x181E2337),
                offset: Offset(0, 2),
                blurRadius: 0,
              ),
              BoxShadow(
                color: Color(0x0A000000),
                offset: Offset(0, 3),
                blurRadius: 4,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(slot.icon, size: 20, color: AppColors.onSurface),
        ),
        const SizedBox(width: 12),

        // Title and Suggested Calories
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                slot.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '0 kcal / $suggestedKcal kcal gợi ý',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Actions: Delete (if removable) + Add (+) button
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (slot.isRemovable && onDeleteTap != null) ...[
              Tooltip(
                message: 'Xóa bữa phụ',
                child: InkWell(
                  onTap: onDeleteTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.25),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Tactile 3D Plus Button
            InkWell(
              onTap: onAddTap,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF1488C2),
                      offset: Offset(0, 2.5),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x251CB0F6),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add_rounded, size: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Expanded Card when food logs are present.
  Widget _buildExpandedContent({
    required BuildContext context,
    required WidgetRef ref,
    required List<dynamic> logs,
    required int totalCalories,
    required int totalCarbs,
    required int totalProtein,
    required int totalFat,
    required int suggestedKcal,
    required MealType mealTypeEnum,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Icon(slot.icon, size: 20, color: AppColors.onSurface),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        slot.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.brandGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Đã ăn',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$totalCalories kcal / $suggestedKcal kcal gợi ý • ${totalCarbs}g C • ${totalProtein}g P • ${totalFat}g F',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (slot.isRemovable && onDeleteTap != null) ...[
              Tooltip(
                message: 'Xóa bữa phụ',
                child: InkWell(
                  onTap: onDeleteTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            InkWell(
              onTap: onAddTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF1488C2),
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing12),
        Divider(
          height: 1,
          color: AppColors.outline.withValues(alpha: 0.15),
        ),
        const SizedBox(height: AppValues.spacing8),

        // List of food logs
        ...logs.map((log) => MealFoodItemTile(
              log: log,
              mealType: mealTypeEnum,
              onTap: () => FoodDetailSheet.show(
                context: context,
                ref: ref,
                log: log,
                mealType: mealTypeEnum,
                targetCalories: summary.targetCalories,
              ),
              onConfirmDelete: (dishName) =>
                  _showDeleteConfirmationDialog(context, dishName),
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
                    content: Text(context.l10n.foodDeleted(log.dishName)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            )),
      ],
    );
  }
}
