import 'package:flutter_test/flutter_test.dart';
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
  });
}
