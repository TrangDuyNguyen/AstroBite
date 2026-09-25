import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../recipes_providers.dart';

// ── Recipes list provider ─────────────────────────────────────────────────────

/// Loads and caches the user's saved recipes.
final recipesProvider =
    FutureProvider.autoDispose.family<List<Recipe>, String>((ref, userId) {
  return ref.read(recipeRepositoryProvider).getRecipes(userId);
});

// ── Recipe Builder Controller ─────────────────────────────────────────────────

/// Transient state for the Recipe Builder screen.
/// Holds the WIP recipe being composed — name, description, ingredients.
class RecipeBuilderState {
  const RecipeBuilderState({
    this.name = '',
    this.description = '',
    this.servings = 1,
    this.ingredients = const [],
    this.isSaving = false,
    this.error,
  });

  final String name;
  final String description;
  final int servings;
  final List<RecipeIngredient> ingredients;
  final bool isSaving;
  final String? error;

  /// Aggregated totals across all ingredients (1 serving).
  double get totalCalories =>
      ingredients.fold(0, (sum, i) => sum + i.calories);
  double get totalCarbs => ingredients.fold(0, (sum, i) => sum + i.carbs);
  double get totalProtein => ingredients.fold(0, (sum, i) => sum + i.protein);
  double get totalFat => ingredients.fold(0, (sum, i) => sum + i.fat);

  bool get isValid => name.trim().isNotEmpty && ingredients.isNotEmpty;

  RecipeBuilderState copyWith({
    String? name,
    String? description,
    int? servings,
    List<RecipeIngredient>? ingredients,
    bool? isSaving,
    Object? error = _sentinel,
  }) {
    return RecipeBuilderState(
      name: name ?? this.name,
      description: description ?? this.description,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      isSaving: isSaving ?? this.isSaving,
      error: error == _sentinel ? this.error : error as String?,
    );
  }
}

const _sentinel = Object();

final recipeBuilderProvider =
    StateNotifierProvider.autoDispose<RecipeBuilderController, RecipeBuilderState>(
  (_) => RecipeBuilderController(),
);

class RecipeBuilderController extends StateNotifier<RecipeBuilderState> {
  RecipeBuilderController() : super(const RecipeBuilderState());

  void setName(String value) => state = state.copyWith(name: value, error: null);

  void setDescription(String value) =>
      state = state.copyWith(description: value);

  void setServings(int value) => state = state.copyWith(servings: value);

  void addIngredient(RecipeIngredient ingredient) {
    state = state.copyWith(
      ingredients: [...state.ingredients, ingredient],
      error: null,
    );
  }

  void removeIngredient(int index) {
    final updated = [...state.ingredients]..removeAt(index);
    state = state.copyWith(ingredients: updated);
  }

  void updateIngredient(int index, RecipeIngredient updated) {
    final list = [...state.ingredients]..[index] = updated;
    state = state.copyWith(ingredients: list);
  }

  /// Saves the current WIP recipe to Firestore via [repo].
  /// Returns the saved [Recipe] on success, null on validation failure.
  Future<Recipe?> save({
    required String userId,
    required RecipeRepository repo,
  }) async {
    if (!state.isValid) {
      state = state.copyWith(
        error: 'Vui lòng nhập tên công thức và ít nhất 1 nguyên liệu!',
      );
      return null;
    }

    state = state.copyWith(isSaving: true, error: null);

    final now = DateTime.now().toUtc();
    final recipe = Recipe(
      id: '',
      userId: userId,
      name: state.name.trim(),
      description: state.description.trim().isEmpty ? null : state.description.trim(),
      servings: state.servings,
      ingredients: state.ingredients,
      totalCalories: state.totalCalories,
      totalCarbs: state.totalCarbs,
      totalProtein: state.totalProtein,
      totalFat: state.totalFat,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final saved = await repo.saveRecipe(recipe);
      state = const RecipeBuilderState(); // reset on success
      return saved;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Không thể lưu công thức. Vui lòng thử lại.',
      );
      return null;
    }
  }
}
