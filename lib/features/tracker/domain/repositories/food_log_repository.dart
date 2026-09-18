import '../../data/models/food_log_dto.dart';

abstract class FoodLogRepository {
  Stream<List<FoodLogDto>> watchDailyLogs({
    required String userId,
    required String date,
  });

  Future<void> addFoodLog({
    required String userId,
    required FoodLogDto log,
  });

  Future<void> deleteFoodLog({
    required String userId,
    required String logId,
  });

  Future<List<FoodLogDto>> getLogsForDateRange({
    required String userId,
    required String startDate,
    required String endDate,
  });

  Future<int> syncPendingLogs({required String userId});

  Future<List<FoodLogDto>> getPendingSyncLogs({required String userId});
}
