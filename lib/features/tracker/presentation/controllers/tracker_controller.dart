import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/food_log_dto.dart';
import '../../domain/entities/food_log.dart';
import '../../domain/tracker_providers.dart';

import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';

final trackerControllerProvider =
    StateNotifierProvider.autoDispose<TrackerController, AsyncValue<void>>((ref) {
  return TrackerController(ref);
});

class TrackerController extends StateNotifier<AsyncValue<void>> {
  TrackerController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> addFoodLog({
    required String userId,
    required FoodLogDto log,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _ref.read(foodLogRepositoryProvider).addFoodLog(
            userId: userId,
            log: log,
          );
      await _ref.read(streakNotifierProvider.notifier).recordMeal(
            date: DateTime.tryParse(log.date),
          );
    });
  }

  Future<void> deleteFoodLog({
    required String userId,
    required String logId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _ref.read(foodLogRepositoryProvider).deleteFoodLog(
            userId: userId,
            logId: logId,
          );
    });
  }

  Future<void> migrateMealLogs({
    required String userId,
    required List<FoodLog> logsToMigrate,
    required String targetMealType,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = _ref.read(foodLogRepositoryProvider);
      for (final log in logsToMigrate) {
        final updatedDto = FoodLogDto(
          id: log.id,
          date: log.date,
          mealType: targetMealType,
          dishName: log.dishName,
          estimatedWeightG: log.estimatedWeightG,
          calories: log.calories,
          proteinG: log.proteinG,
          carbsG: log.carbsG,
          fatG: log.fatG,
          source: log.source,
          confidenceScore: log.confidenceScore,
          imageUrl: log.imageUrl,
          sodiumMg: log.sodiumMg,
          fiberG: log.fiberG,
          sugarG: log.sugarG,
          syncStatus: log.syncStatus,
          dishes: log.dishes,
        );
        await repo.addFoodLog(userId: userId, log: updatedDto);
      }
    });
  }

  Future<void> deleteMealLogs({
    required String userId,
    required List<FoodLog> logsToDelete,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = _ref.read(foodLogRepositoryProvider);
      for (final log in logsToDelete) {
        await repo.deleteFoodLog(userId: userId, logId: log.id);
      }
    });
  }

  Future<int> syncPendingLogs({required String userId}) =>
      _ref.read(foodLogRepositoryProvider).syncPendingLogs(userId: userId);
}
