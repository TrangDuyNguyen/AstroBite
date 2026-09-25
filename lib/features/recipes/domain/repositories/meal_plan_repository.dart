import '../entities/meal_plan_item.dart';

/// Pure Dart interface for meal planning operations.
abstract class MealPlanRepository {
  /// Returns all meal plan items for [userId] on [date] (YYYY-MM-DD).
  Future<List<MealPlanItem>> getMealPlanItems(String userId, String date);

  /// Saves a new meal plan item.
  Future<MealPlanItem> saveMealPlanItem(MealPlanItem item);
}
