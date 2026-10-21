import '../entities/water_log.dart';

/// Abstract contract for daily water consumption repository
abstract class WaterRepository {
  /// Watches daily water intake with immediate local cache and live updates
  Stream<WaterDayLog> watchDailyWater({
    required String userId,
    required String date,
    int defaultTargetMl = 2000,
  });

  /// Retrieves daily water intake snapshot
  Future<WaterDayLog> getDailyWater({
    required String userId,
    required String date,
    int defaultTargetMl = 2000,
  });

  /// Logs a new water consumption amount and returns the updated day log
  Future<WaterDayLog> logWater({
    required String userId,
    required String date,
    required int amountMl,
    int defaultTargetMl = 2000,
    String? note,
  });

  /// Updates target daily water intake
  Future<void> updateDailyTarget({
    required String userId,
    required String date,
    required int targetMl,
  });
}
