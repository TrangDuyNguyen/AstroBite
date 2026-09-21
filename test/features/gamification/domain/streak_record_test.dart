import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';

void main() {
  group('StreakRecord Domain Tests', () {
    test('initial state has 0 streak and 1 starlight shield', () {
      final initial = StreakRecord.initial();
      expect(initial.currentStreak, 0);
      expect(initial.longestStreak, 0);
      expect(initial.starlightShields, 1);
      expect(initial.hasActiveStreak, false);
      expect(initial.hasShield, true);
      expect(initial.unlockedBadgeIds, isEmpty);
    });

    test('first meal log starts streak at 1', () {
      final record = StreakRecord.initial().recordMeal('2026-09-19');
      expect(record.currentStreak, 1);
      expect(record.longestStreak, 1);
      expect(record.lastActiveDate, '2026-09-19');
      expect(record.activeDates, ['2026-09-19']);
      expect(record.lastShieldConsumed, false);
    });

    test('consecutive day log increments streak', () {
      final day1 = StreakRecord.initial().recordMeal('2026-09-18');
      final day2 = day1.recordMeal('2026-09-19');

      expect(day2.currentStreak, 2);
      expect(day2.longestStreak, 2);
      expect(day2.lastActiveDate, '2026-09-19');
      expect(day2.activeDates, ['2026-09-18', '2026-09-19']);
      expect(day2.lastShieldConsumed, false);
    });

    test('multiple meal logs on the same day do not over-increment streak', () {
      final breakfast = StreakRecord.initial().recordMeal('2026-09-19');
      final lunch = breakfast.recordMeal('2026-09-19');
      final dinner = lunch.recordMeal('2026-09-19');

      expect(dinner.currentStreak, 1);
      expect(dinner.activeDates, ['2026-09-19']);
    });

    test('Starlight Shield protects streak when a single day is missed', () {
      // User logged on Sep 17, has 1 shield
      final day1 = StreakRecord.initial().recordMeal('2026-09-17');
      expect(day1.starlightShields, 1);

      // Missed Sep 18, logs on Sep 19 (gap = 2)
      final day3 = day1.recordMeal('2026-09-19');

      expect(day3.lastShieldConsumed, true);
      expect(day3.starlightShields, 0);
      expect(day3.currentStreak, 2); // Preserved!
      expect(day3.longestStreak, 2);
    });

    test('streak resets to 1 when no shields are available after missed day', () {
      // Start with 0 shields, log on Sep 16
      final record = StreakRecord(
        currentStreak: 5,
        longestStreak: 5,
        lastActiveDate: '2026-09-16',
        starlightShields: 0,
        updatedAt: DateTime.now(),
      );

      // Log on Sep 19 (gap = 3)
      final afterMiss = record.recordMeal('2026-09-19');

      expect(afterMiss.currentStreak, 1);
      expect(afterMiss.longestStreak, 5); // Longest preserved
      expect(afterMiss.lastShieldConsumed, false);
    });

    test('unlocks starlight_novice badge on day 3', () {
      var record = StreakRecord.initial();
      record = record.recordMeal('2026-09-17');
      record = record.recordMeal('2026-09-18');
      expect(record.unlockedBadgeIds, isEmpty);

      record = record.recordMeal('2026-09-19');
      expect(record.currentStreak, 3);
      expect(record.unlockedBadgeIds, contains('starlight_novice'));
    });

    test('7-day streak awards a bonus shield and unlocks pulsar_pioneer badge', () {
      var record = StreakRecord(
        currentStreak: 6,
        longestStreak: 6,
        lastActiveDate: '2026-09-18',
        starlightShields: 0,
        updatedAt: DateTime.now(),
      );

      record = record.recordMeal('2026-09-19');
      expect(record.currentStreak, 7);
      expect(record.starlightShields, 1); // Bonus shield awarded!
      expect(record.unlockedBadgeIds, contains('pulsar_pioneer'));
    });

    test('toMap and fromMap serialize and deserialize accurately', () {
      final original = StreakRecord(
        currentStreak: 7,
        longestStreak: 12,
        lastActiveDate: '2026-09-19',
        starlightShields: 2,
        activeDates: const ['2026-09-18', '2026-09-19'],
        unlockedBadgeIds: const ['starlight_novice', 'pulsar_pioneer'],
        updatedAt: DateTime(2026, 9, 19, 12, 0),
      );

      final map = original.toMap();
      final restored = StreakRecord.fromMap(map);

      expect(restored.currentStreak, 7);
      expect(restored.longestStreak, 12);
      expect(restored.lastActiveDate, '2026-09-19');
      expect(restored.starlightShields, 2);
      expect(restored.activeDates, ['2026-09-18', '2026-09-19']);
      expect(restored.unlockedBadgeIds, ['starlight_novice', 'pulsar_pioneer']);
    });
  });
}
