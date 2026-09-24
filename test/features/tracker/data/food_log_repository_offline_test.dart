import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/features/tracker/data/datasources/food_log_local_datasource.dart';
import 'package:astrobite/features/tracker/data/datasources/food_log_remote_datasource.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/data/repositories/food_log_repository_impl.dart';

class FakeRemoteDatasource implements FoodLogRemoteDatasource {
  bool shouldFail = false;
  final List<FoodLogDto> remoteStore = [];

  @override
  Future<void> addFoodLog({required String userId, required FoodLogDto log}) async {
    if (shouldFail) throw Exception('Network offline');
    remoteStore.add(log);
  }

  @override
  Stream<List<FoodLogDto>> watchDailyLogs({required String userId, required String date}) {
    if (shouldFail) throw Exception('Stream network failure');
    return Stream.value(remoteStore.where((l) => l.date == date).toList());
  }

  @override
  Future<void> deleteFoodLog({required String userId, required String logId}) async {
    if (shouldFail) throw Exception('Network offline');
    remoteStore.removeWhere((l) => l.id == logId);
  }

  @override
  Future<List<FoodLogDto>> getLogsForDateRange({
    required String userId,
    required String startDate,
    required String endDate,
  }) async => remoteStore;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeRemoteDatasource fakeRemote;
  late FoodLogLocalDatasource localDatasource;
  late FoodLogRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fakeRemote = FakeRemoteDatasource();
    localDatasource = FoodLogLocalDatasource();
    repository = FoodLogRepositoryImpl(
      remoteDatasource: fakeRemote,
      localDatasource: localDatasource,
    );
  });

  const testLog = FoodLogDto(
    id: 'offline-log-1',
    date: '2026-09-18',
    mealType: 'lunch',
    dishName: 'Bún Chả Hà Nội',
    estimatedWeightG: 300,
    calories: 520,
    proteinG: 22,
    carbsG: 65,
    fatG: 18,
    source: 'ai_scan',
    sodiumMg: 950.0,
    fiberG: 3.0,
    sugarG: 6.0,
    syncStatus: 'pending_sync',
  );

  group('FoodLogRepository Offline & Sync Tests', () {
    test('addFoodLog when offline persists to local cache with pending_sync', () async {
      fakeRemote.shouldFail = true;

      await repository.addFoodLog(userId: 'user-1', log: testLog);

      // Verify log exists in local cache
      final cached = await localDatasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(cached.length, 1);
      expect(cached.first.syncStatus, 'pending_sync');
      expect(cached.first.dishName, 'Bún Chả Hà Nội');

      // Verify in pending queue
      final pending = await repository.getPendingSyncLogs(userId: 'user-1');
      expect(pending.length, 1);
    });

    test('syncPendingLogs drains pending queue and updates local status to synced', () async {
      fakeRemote.shouldFail = true;
      await repository.addFoodLog(userId: 'user-1', log: testLog);

      // Now network is restored
      fakeRemote.shouldFail = false;
      final syncedCount = await repository.syncPendingLogs(userId: 'user-1');

      expect(syncedCount, 1);
      expect(fakeRemote.remoteStore.length, 1);

      // Queue is drained
      final pendingAfter = await repository.getPendingSyncLogs(userId: 'user-1');
      expect(pendingAfter, isEmpty);

      // Cache status updated to synced
      final cachedAfter = await localDatasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(cachedAfter.first.syncStatus, 'synced');
    });

    test('watchDailyLogs immediately emits local cached logs before remote resolves', () async {
      await localDatasource.saveCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
        logs: [testLog],
      );

      final stream = repository.watchDailyLogs(userId: 'user-1', date: '2026-09-18');
      final firstEmission = await stream.first;

      expect(firstEmission.length, 1);
      expect(firstEmission.first.dishName, 'Bún Chả Hà Nội');
    });

    test('addFoodLog debounces rapid identical submissions within 2 seconds', () async {
      await repository.addFoodLog(userId: 'user-1', log: testLog);
      // Immediately call again with identical dish, meal, date, and calories
      await repository.addFoodLog(userId: 'user-1', log: testLog.copyWith(id: 'diff-id'));

      final cached = await localDatasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(cached.length, 1);
    });

    test('watchDailyLogs deduplicates identical logs in cache and auto-persists clean list', () async {
      final dupLog = testLog.copyWith(id: 'offline-log-dup');
      await localDatasource.saveCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
        logs: [testLog, dupLog],
      );

      final stream = repository.watchDailyLogs(userId: 'user-1', date: '2026-09-18');
      final firstEmission = await stream.first;

      expect(firstEmission.length, 1);
      expect(firstEmission.first.dishName, 'Bún Chả Hà Nội');

      // Local cache is also cleaned up
      final cachedAfter = await localDatasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(cachedAfter.length, 1);
    });

    test('watchDailyLogs prevents duplicate pending log when remote already contains identical dish', () async {
      fakeRemote.remoteStore.add(
        testLog.copyWith(id: 'remote-doc-1', syncStatus: 'synced'),
      );
      await localDatasource.addToPendingQueue(
        userId: 'user-1',
        log: testLog.copyWith(id: 'pending-log-1', syncStatus: 'pending_sync'),
      );

      final stream = repository.watchDailyLogs(userId: 'user-1', date: '2026-09-18');
      final emissions = await stream.take(2).toList();
      final latest = emissions.last;

      expect(latest.length, 1);
      expect(latest.first.id, 'remote-doc-1');
    });
  });
}
