import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/recipes/domain/entities/recipe.dart';
import 'package:astrobite/features/recipes/domain/entities/recipe_ingredient.dart';
import 'package:astrobite/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:astrobite/features/recipes/presentation/controllers/recipe_builder_controller.dart';

void main() {
  group('RecipeBuilderController', () {
    late RecipeBuilderController sut;

    setUp(() => sut = RecipeBuilderController());

    test('initial state is valid empty state', () {
      expect(sut.state.name, '');
      expect(sut.state.ingredients, isEmpty);
      expect(sut.state.isValid, isFalse);
    });

    test('setName updates state and clears error', () {
      sut.state = sut.state.copyWith(error: 'some error');
      sut.setName('Salad Ức Gà');
      expect(sut.state.name, 'Salad Ức Gà');
      expect(sut.state.error, isNull);
    });

    group('isValid', () {
      test('returns false when name is empty', () {
        sut.addIngredient(_ingredient());
        expect(sut.state.isValid, isFalse);
      });

      test('returns false when no ingredients', () {
        sut.setName('Recipe');
        expect(sut.state.isValid, isFalse);
      });

      test('returns true when name and at least 1 ingredient', () {
        sut.setName('Salad');
        sut.addIngredient(_ingredient());
        expect(sut.state.isValid, isTrue);
      });
    });

    group('macro aggregation — US-01 Scenario 1.1 exact values', () {
      test('totalCalories sums all ingredients', () {
        sut.addIngredient(_ingredient(calories: 247.5));
        sut.addIngredient(_ingredient(calories: 120.0));
        expect(sut.state.totalCalories, closeTo(367.5, 0.01));
      });

      test('totalCarbs sums correctly', () {
        sut.addIngredient(_ingredient(carbs: 0.0));
        sut.addIngredient(_ingredient(carbs: 21.3));
        expect(sut.state.totalCarbs, closeTo(21.3, 0.01));
      });

      test('totalProtein sums correctly', () {
        sut.addIngredient(_ingredient(protein: 46.5));
        sut.addIngredient(_ingredient(protein: 4.4));
        expect(sut.state.totalProtein, closeTo(50.9, 0.01));
      });

      test('totalFat sums correctly', () {
        sut.addIngredient(_ingredient(fat: 5.4));
        sut.addIngredient(_ingredient(fat: 1.9));
        expect(sut.state.totalFat, closeTo(7.3, 0.01));
      });
    });

    test('addIngredient appends to list', () {
      sut.addIngredient(_ingredient());
      sut.addIngredient(_ingredient());
      expect(sut.state.ingredients.length, 2);
    });

    test('removeIngredient removes by index', () {
      sut.addIngredient(_ingredient(name: 'A'));
      sut.addIngredient(_ingredient(name: 'B'));
      sut.removeIngredient(0);
      expect(sut.state.ingredients.length, 1);
      expect(sut.state.ingredients.first.name, 'B');
    });

    test('updateIngredient replaces item at index', () {
      sut.addIngredient(_ingredient(name: 'Old'));
      sut.updateIngredient(0, _ingredient(name: 'New'));
      expect(sut.state.ingredients.first.name, 'New');
    });

    test('save returns null and sets error when invalid', () async {
      final result = await sut.save(
        userId: 'user123',
        repo: _FakeRecipeRepository(),
      );
      expect(result, isNull);
      expect(sut.state.error, isNotNull);
    });
  });

  // ── Dynamic Portion Scaler (US-02) unit logic ──────────────────────────────
  group('Portion scaling', () {
    test('2x scalar doubles all values', () {
      const base = _NutritionValues(
        calories: 367.5,
        carbs: 21.3,
        protein: 50.9,
        fat: 7.3,
      );
      const scaled = _NutritionValues(
        calories: 367.5 * 2,
        carbs: 21.3 * 2,
        protein: 50.9 * 2,
        fat: 7.3 * 2,
      );
      expect(base.scale(2), scaled);
    });

    test('0.5x scalar halves all values', () {
      const base = _NutritionValues(
        calories: 367.5,
        carbs: 21.3,
        protein: 50.9,
        fat: 7.3,
      );
      final scaled = base.scale(0.5);
      expect(scaled.calories, closeTo(183.75, 0.01));
    });
  });
}

// ── Test helpers ──────────────────────────────────────────────────────────────

RecipeIngredient _ingredient({
  String name = 'Test',
  double calories = 100,
  double carbs = 10,
  double protein = 10,
  double fat = 5,
}) {
  return RecipeIngredient(
    foodId: 'test_id',
    name: name,
    amountGrams: 100,
    calories: calories,
    carbs: carbs,
    protein: protein,
    fat: fat,
  );
}

class _FakeRecipeRepository implements RecipeRepository {
  @override
  Future<List<Recipe>> getRecipes(String userId) async => [];

  @override
  Future<Recipe> saveRecipe(Recipe recipe) async => recipe;
}

// Simple value object for portion scaler math tests
class _NutritionValues {
  const _NutritionValues({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  final double calories;
  final double carbs;
  final double protein;
  final double fat;

  _NutritionValues scale(double factor) => _NutritionValues(
        calories: calories * factor,
        carbs: carbs * factor,
        protein: protein * factor,
        fat: fat * factor,
      );

  @override
  bool operator ==(Object other) =>
      other is _NutritionValues &&
      (calories - other.calories).abs() < 0.01 &&
      (carbs - other.carbs).abs() < 0.01 &&
      (protein - other.protein).abs() < 0.01 &&
      (fat - other.fat).abs() < 0.01;

  @override
  int get hashCode => Object.hash(calories, carbs, protein, fat);
}
