import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/recipes/domain/entities/recipe.dart';
import 'package:astrobite/features/recipes/domain/entities/recipe_ingredient.dart';
import 'package:astrobite/features/recipes/domain/entities/meal_plan_item.dart';

void main() {
  group('Recipe Ingredient Entity Tests', () {
    test('instantiates and serializes RecipeIngredient correctly', () {
      const ingredient = RecipeIngredient(
        foodId: 'food-001',
        name: 'Ức gà áp chảo',
        amountGrams: 150.0,
        calories: 247.5,
        carbs: 0.0,
        protein: 46.5,
        fat: 5.4,
      );

      final json = ingredient.toJson();
      expect(json['foodId'], equals('food-001'));
      expect(json['name'], equals('Ức gà áp chảo'));
      expect(json['amountGrams'], equals(150.0));
      expect(json['calories'], equals(247.5));
      expect(json['carbs'], equals(0.0));
      expect(json['protein'], equals(46.5));
      expect(json['fat'], equals(5.4));

      final restored = RecipeIngredient.fromJson(json);
      expect(restored, equals(ingredient));
    });
  });

  group('Recipe Entity Tests', () {
    test('instantiates and serializes Recipe correctly', () {
      final now = DateTime(2026, 9, 25, 20, 0, 0);
      final recipe = Recipe(
        id: 'recipe-001',
        userId: 'user-777',
        name: 'Salad Ức Gà Quinoa',
        description: 'Bữa ăn eat-clean giàu đạm',
        servings: 2,
        ingredients: const [
          RecipeIngredient(
            foodId: 'food-001',
            name: 'Ức gà áp chảo',
            amountGrams: 150.0,
            calories: 247.5,
            carbs: 0.0,
            protein: 46.5,
            fat: 5.4,
          ),
        ],
        totalCalories: 247.5,
        totalCarbs: 0.0,
        totalProtein: 46.5,
        totalFat: 5.4,
        createdAt: now,
        updatedAt: now,
      );

      final json = recipe.toJson();
      expect(json['id'], equals('recipe-001'));
      expect(json['userId'], equals('user-777'));
      expect(json['name'], equals('Salad Ức Gà Quinoa'));
      expect(json['servings'], equals(2));
      expect((json['ingredients'] as List).length, equals(1));

      final restored = Recipe.fromJson(json);
      expect(restored.id, equals(recipe.id));
      expect(restored.name, equals(recipe.name));
      expect(restored.totalCalories, equals(recipe.totalCalories));
    });
  });

  group('MealPlanItem Entity Tests', () {
    test('instantiates and serializes MealPlanItem correctly', () {
      const item = MealPlanItem(
        id: 'plan-001',
        userId: 'user-777',
        date: '2026-09-26',
        mealType: 'lunch',
        recipeId: 'recipe-001',
        foodName: 'Salad Ức Gà Quinoa',
        calories: 367.5,
        carbs: 21.3,
        protein: 50.9,
        fat: 7.3,
        isLogged: false,
      );

      final json = item.toJson();
      expect(json['id'], equals('plan-001'));
      expect(json['mealType'], equals('lunch'));
      expect(json['date'], equals('2026-09-26'));
      expect(json['isLogged'], isFalse);

      final restored = MealPlanItem.fromJson(json);
      expect(restored, equals(item));
      expect(restored.calories, equals(367.5));
    });
  });
}
