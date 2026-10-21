import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/features/tracker/data/repositories/water_repository_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WaterRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = WaterRepositoryImpl();
  });

  group('WaterRepositoryImpl Tests', () {
    test('getDailyWater returns initial 0ml with default target 2000ml', () async {
      final log = await repository.getDailyWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
      );

      expect(log.currentMl, 0);
      expect(log.targetMl, 2000);
      expect(log.entries, isEmpty);
      expect(log.isGoalReached, isFalse);
    });

    test('logWater adds intake and saves to local cache immediately', () async {
      final updated = await repository.logWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
        amountMl: 250,
        note: 'Morning glass',
      );

      expect(updated.currentMl, 250);
      expect(updated.entries.length, 1);
      expect(updated.entries.first.amountMl, 250);
      expect(updated.entries.first.note, 'Morning glass');

      // Verify cached read returns updated data
      final cached = await repository.getDailyWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
      );
      expect(cached.currentMl, 250);
      expect(cached.entries.length, 1);
    });

    test('logWater accumulates multiple entries and detects goal reached', () async {
      await repository.logWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
        amountMl: 1000,
      );
      final finalLog = await repository.logWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
        amountMl: 1200,
      );

      expect(finalLog.currentMl, 2200);
      expect(finalLog.entries.length, 2);
      expect(finalLog.isGoalReached, isTrue);
      expect(finalLog.progressPercent, 110);
    });

    test('updateDailyTarget adjusts target and preserves existing intake', () async {
      await repository.logWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
        amountMl: 500,
      );

      await repository.updateDailyTarget(
        userId: 'usr_test_1',
        date: '2026-10-21',
        targetMl: 2500,
      );

      final log = await repository.getDailyWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
      );
      expect(log.currentMl, 500);
      expect(log.targetMl, 2500);
      expect(log.remainingMl, 2000);
    });

    test('watchDailyWater emits initial cached state', () async {
      await repository.logWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
        amountMl: 500,
      );

      final stream = repository.watchDailyWater(
        userId: 'usr_test_1',
        date: '2026-10-21',
      );

      final firstEvent = await stream.first;
      expect(firstEvent.currentMl, 500);
      expect(firstEvent.entries.length, 1);
    });
  });
}
