import 'package:flutter/material.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Card representing a logged food item in MealDetailPage.
class MealDetailFoodCard extends StatelessWidget {
  final FoodLog log;
  final VoidCallback onDelete;

  const MealDetailFoodCard({
    super.key,
    required this.log,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacing12),
      child: ClayCard(
        padding: const EdgeInsets.all(AppValues.spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppValues.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.dishName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${log.estimatedWeightG}g • ${log.calories} kcal',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'C:${log.carbsG} F:${log.fatG} P:${log.proteinG}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ClayIconButton(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
