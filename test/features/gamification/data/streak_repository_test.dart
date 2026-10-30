import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/features/gamification/data/streak_repository.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StreakRepository repository;
  const userId = 'user_test_123';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = StreakRepository();
  });

  group('StreakRepository Durable Offline Persistence Tests (ASTRO-015)', () {
    test('returns initial streak record when both disk cache and firestore are empty', () async {
      final streak = await repository.getStreak(userId);
      expect(streak.currentStreak, 0);
      expect(streak.longestStreak, 0);
      expect(streak.starlightShields, 1);
    });

    test('persists streak to disk and retrieves it across repository instances (app restart simulation)', () async {
      final record = StreakRecord(
        currentStreak: 5,
        longestStreak: 10,
        lastActiveDate: '2026-10-30',
        starlightShields: 2,
        activeDates: ['2026-10-26', '2026-10-27', '2026-10-28', '2026-10-29', '2026-10-30'],
        unlockedBadgeIds: [CosmicBadge.starlightNovice.id],
        updatedAt: DateTime(2026, 10, 30),
      );

      // Save via instance 1
      await repository.saveStreak(userId, record);

      // Create new instance 2 simulating app restart (memory cache empty)
      final newRepository = StreakRepository();
      final loaded = await newRepository.getStreak(userId);

      expect(loaded.currentStreak, 5);
      expect(loaded.longestStreak, 10);
      expect(loaded.lastActiveDate, '2026-10-30');
      expect(loaded.starlightShields, 2);
      expect(loaded.activeDates.length, 5);
      expect(loaded.unlockedBadgeIds, contains(CosmicBadge.starlightNovice.id));
    });

    test('retrieves from pre-seeded disk cache when Firestore is not available', () async {
      final seededRecord = StreakRecord(
        currentStreak: 12,
        longestStreak: 15,
        lastActiveDate: '2026-10-29',
        starlightShields: 1,
        activeDates: ['2026-10-29'],
        unlockedBadgeIds: [CosmicBadge.pulsarPioneer.id],
        updatedAt: DateTime(2026, 10, 29),
      );

      SharedPreferences.setMockInitialValues({
        'streak_record_$userId': jsonEncode(seededRecord.toMap()),
      });

      final offlineRepo = StreakRepository();
      final loaded = await offlineRepo.getStreak(userId);

      expect(loaded.currentStreak, 12);
      expect(loaded.longestStreak, 15);
      expect(loaded.unlockedBadgeIds, contains(CosmicBadge.pulsarPioneer.id));
    });

    test('clearCache clears memory and disk persistence', () async {
      final record = StreakRecord(
        currentStreak: 3,
        longestStreak: 3,
        updatedAt: DateTime.now(),
      );

      await repository.saveStreak(userId, record);
      await repository.clearCache(userId: userId);

      final freshRepo = StreakRepository();
      final streak = await freshRepo.getStreak(userId);
      expect(streak.currentStreak, 0);
    });
  });
}

