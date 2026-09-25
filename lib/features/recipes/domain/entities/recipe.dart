import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipe_ingredient.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

/// Domain entity representing a user-created recipe.
/// totalCalories/Carbs/Protein/Fat are aggregated from [ingredients].
@freezed
abstract class Recipe with _$Recipe {
  @JsonSerializable(explicitToJson: true)
  const factory Recipe({
    required String id,
    required String userId,
    required String name,
    String? description,
    @Default(1) int servings,
    required List<RecipeIngredient> ingredients,
    required double totalCalories,
    required double totalCarbs,
    required double totalProtein,
    required double totalFat,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
