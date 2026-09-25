import '../entities/recipe.dart';

/// Pure Dart interface — no Firebase imports here.
abstract class RecipeRepository {
  /// Returns all recipes owned by [userId], ordered by [createdAt] DESC.
  Future<List<Recipe>> getRecipes(String userId);

  /// Saves a new recipe. Returns the saved entity with server-assigned timestamps.
  Future<Recipe> saveRecipe(Recipe recipe);
}
