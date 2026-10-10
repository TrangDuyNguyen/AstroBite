import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/profile_enums.dart';
import 'package:astrobite/core/utils/nutrition_calculator.dart';

void main() {
  group('NutritionCalculator', () {
    group('calculateBMR', () {
      test('calculates male BMR correctly', () {
        // Male, 65kg, 170cm, 30 years old
        // BMR = 10*65 + 6.25*170 - 5*30 + 5 = 650 + 1062.5 - 150 + 5 = 1567.5
        final bmr = NutritionCalculator.calculateBMR(
          weightKg: 65,
          heightCm: 170,
          age: 30,
          gender: 'male',
        );
        expect(bmr, 1567.5);
      });

      test('calculates female BMR correctly', () {
        // Female, 55kg, 160cm, 25 years old
        // BMR = 10*55 + 6.25*160 - 5*25 - 161 = 550 + 1000 - 125 - 161 = 1264
        final bmr = NutritionCalculator.calculateBMR(
          weightKg: 55,
          heightCm: 160,
          age: 25,
          gender: 'female',
        );
        expect(bmr, 1264);
      });
    });

    group('calculateTDEE', () {
      test('sedentary multiplier is 1.2', () {
        final tdee = NutritionCalculator.calculateTDEE(
          bmr: 1500,
          activityLevel: 'sedentary',
        );
        expect(tdee, 1800);
      });

      test('moderate multiplier is 1.55', () {
        final tdee = NutritionCalculator.calculateTDEE(
          bmr: 1500,
          activityLevel: 'moderate',
        );
        expect(tdee, 2325);
      });

      test('unknown level defaults to sedentary', () {
        final tdee = NutritionCalculator.calculateTDEE(
          bmr: 1500,
          activityLevel: 'unknown',
        );
        expect(tdee, 1800);
      });
    });

    group('recalculateCalories', () {
      test('scales calories proportionally', () {
        // 260 cal for 200g → 130 cal for 100g
        final result = NutritionCalculator.recalculateCalories(
          originalCalories: 260,
          originalWeightG: 200,
          newWeightG: 100,
        );
        expect(result, 130);
      });

      test('returns 0 when original weight is 0', () {
        final result = NutritionCalculator.recalculateCalories(
          originalCalories: 260,
          originalWeightG: 0,
          newWeightG: 100,
        );
        expect(result, 0);
      });
    });

    group('calculateTargetCalories', () {
      test('calculates lose weight target (-500 kcal)', () {
        final target = NutritionCalculator.calculateTargetCalories(
          tdee: 2400,
          goal: 'lose_weight',
          gender: 'male',
        );
        expect(target, 1900);
      });

      test('applies male safety floor of 1500 kcal', () {
        final target = NutritionCalculator.calculateTargetCalories(
          tdee: 1800, // 1800 - 500 = 1300 < 1500
          goal: 'lose_weight',
          gender: 'male',
        );
        expect(target, 1500);
      });

      test('applies female safety floor of 1200 kcal', () {
        final target = NutritionCalculator.calculateTargetCalories(
          tdee: 1400, // 1400 - 500 = 900 < 1200
          goal: 'lose_weight',
          gender: 'female',
        );
        expect(target, 1200);
      });

      test('calculates gain weight target (+300 kcal)', () {
        final target = NutritionCalculator.calculateTargetCalories(
          tdee: 2200,
          goal: 'gain_weight',
          gender: 'male',
        );
        expect(target, 2500);
      });

      test('maintains weight target (= TDEE)', () {
        final target = NutritionCalculator.calculateTargetCalories(
          tdee: 2200,
          goal: 'maintain',
          gender: 'female',
        );
        expect(target, 2200);
      });
    });

    group('calculateMacros', () {
      test('calculates standard 45/30/25 macro split', () {
        // 2000 kcal:
        // Carbs: 2000 * 0.45 / 4 = 225g
        // Protein: 2000 * 0.30 / 4 = 150g
        // Fat: 2000 * 0.25 / 9 = 55.55... -> 56g
        final macros = NutritionCalculator.calculateMacros(2000);
        expect(macros.carbsG, 225);
        expect(macros.proteinG, 150);
        expect(macros.fatG, 56);
      });
    });

    group('Enhanced Enums O(1) Calculation', () {
      test('calculates BMR, TDEE, and Target Calories using typed Enums', () {
        final bmr = NutritionCalculator.calculateBMR(
          weightKg: 70,
          heightCm: 175,
          age: 28,
          gender: Gender.male,
        );
        expect(bmr, 1658.75);

        final tdee = NutritionCalculator.calculateTDEE(
          bmr: bmr,
          activityLevel: ActivityLevel.active,
        );
        expect(tdee, 1658.75 * 1.725);

        final target = NutritionCalculator.calculateTargetCalories(
          tdee: tdee,
          goal: FitnessGoal.loseWeight,
          gender: Gender.male,
        );
        expect(target, (tdee - 500).round());
      });
    });
  });
}
