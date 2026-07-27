import 'package:astrobite/core/constants/app_values.dart';

/// Calculates BMR (Mifflin-St Jeor) and TDEE.
class NutritionCalculator {
  const NutritionCalculator._();

  /// Mifflin-St Jeor BMR formula.
  /// Male:   10 × weight(kg) + 6.25 × height(cm) - 5 × age + 5
  /// Female: 10 × weight(kg) + 6.25 × height(cm) - 5 × age - 161
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return gender == 'male' ? base + 5 : base - 161;
  }

  /// TDEE = BMR × activity multiplier.
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    final multiplier = switch (activityLevel) {
      'sedentary' => AppValues.sedentaryMultiplier,
      'light'     => AppValues.lightMultiplier,
      'moderate'  => AppValues.moderateMultiplier,
      'active'    => AppValues.activeMultiplier,
      _           => AppValues.sedentaryMultiplier,
    };
    return bmr * multiplier;
  }

  /// Recalculate calories for a food item when weight changes.
  /// Uses proportional scaling from original weight.
  static int recalculateCalories({
    required int originalCalories,
    required int originalWeightG,
    required int newWeightG,
  }) {
    if (originalWeightG <= 0) return 0;
    return (originalCalories * newWeightG / originalWeightG).round();
  }
}
