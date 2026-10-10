import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../controllers/recipe_builder_controller.dart';

/// Dismissible ingredient card tile with mini macro indicators.
class RecipeIngredientTile extends ConsumerWidget {
  const RecipeIngredientTile({
    super.key,
    required this.ingredient,
    required this.index,
  });

  final RecipeIngredient ingredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('${ingredient.foodId}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppValues.screenPadding),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE8EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFAC4D2)),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      onDismissed: (_) =>
          ref.read(recipeBuilderProvider.notifier).removeIngredient(index),
      child: ClayCard(
        elevation: 2.5,
        borderRadius: 16.0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Left Dish Badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F6F2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEDE8DD), width: 1.0),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.restaurant_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),

            // Name & grams/calories
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ingredient.amountGrams.toStringAsFixed(0)}g • '
                    '${ingredient.calories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Mini Macro Dots
            Row(
              children: [
                _MiniDot(AppColors.carbs, ingredient.carbs, 'C'),
                const SizedBox(width: 6),
                _MiniDot(AppColors.protein, ingredient.protein, 'P'),
                const SizedBox(width: 6),
                _MiniDot(AppColors.fat, ingredient.fat, 'F'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniDot extends StatelessWidget {
  const _MiniDot(this.color, this.value, this.unit);

  final Color color;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${value.toStringAsFixed(0)}g',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
