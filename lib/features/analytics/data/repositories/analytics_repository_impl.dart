import 'package:astrobite/features/tracker/data/repositories/food_log_repository_impl.dart';
import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_remote_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl({
    AnalyticsRemoteDatasource? remoteDatasource,
    FoodLogRepository? foodLogRepository,
  })  : _remoteDatasource = remoteDatasource ?? AnalyticsRemoteDatasource(),
        _foodLogRepository = foodLogRepository ?? FoodLogRepositoryImpl();

  final AnalyticsRemoteDatasource _remoteDatasource;
  final FoodLogRepository _foodLogRepository;

  @override
  Future<Map<String, int>> getDailyCalorieTotals({
    required String userId,
    required String startDate,
    required String endDate,
  }) {
    return _remoteDatasource.getDailyCalorieTotals(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      defaultRepo: _foodLogRepository,
    );
  }
}
