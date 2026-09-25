import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/meal_plan_item.dart';
import '../../data/repositories/meal_plan_repository_impl.dart';
import '../../recipes_providers.dart';
import '../../../tracker/domain/tracker_providers.dart';
import '../../../tracker/data/models/food_log_dto.dart';

// ── Selected date provider ────────────────────────────────────────────────────

/// ISO date string (YYYY-MM-DD) currently visible on the Meal Planner calendar.
/// Defaults to today.
final selectedPlanDateProvider = StateProvider<String>(
  (_) => _todayIso(),
);

String _todayIso() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

// ── Meal Plan Items provider ──────────────────────────────────────────────────

typedef _DateUserKey = ({String userId, String date});

final mealPlanItemsProvider =
    FutureProvider.autoDispose.family<List<MealPlanItem>, _DateUserKey>(
  (ref, key) =>
      ref.read(mealPlanRepositoryProvider).getMealPlanItems(key.userId, key.date),
);

// ── Meal Plan Controller ──────────────────────────────────────────────────────

final mealPlanControllerProvider =
    StateNotifierProvider.autoDispose<MealPlanController, AsyncValue<void>>(
  (ref) => MealPlanController(ref),
);

class MealPlanController extends StateNotifier<AsyncValue<void>> {
  MealPlanController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  /// Resolves the concrete [MealPlanRepositoryImpl] from the abstract provider.
  MealPlanRepositoryImpl get _repo =>
      _ref.read(mealPlanRepositoryProvider) as MealPlanRepositoryImpl;

  /// Adds a new meal plan slot.
  Future<MealPlanItem?> addItem({
    required String userId,
    required MealPlanItem item,
  }) async {
    state = const AsyncLoading();
    MealPlanItem? saved;
    state = await AsyncValue.guard(() async {
      saved = await _repo.saveMealPlanItem(item);
      _ref.invalidate(mealPlanItemsProvider);
    });
    return saved;
  }

  /// Marks [item] as logged AND writes a corresponding FoodLog entry.
  /// Implements US-04 1-Tap Log to Diary (target <= 500ms total).
  Future<void> logMealToDiary({
    required String userId,
    required MealPlanItem item,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Mark plan item logged
      await _repo.markAsLoggedForUser(userId, item.id);

      // 2. Write FoodLog entry to existing tracker
      final log = FoodLogDto(
        id: 'plan_${item.id}',
        date: item.date,
        mealType: item.mealType,
        dishName: item.foodName,
        estimatedWeightG: 0,
        calories: item.calories.round(),
        proteinG: item.protein.round(),
        carbsG: item.carbs.round(),
        fatG: item.fat.round(),
        source: 'meal_plan',
        syncStatus: 'pending_sync',
      );
      await _ref.read(foodLogRepositoryProvider).addFoodLog(
            userId: userId,
            log: log,
          );

      _ref.invalidate(mealPlanItemsProvider);
    });
  }

  Future<void> deleteItem({
    required String userId,
    required String itemId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteMealPlanItemForUser(userId, itemId);
      _ref.invalidate(mealPlanItemsProvider);
    });
  }
}
