import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_ingredient.freezed.dart';
part 'recipe_ingredient.g.dart';

/// Value object representing a single ingredient in a recipe.
/// All macro values correspond to [amountGrams] weight.
@freezed
abstract class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    required String foodId,
    required String name,
    required double amountGrams,
    required double calories,
    required double carbs,
    required double protein,
    required double fat,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
}
