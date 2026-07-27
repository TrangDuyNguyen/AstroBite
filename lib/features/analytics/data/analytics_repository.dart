import 'package:astrobite/features/tracker/data/food_log_repository.dart';

class AnalyticsRepository {
  AnalyticsRepository({FoodLogRepository? foodLogRepository})
      : _foodLogRepository = foodLogRepository ?? FoodLogRepository();

  final FoodLogRepository _foodLogRepository;

  Future<Map<String, int>> getDailyCalorieTotals({
    required String userId,
    required String startDate,
    required String endDate,
  }) async {
    final logs = await _foodLogRepository.getLogsForDateRange(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );

    final totals = <String, int>{};
    for (final log in logs) {
      totals[log.date] = (totals[log.date] ?? 0) + log.calories;
    }
    return totals;
  }
}
