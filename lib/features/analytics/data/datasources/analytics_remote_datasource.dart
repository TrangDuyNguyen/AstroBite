import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';

class AnalyticsRemoteDatasource {
  AnalyticsRemoteDatasource({FoodLogRepository? foodLogRepository})
      : _foodLogRepository = foodLogRepository;

  final FoodLogRepository? _foodLogRepository;

  Future<Map<String, int>> getDailyCalorieTotals({
    required String userId,
    required String startDate,
    required String endDate,
    required FoodLogRepository defaultRepo,
  }) async {
    final repo = _foodLogRepository ?? defaultRepo;
    final logs = await repo.getLogsForDateRange(
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
