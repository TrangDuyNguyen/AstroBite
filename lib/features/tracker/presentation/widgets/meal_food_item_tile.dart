import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'sync_status_badge.dart';

/// Dismissible food log item tile with high sodium alert, mini macro indicators, and swipe-to-delete.
class MealFoodItemTile extends StatelessWidget {
  const MealFoodItemTile({
    super.key,
    required this.log,
    required this.mealType,
    required this.onTap,
    required this.onConfirmDelete,
    required this.onDismissed,
  });

  final FoodLog log;
  final MealType mealType;
  final VoidCallback onTap;
  final Future<bool?> Function(String dishName) onConfirmDelete;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(log.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppValues.spacing16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
      ),
      confirmDismiss: (direction) => onConfirmDelete(log.dishName),
      onDismissed: (direction) => onDismissed(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEDE8DD), width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              offset: Offset(0, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Meal category avatar
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: mealType.clayBgColor,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: mealType.color.withValues(alpha: 0.25),
                              width: 0.8,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.restaurant_menu_rounded,
                              size: 16,
                              color: mealType.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppValues.spacing8),

                        // Food title and mini macros
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${log.dishName} (${log.estimatedWeightG}g)',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.onSurface,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (log.isHighSodium) ...[
                                    const SizedBox(width: AppValues.spacing4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.warning_amber_rounded, size: 11, color: AppColors.error),
                                          SizedBox(width: 2),
                                          Text(
                                            'Muối cao',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  _MiniMacroDot(color: AppColors.primary, label: '${log.carbsG}g C'),
                                  const SizedBox(width: 6),
                                  _MiniMacroDot(color: AppColors.tertiary, label: '${log.proteinG}g P'),
                                  const SizedBox(width: 6),
                                  _MiniMacroDot(color: AppColors.secondary, label: '${log.fatG}g F'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppValues.spacing8),

                  // Calorie label & status
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4EC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE8E3D7), width: 0.8),
                        ),
                        child: Text(
                          '${log.calories} cal',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                letterSpacing: AppValues.calorieLetterSpacing,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                                fontSize: 12,
                              ),
                        ),
                      ),
                      const SizedBox(width: AppValues.spacing4),
                      SyncStatusBadge(syncStatus: log.syncStatus),
                      const SizedBox(width: 2),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFEDE8DD), width: 0.8),
                        ),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMacroDot extends StatelessWidget {
  const _MiniMacroDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5.5,
          height: 5.5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 3.5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
