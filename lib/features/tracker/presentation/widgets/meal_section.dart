import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import '../../domain/daily_summary.dart';

class MealSection extends StatelessWidget {
  const MealSection({
    super.key,
    required this.mealType,
    required this.summary,
    required this.onAddTap,
  });

  final String mealType;
  final DailySummary summary;
  final VoidCallback onAddTap;

  String get _title => switch (mealType) {
    'breakfast' => AppStrings.breakfast,
    'lunch'     => AppStrings.lunch,
    'dinner'    => AppStrings.dinner,
    'snack'     => AppStrings.snack,
    _           => mealType,
  };

  String get _icon => switch (mealType) {
    'breakfast' => '🌅',
    'lunch'     => '☀️',
    'dinner'    => '🌙',
    'snack'     => '🍪',
    _           => '🍽️',
  };

  @override
  Widget build(BuildContext context) {
    final logs = summary.getMealLogs(mealType);
    final totalCalories = summary.getMealCalories(mealType);

    return Card(
      margin: const EdgeInsets.only(bottom: AppValues.spacing12),
      child: Padding(
        padding: const EdgeInsets.all(AppValues.cardPadding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(_icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: AppValues.spacing8),
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$totalCalories kcal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        letterSpacing: AppValues.calorieLetterSpacing,
                      ),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: onAddTap,
                    ),
                  ],
                ),
              ],
            ),
            if (logs.isNotEmpty) ...[
              const Divider(height: AppValues.spacing16),
              ...logs.map((log) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${log.dishName} (${log.estimatedWeightG}g)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${log.calories} cal',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            letterSpacing: AppValues.calorieLetterSpacing,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
