import 'package:astrobite/core/constants/profile_enums.dart';

/// Calculates BMR (Mifflin-St Jeor) and TDEE.
/// Implements O(1) pure functions with zero side-effects.
class NutritionCalculator {
  const NutritionCalculator._();

  /// Mifflin-St Jeor BMR formula (O(1) Pure Function).
  /// Male:   10 × weight(kg) + 6.25 × height(cm) - 5 × age + 5
  /// Female: 10 × weight(kg) + 6.25 × height(cm) - 5 × age - 161
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required dynamic gender,
  }) {
    final g = gender is Gender ? gender : Gender.fromValue(gender as String?);
    return 10 * weightKg + 6.25 * heightCm - 5 * age + g.bmrOffset;
  }

  /// TDEE = BMR × activity multiplier (O(1) Pure Function).
  static double calculateTDEE({
    required double bmr,
    required dynamic activityLevel,
  }) {
    final level = activityLevel is ActivityLevel
        ? activityLevel
        : ActivityLevel.fromValue(activityLevel as String?);
    return bmr * level.multiplier;
  }

  /// Calculates Daily Target Calories with safety floor (O(1) Pure Function).
  /// Goal: 'lose_weight' (-500 kcal), 'gain_weight' (+300 kcal), 'maintain' (0).
  /// Safety floor: Male >= 1500 kcal, Female >= 1200 kcal.
  static int calculateTargetCalories({
    required double tdee,
    required dynamic goal,
    required dynamic gender,
  }) {
    final g = goal is FitnessGoal ? goal : FitnessGoal.fromValue(goal as String?);
    final gen = gender is Gender ? gender : Gender.fromValue(gender as String?);

    double target = tdee + g.calorieOffset;
    if (target < gen.safetyFloor) {
      target = gen.safetyFloor;
    }
    return target.round();
  }

  /// Returns Macro distribution in grams for a given calorie target (O(1) Pure Function).
  /// Standard split: 45% Carbs, 30% Protein, 25% Fat.
  static ({int carbsG, int proteinG, int fatG}) calculateMacros(int totalCalories) {
    final carbs = (totalCalories * 0.45 / 4).round();
    final protein = (totalCalories * 0.30 / 4).round();
    final fat = (totalCalories * 0.25 / 9).round();
    return (carbsG: carbs, proteinG: protein, fatG: fat);
  }

  /// Recalculate calories for a food item when weight changes.
  /// Uses proportional scaling from original weight (O(1) Pure Function).
  static int recalculateCalories({
    required int originalCalories,
    required int originalWeightG,
    required int newWeightG,
  }) {
    if (originalWeightG <= 0) return 0;
    return (originalCalories * newWeightG / originalWeightG).round();
  }
}
