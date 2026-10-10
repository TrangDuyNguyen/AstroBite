import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';

void main() {
  group('MealType Enhanced Enum Tests', () {
    test('fromValue parses valid meal types correctly', () {
      expect(MealType.fromValue('breakfast'), MealType.breakfast);
      expect(MealType.fromValue('lunch'), MealType.lunch);
      expect(MealType.fromValue('dinner'), MealType.dinner);
      expect(MealType.fromValue('snack'), MealType.snack);
    });

    test('fromValue returns safe fallback for null or unknown input', () {
      expect(MealType.fromValue(null), MealType.breakfast);
      expect(MealType.fromValue('unknown_meal'), MealType.breakfast);
    });

    test('MealType properties and calorie calculation are exact', () {
      const targetCalories = 2000;

      expect(MealType.breakfast.calculateSuggestedCalories(targetCalories), 500);
      expect(MealType.lunch.calculateSuggestedCalories(targetCalories), 700);
      expect(MealType.dinner.calculateSuggestedCalories(targetCalories), 600);
      expect(MealType.snack.calculateSuggestedCalories(targetCalories), 200);

      expect(MealType.breakfast.icon, Icons.wb_twilight_rounded);
      expect(MealType.breakfast.color, AppColors.tertiary);
      expect(MealType.breakfast.clayBgColor, AppColors.clayBreakfast);

      expect(MealType.snack.icon, Icons.apple_rounded);
      expect(MealType.snack.color, AppColors.secondary);
      expect(MealType.snack.clayBgColor, AppColors.claySnack);
    });

    test('fromCurrentHour resolves meal based on hour correctly', () {
      expect(MealType.fromCurrentHour(DateTime(2026, 10, 10, 7)), MealType.breakfast);
      expect(MealType.fromCurrentHour(DateTime(2026, 10, 10, 12)), MealType.lunch);
      expect(MealType.fromCurrentHour(DateTime(2026, 10, 10, 18)), MealType.dinner);
      expect(MealType.fromCurrentHour(DateTime(2026, 10, 10, 22)), MealType.snack);
      expect(MealType.fromCurrentHour(DateTime(2026, 10, 10, 2)), MealType.snack);
    });
  });

  group('NutrientType Enhanced Enum Tests', () {
    test('fromKey parses nutrient types correctly', () {
      expect(NutrientType.fromKey('carbs'), NutrientType.carbs);
      expect(NutrientType.fromKey('protein'), NutrientType.protein);
      expect(NutrientType.fromKey('fat'), NutrientType.fat);
      expect(NutrientType.fromKey(null), NutrientType.carbs);
      expect(NutrientType.fromKey('unknown'), NutrientType.carbs);
    });

    test('NutrientType properties are exact', () {
      expect(NutrientType.carbs.shortLabel, 'C');
      expect(NutrientType.carbs.caloriesPerGram, 4);
      expect(NutrientType.carbs.color, AppColors.primary);

      expect(NutrientType.protein.shortLabel, 'P');
      expect(NutrientType.protein.caloriesPerGram, 4);
      expect(NutrientType.protein.color, AppColors.tertiary);

      expect(NutrientType.fat.shortLabel, 'F');
      expect(NutrientType.fat.caloriesPerGram, 9);
      expect(NutrientType.fat.color, AppColors.secondary);
    });
  });

  group('FoodLog mealTypeEnum integration', () {
    test('FoodLog returns correct MealType enum via getter', () {
      const log = FoodLog(
        id: '1',
        date: '2026-10-10',
        mealType: 'lunch',
        dishName: 'Cơm tấm',
        estimatedWeightG: 250,
        calories: 650,
        proteinG: 30,
        carbsG: 80,
        fatG: 22,
        source: 'manual_entry',
      );

      expect(log.mealTypeEnum, MealType.lunch);
      expect(log.mealTypeEnum.label, 'Bữa trưa');
    });
  });
}
