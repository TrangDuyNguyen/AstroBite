import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Claymorphic Chip component for meal type selection (Sáng / Trưa / Tối / Ăn vặt).
/// Features 24pt capsule pill radius, pastel tints, and tactile press animation.
class ClayMealChip extends StatelessWidget {
  const ClayMealChip({
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

  IconData get _iconData => switch (mealType) {
    'breakfast' => Icons.wb_twilight_rounded,
    'lunch'     => Icons.wb_sunny_rounded,
    'dinner'    => Icons.nightlight_round,
    'snack'     => Icons.apple_rounded,
    _           => Icons.restaurant_rounded,
  };

  Color get _iconColor => switch (mealType) {
    'breakfast' => AppColors.tertiary,
    'lunch'     => AppColors.primary,
    'dinner'    => const Color(0xFF9D65FF),
    'snack'     => AppColors.secondary,
    _           => AppColors.primary,
  };

  Color get _unselectedBg => switch (mealType) {
    'breakfast' => AppColors.clayBreakfast,
    'lunch'     => AppColors.clayLunch,
    'dinner'    => AppColors.clayDinner,
    'snack'     => AppColors.claySnack,
    _           => AppColors.shimmerBase,
  };

  @override
  Widget build(BuildContext context) {
    final activeColor = _iconColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing12,
          vertical: AppValues.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : _unselectedBg,
          borderRadius: BorderRadius.circular(AppValues.spacing24),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.outline,
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? activeColor.withValues(alpha: 0.25)
                  : const Color(0x061E2337),
              offset: Offset(0, isSelected ? 3 : 1.5),
              blurRadius: isSelected ? 6 : 3,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconData,
              size: 16,
              color: activeColor,
            ),
            const SizedBox(width: AppValues.spacing4),
            Text(
              _label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? activeColor : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef MealTypeChip = ClayMealChip;
