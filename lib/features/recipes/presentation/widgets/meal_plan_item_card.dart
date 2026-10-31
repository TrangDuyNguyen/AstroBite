import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/meal_plan_item.dart';
import '../controllers/meal_plan_controller.dart';

/// Puffy Clay Card displaying an individual meal plan entry with 1-tap logging.
class MealPlanItemCard extends ConsumerWidget {
  const MealPlanItemCard({
    super.key,
    required this.item,
    required this.mealType,
  });

  final MealPlanItem item;
  final MealType mealType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClayCard(
      padding: const EdgeInsets.all(AppValues.spacing12),
      borderRadius: AppValues.cardRadiusClay,
      child: Row(
        children: [
          // Food category avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: mealType.clayBgColor,
              borderRadius: BorderRadius.circular(AppValues.radius12),
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: mealType.color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppValues.spacing12),

          // Name + macro details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Wrap(
                  spacing: 6,
                  children: [
                    Text(
                      '${item.calories.round()} kcal',
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(
                        color: AppColors.outline,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'C ${item.carbs.round()}g',
                      style: const TextStyle(
                        color: AppColors.carbs,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'P ${item.protein.round()}g',
                      style: const TextStyle(
                        color: AppColors.protein,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'F ${item.fat.round()}g',
                      style: const TextStyle(
                        color: AppColors.fat,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action: 1-Tap Log to Diary or Logged Status
          if (!item.isLogged)
            _OneTapLogButton(
              onTap: () => _log(context, ref),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.spacing8,
                vertical: AppValues.spacing4,
              ),
              decoration: BoxDecoration(
                color: AppColors.clayMint,
                borderRadius: BorderRadius.circular(AppValues.radius8),
                border: Border.all(color: const Color(0xFFBCE99A), width: 1.0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: AppColors.brandGreen,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Đã ăn',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          // Delete button
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
            tooltip: 'Xóa khỏi kế hoạch',
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _log(BuildContext context, WidgetRef ref) async {
    await ref.read(mealPlanControllerProvider.notifier).logMealToDiary(
          userId: item.userId,
          item: item,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.foodName} đã được ghi vào nhật ký!'),
          backgroundColor: AppColors.brandGreen,
        ),
      );
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    await ref.read(mealPlanControllerProvider.notifier).deleteItem(
          userId: item.userId,
          itemId: item.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa ${item.foodName} khỏi kế hoạch'),
          backgroundColor: AppColors.onSurfaceVariant,
        ),
      );
    }
  }
}

class _OneTapLogButton extends StatelessWidget {
  const _OneTapLogButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing12,
          vertical: AppValues.spacing8,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppValues.radius12),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF1488C2),
              offset: Offset(0, 2.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 14,
            ),
            SizedBox(width: 4),
            Text(
              'Ghi nhật ký',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
