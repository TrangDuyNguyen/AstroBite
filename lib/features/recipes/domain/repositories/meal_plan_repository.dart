import '../entities/meal_plan_item.dart';

/// Pure Dart interface for meal planning operations.
abstract class MealPlanRepository {
  /// Returns all meal plan items for [userId] on [date] (YYYY-MM-DD).
  Future<List<MealPlanItem>> getMealPlanItems(String userId, String date);

  /// Saves a new meal plan item.
  Future<MealPlanItem> saveMealPlanItem(MealPlanItem item);

  /// Marks a meal plan item as logged.
  Future<void> markAsLoggedForUser(String userId, String itemId);

  /// Deletes a meal plan item for a user.
  Future<void> deleteMealPlanItemForUser(String userId, String itemId);
}
