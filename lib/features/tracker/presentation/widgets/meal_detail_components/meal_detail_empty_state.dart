import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Empty state card for MealDetailPage when no foods are logged for the meal.
class MealDetailEmptyState extends StatelessWidget {
  final String mealTitle;
  final VoidCallback onAddTap;

  const MealDetailEmptyState({
    super.key,
    required this.mealTitle,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(AppValues.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lunch_dining_outlined,
            size: 48,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: AppValues.spacing12),
          Text(
            'Chưa có món ăn nào trong $mealTitle',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppValues.spacing4),
          const Text(
            'Hãy thêm món để theo dõi calo và macro nhé!',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppValues.spacing16),
          ClayButton(
            text: 'Thêm món ngay',
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            onPressed: onAddTap,
          ),
        ],
      ),
    );
  }
}
