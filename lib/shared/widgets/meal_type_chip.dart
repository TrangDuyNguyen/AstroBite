import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';

/// Chip component for meal type selection (Sáng/Trưa/Tối/Snack).
class MealTypeChip extends StatelessWidget {
  const MealTypeChip({
    super.key,
    required this.mealType,
    required this.isSelected,
    required this.onTap,
  });

  final String mealType;
  final bool isSelected;
  final VoidCallback onTap;

  String get _label => switch (mealType) {
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
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing12,
          vertical: AppValues.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppValues.spacing24),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_icon),
            const SizedBox(width: AppValues.spacing4),
            Text(
              _label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
