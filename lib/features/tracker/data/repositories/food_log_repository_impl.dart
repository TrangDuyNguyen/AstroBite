import '../../domain/repositories/food_log_repository.dart';
import '../datasources/food_log_remote_datasource.dart';
import '../models/food_log_dto.dart';

class FoodLogRepositoryImpl implements FoodLogRepository {
  FoodLogRepositoryImpl({FoodLogRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? FoodLogRemoteDatasource();

  final FoodLogRemoteDatasource _remoteDatasource;

  @override
  Stream<List<FoodLogDto>> watchDailyLogs({
    required String userId,
    required String date,
  }) {
    return _remoteDatasource.watchDailyLogs(userId: userId, date: date);
  }

  @override
  Future<void> addFoodLog({
    required String userId,
    required FoodLogDto log,
  }) {
    return _remoteDatasource.addFoodLog(userId: userId, log: log);
  }

  @override
  Future<void> deleteFoodLog({
    required String userId,
    required String logId,
  }) {
    return _remoteDatasource.deleteFoodLog(userId: userId, logId: logId);
  }

  @override
  Future<List<FoodLogDto>> getLogsForDateRange({
    required String userId,
    required String startDate,
    required String endDate,
  }) {
    return _remoteDatasource.getLogsForDateRange(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
