abstract class AnalyticsRepository {
  Future<Map<String, int>> getDailyCalorieTotals({
    required String userId,
    required String startDate,
    required String endDate,
  });
}
