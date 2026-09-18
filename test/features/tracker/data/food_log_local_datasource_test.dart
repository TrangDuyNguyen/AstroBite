import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/features/tracker/data/datasources/food_log_local_datasource.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FoodLogLocalDatasource datasource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    datasource = FoodLogLocalDatasource();
  });

  final sampleLog = const FoodLogDto(
    id: 'log-1',
    date: '2026-09-18',
    mealType: 'lunch',
    dishName: 'Phở Bò',
    estimatedWeightG: 350,
    calories: 450,
    proteinG: 25,
    carbsG: 50,
    fatG: 12,
    source: 'ai_scan',
    sodiumMg: 1200.0,
    fiberG: 2.5,
    sugarG: 3.0,
    syncStatus: 'pending_sync',
  );

  group('FoodLogLocalDatasource Tests', () {
    test('initially returns empty list when no cached logs', () async {
      final logs = await datasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(logs, isEmpty);
    });

    test('saves and retrieves cached logs correctly', () async {
      await datasource.saveCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
        logs: [sampleLog],
      );

      final cached = await datasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(cached.length, 1);
      expect(cached.first.dishName, 'Phở Bò');
      expect(cached.first.sodiumMg, 1200.0);
      expect(cached.first.syncStatus, 'pending_sync');
    });

    test('upsert updates existing log or appends new log', () async {
      await datasource.upsertCachedLog(userId: 'user-1', log: sampleLog);

      final updated = sampleLog.copyWith(calories: 500, syncStatus: 'synced');
      await datasource.upsertCachedLog(userId: 'user-1', log: updated);

      final cached = await datasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(cached.length, 1);
      expect(cached.first.calories, 500);
      expect(cached.first.syncStatus, 'synced');
    });

    test('deleteCachedLog removes log by id', () async {
      await datasource.saveCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
        logs: [sampleLog],
      );

      await datasource.deleteCachedLog(
        userId: 'user-1',
        date: '2026-09-18',
        logId: 'log-1',
      );

      final cached = await datasource.getCachedLogs(
        userId: 'user-1',
        date: '2026-09-18',
      );
      expect(cached, isEmpty);
    });

    test('manages pending sync queue correctly', () async {
      await datasource.addToPendingQueue(userId: 'user-1', log: sampleLog);

      var queue = await datasource.getPendingSyncLogs(userId: 'user-1');
      expect(queue.length, 1);
      expect(queue.first.id, 'log-1');

      await datasource.removeFromPendingQueue(userId: 'user-1', logId: 'log-1');
      queue = await datasource.getPendingSyncLogs(userId: 'user-1');
      expect(queue, isEmpty);
    });
  });
}
