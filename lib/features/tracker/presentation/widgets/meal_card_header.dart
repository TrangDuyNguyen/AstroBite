import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/meal_enums.dart';

import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Header section for MealCard with 3D Meal Badge, Title, Status, Macro summaries, and Add action.
class MealCardHeader extends StatelessWidget {
  const MealCardHeader({
    super.key,
    required this.mealType,
    required this.isCompleted,
    required this.totalCalories,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
    required this.suggestedCalories,
    required this.onAddTap,
  });

  final MealType mealType;
  final bool isCompleted;
  final int totalCalories;
  final int totalCarbs;
  final int totalProtein;
  final int totalFat;
  final int suggestedCalories;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Icon Avatar Box (Clay 3D Badge)
        _ClayMealBadge(mealType: mealType),
        const SizedBox(width: AppValues.spacing12),

        // 2. Title & Status or Macros info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Status Tag
              Row(
                children: [
                  Text(
                    mealType.localizedLabel(context),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  _StatusTag(isCompleted: isCompleted),
                ],
              ),
              const SizedBox(height: 3),

              // Metrics summary or suggestion
              if (isCompleted)
                _MacroSummaryRow(
                  totalCalories: totalCalories,
                  totalCarbs: totalCarbs,
                  totalProtein: totalProtein,
                  totalFat: totalFat,
                )
              else
                _SuggestedCaloriesRow(suggestedCalories: suggestedCalories),
            ],
          ),
        ),

        // 3. Trailing Action: Quick Add / Completed button
        if (isCompleted) ...[
          ClayIconButton(
            icon: Icons.add_circle_outline,
            onPressed: onAddTap,
            backgroundColor: AppColors.surfaceContainer,
            iconColor: AppColors.primary,
            size: 38,
            borderRadius: 19,
            tooltip: 'Thêm món ăn',
          ),
          const SizedBox(width: AppValues.spacing8),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandGreen,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF46A302),
                  offset: Offset(0, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
          ),
        ] else ...[
          ClayIconButton(
            icon: Icons.add_circle_outline,
            onPressed: onAddTap,
            backgroundColor: AppColors.primary,
            iconColor: Colors.white,
            size: 44,
            borderRadius: 22,
            tooltip: 'Thêm món ăn',
          ),
        ],
      ],
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFE8F9D8) : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCompleted ? const Color(0xFF58CC02) : const Color(0xFFDDD8CE),
          width: isCompleted ? 1.0 : 0.8,
        ),
        boxShadow: isCompleted
            ? const [
                BoxShadow(
                  color: Color(0xFF46A302),
                  offset: Offset(0, 1.2),
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCompleted) ...[
            const Icon(Icons.check_circle_rounded, size: 11, color: Color(0xFF46A302)),
            const SizedBox(width: 3),
          ],
          Text(
            isCompleted ? 'Đã hoàn thành' : 'Chưa ăn',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isCompleted ? const Color(0xFF46A302) : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroSummaryRow extends StatelessWidget {
  const _MacroSummaryRow({
    required this.totalCalories,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
  });

  final int totalCalories;
  final int totalCarbs;
  final int totalProtein;
  final int totalFat;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$totalCalories kcal',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
                letterSpacing: AppValues.calorieLetterSpacing,
              ),
        ),
        Text(
          '  •  ',
          style: TextStyle(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
            children: [
              const TextSpan(
                text: 'C ',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '${totalCarbs}g  ',
                style: const TextStyle(color: AppColors.onSurface),
              ),
              const TextSpan(
                text: 'P ',
                style: TextStyle(color: AppColors.tertiary, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '${totalProtein}g  ',
                style: const TextStyle(color: AppColors.onSurface),
              ),
              const TextSpan(
                text: 'F ',
                style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '${totalFat}g',
                style: const TextStyle(color: AppColors.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuggestedCaloriesRow extends StatelessWidget {
  const _SuggestedCaloriesRow({required this.suggestedCalories});

  final int suggestedCalories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chưa có món ăn nào',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: 1),
        Row(
          children: [
            Text(
              '0 kcal',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: AppValues.calorieLetterSpacing,
                  ),
            ),
            Text(
              ' / $suggestedCalories kcal gợi ý',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClayMealBadge extends StatelessWidget {
  const _ClayMealBadge({required this.mealType});

  final MealType mealType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: mealType.gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: mealType.bevelColor,
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
          BoxShadow(
            color: mealType.gradientColors[1].withValues(alpha: 0.35),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: ClayMorphIcon(
        icon: mealType.icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
