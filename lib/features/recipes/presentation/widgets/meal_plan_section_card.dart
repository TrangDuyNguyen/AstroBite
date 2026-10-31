import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/meal_plan_item.dart';
import 'add_meal_plan_item_sheet.dart';
import 'meal_plan_item_card.dart';

/// Puffy Clay Section for a specific meal category (Breakfast, Lunch, Dinner, Snack).
class MealPlanSectionCard extends StatelessWidget {
  const MealPlanSectionCard({
    super.key,
    required this.userId,
    required this.mealType,
    required this.items,
    required this.date,
  });

  final String userId;
  final String mealType;
  final List<MealPlanItem> items;
  final String date;

  MealType get _type => MealType.fromValue(mealType);

  @override
  Widget build(BuildContext context) {
    final sectionCalories = items.fold(0.0, (sum, i) => sum + i.calories);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _type.clayBgColor,
                      borderRadius: BorderRadius.circular(AppValues.radius12),
                      border: Border.all(
                        color: _type.color.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(_type.icon, size: 18, color: _type.color),
                  ),
                  const SizedBox(width: AppValues.spacing12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _type.label,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        items.isEmpty
                            ? 'Chưa có món'
                            : '${items.length} món  •  ${sectionCalories.round()} kcal',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ClayIconButton(
                size: 38,
                borderRadius: 12,
                icon: Icons.add_rounded,
                tooltip: 'Thêm vào ${_type.label}',
                iconColor: AppColors.primary,
                backgroundColor: AppColors.surfaceContainer,
                onPressed: () => _openAddSheet(context),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),

          // Items or Empty Slot
          if (items.isEmpty)
            _EmptySlotCard(
              mealType: _type,
              onTap: () => _openAddSheet(context),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppValues.spacing8),
                child: MealPlanItemCard(
                  item: item,
                  mealType: _type,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openAddSheet(BuildContext context) {
    AddMealPlanItemSheet.show(
      context,
      userId: userId,
      date: date,
      mealType: mealType,
      mealLabel: _type.label,
    );
  }
}

class _EmptySlotCard extends StatelessWidget {
  const _EmptySlotCard({
    required this.mealType,
    required this.onTap,
  });

  final MealType mealType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing16,
          vertical: AppValues.spacing12,
        ),
        decoration: BoxDecoration(
          color: mealType.clayBgColor.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
          border: Border.all(
            color: mealType.color.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: mealType.color,
              size: 20,
            ),
            const SizedBox(width: AppValues.spacing8),
            Expanded(
              child: Text(
                'Lên thực đơn cho ${mealType.label}',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: mealType.color.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
