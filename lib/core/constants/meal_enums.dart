import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';

/// Enhanced Enums for Meal Types in AstroBite.
/// Provides O(1) metadata access for icons, labels, colors, and calorie budgeting.
enum MealType {
  breakfast(
    value: 'breakfast',
    label: 'Bữa sáng',
    icon: Icons.wb_twilight_rounded,
    color: AppColors.tertiary,
    clayBgColor: AppColors.clayBreakfast,
    gradientColors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
    bevelColor: Color(0xFFE65100),
    calorieRatio: 0.25,
    startHour: 5,
    endHour: 11,
  ),
  lunch(
    value: 'lunch',
    label: 'Bữa trưa',
    icon: Icons.wb_sunny_rounded,
    color: Color(0xFFFFB300),
    clayBgColor: AppColors.clayLunch,
    gradientColors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
    bevelColor: Color(0xFFE68900),
    calorieRatio: 0.35,
    startHour: 11,
    endHour: 16,
  ),
  dinner(
    value: 'dinner',
    label: 'Bữa tối',
    icon: Icons.nightlight_round,
    color: Color(0xFF90CAF9),
    clayBgColor: AppColors.clayDinner,
    gradientColors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
    bevelColor: Color(0xFF3949AB),
    calorieRatio: 0.30,
    startHour: 16,
    endHour: 21,
  ),
  snack(
    value: 'snack',
    label: 'Bữa phụ',
    icon: Icons.apple_rounded,
    color: AppColors.secondary,
    clayBgColor: AppColors.claySnack,
    gradientColors: [Color(0xFFFF8A80), Color(0xFFFF5252)],
    bevelColor: Color(0xFFD32F2F),
    calorieRatio: 0.10,
    startHour: 21,
    endHour: 5,
  );

  const MealType({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.clayBgColor,
    required this.gradientColors,
    required this.bevelColor,
    required this.calorieRatio,
    required this.startHour,
    required this.endHour,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color clayBgColor;
  final List<Color> gradientColors;
  final Color bevelColor;
  final double calorieRatio;
  final int startHour;
  final int endHour;

  int calculateSuggestedCalories(int targetCalories) =>
      (targetCalories * calorieRatio).round();

  String localizedLabel(BuildContext context) {
    return switch (this) {
      MealType.breakfast => context.l10n.breakfast,
      MealType.lunch => context.l10n.lunch,
      MealType.dinner => context.l10n.dinner,
      MealType.snack => context.l10n.snack,
    };
  }

  static MealType fromValue(String? value) {
    if (value == null) return MealType.breakfast;
    for (final m in MealType.values) {
      if (m.value == value) return m;
    }
    return MealType.breakfast;
  }

  static MealType fromCurrentHour([DateTime? dateTime]) {
    final hour = (dateTime ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 11) return MealType.breakfast;
    if (hour >= 11 && hour < 16) return MealType.lunch;
    if (hour >= 16 && hour < 21) return MealType.dinner;
    return MealType.snack;
  }
}

/// Enhanced Enums for Macronutrients in AstroBite.
enum NutrientType {
  carbs(
    key: 'carbs',
    label: 'Tinh bột',
    shortLabel: 'C',
    color: AppColors.primary,
    caloriesPerGram: 4,
  ),
  protein(
    key: 'protein',
    label: 'Chất đạm',
    shortLabel: 'P',
    color: AppColors.tertiary,
    caloriesPerGram: 4,
  ),
  fat(
    key: 'fat',
    label: 'Chất béo',
    shortLabel: 'F',
    color: AppColors.secondary,
    caloriesPerGram: 9,
  );

  const NutrientType({
    required this.key,
    required this.label,
    required this.shortLabel,
    required this.color,
    required this.caloriesPerGram,
  });

  final String key;
  final String label;
  final String shortLabel;
  final Color color;
  final int caloriesPerGram;

  String localizedLabel(BuildContext context) {
    return switch (this) {
      NutrientType.carbs => context.l10n.carbs,
      NutrientType.protein => context.l10n.protein,
      NutrientType.fat => context.l10n.fat,
    };
  }

  static NutrientType fromKey(String? key) {
    if (key == null) return NutrientType.carbs;
    for (final n in NutrientType.values) {
      if (n.key == key) return n;
    }
    return NutrientType.carbs;
  }
}
