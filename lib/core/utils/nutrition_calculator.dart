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
      'active' || 'very_active' => AppValues.activeMultiplier,
      'extreme' || 'extremely_active' => AppValues.extremeMultiplier,
      _           => AppValues.sedentaryMultiplier,
    };
    return bmr * multiplier;
  }

  /// Calculates Daily Target Calories with safety floor.
  /// Goal: 'lose_weight' (-500 kcal), 'gain_weight' (+300 kcal), 'maintain' (0).
  /// Safety floor: Male >= 1500 kcal, Female >= 1200 kcal.
  static int calculateTargetCalories({
    required double tdee,
    required String goal,
    required String gender,
  }) {
    double target = switch (goal) {
      'lose_weight' => tdee - 500,
      'gain_weight' => tdee + 300,
      _ => tdee,
    };

    final safetyFloor = gender == 'female' ? 1200.0 : 1500.0;
    if (target < safetyFloor) {
      target = safetyFloor;
    }
    return target.round();
  }

  /// Returns Macro distribution in grams for a given calorie target.
  /// Standard split: 45% Carbs, 30% Protein, 25% Fat.
  static ({int carbsG, int proteinG, int fatG}) calculateMacros(int totalCalories) {
    final carbs = (totalCalories * 0.45 / 4).round();
    final protein = (totalCalories * 0.30 / 4).round();
    final fat = (totalCalories * 0.25 / 9).round();
    return (carbsG: carbs, proteinG: protein, fatG: fat);
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
