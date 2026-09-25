import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan_item.freezed.dart';
part 'meal_plan_item.g.dart';

/// Domain entity representing a meal slot on the weekly planner calendar.
/// [recipeId] is optional — a slot may hold a free-text food without a saved recipe.
@freezed
abstract class MealPlanItem with _$MealPlanItem {
  const factory MealPlanItem({
    required String id,
    required String userId,
    /// ISO date string: YYYY-MM-DD
    required String date,
    /// breakfast | lunch | dinner | snack
    required String mealType,
    String? recipeId,
    required String foodName,
    required double calories,
    required double carbs,
    required double protein,
    required double fat,
    @Default(false) bool isLogged,
  }) = _MealPlanItem;

  factory MealPlanItem.fromJson(Map<String, dynamic> json) =>
      _$MealPlanItemFromJson(json);
}
