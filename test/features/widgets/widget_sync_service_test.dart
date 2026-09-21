import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WidgetSyncPayload Tests', () {
    test('creates payload correctly from DailySummary and StreakRecord', () {
      const summary = DailySummary(
        date: '2026-09-19',
        totalCalories: 1550,
        targetCalories: 2200,
        totalProteinG: 110,
        targetProteinG: 140,
        totalCarbsG: 180,
        targetCarbsG: 220,
        totalFatG: 45,
        targetFatG: 65,
        logs: [],
      );

      final streak = StreakRecord(
        currentStreak: 5,
        longestStreak: 8,
        starlightShields: 1,
        lastActiveDate: '2026-09-19',
        updatedAt: DateTime.now(),
      );

      final payload = WidgetSyncPayload.fromSummaryAndStreak(
        summary: summary,
        streak: streak,
      );

      expect(payload.remainingCalories, 650);
      expect(payload.consumedCalories, 1550);
      expect(payload.targetCalories, 2200);
      expect(payload.carbsGrams, 180);
      expect(payload.fatGrams, 45);
      expect(payload.proteinGrams, 110);
      expect(payload.targetCarbsGrams, 220);
      expect(payload.targetFatGrams, 65);
      expect(payload.targetProteinGrams, 140);
      expect(payload.currentStreak, 5);
      expect(payload.hasShield, true);

      final map = payload.toMap();
      expect(map['remaining_calories'], 650);
      expect(map['consumed_calories'], 1550);
      expect(map['target_calories'], 2200);
      expect(map['target_carbs_grams'], 220);
      expect(map['target_protein_grams'], 140);
      expect(map['target_fat_grams'], 65);
      expect(map['current_streak'], 5);
      expect(map['has_shield'], true);
    });

    test('remaining calories clamps to 0 when over budget', () {
      const overBudgetSummary = DailySummary(
        date: '2026-09-19',
        totalCalories: 2500,
        targetCalories: 2000,
        totalProteinG: 150,
        targetProteinG: 140,
        totalCarbsG: 280,
        targetCarbsG: 220,
        totalFatG: 90,
        targetFatG: 65,
        logs: [],
      );

      final payload = WidgetSyncPayload.fromSummaryAndStreak(
        summary: overBudgetSummary,
      );

      expect(payload.remainingCalories, 0);
      expect(payload.consumedCalories, 2500);
      expect(payload.currentStreak, 0);
      expect(payload.hasShield, false);
    });
  });

  group('WidgetSyncService Tests', () {
    test('sync updates lastPayload and handles gracefully in test environment', () async {
      final service = WidgetSyncService();

      const summary = DailySummary(
        date: '2026-09-19',
        totalCalories: 1200,
        targetCalories: 2000,
        totalProteinG: 80,
        targetProteinG: 140,
        totalCarbsG: 150,
        targetCarbsG: 220,
        totalFatG: 40,
        targetFatG: 65,
        logs: [],
      );

      final streak = StreakRecord(
        currentStreak: 3,
        longestStreak: 3,
        lastActiveDate: '2026-09-19',
        updatedAt: DateTime.now(),
      );

      await service.sync(summary: summary, streak: streak);

      expect(service.lastPayload, isNotNull);
      expect(service.lastPayload!.remainingCalories, 800);
      expect(service.lastPayload!.currentStreak, 3);
    });

    test('requestPinWidget handles gracefully in test environment without throwing', () async {
      final service = WidgetSyncService();
      final result = await service.requestPinWidget();
      // In flutter test without mock channel, returns false or handles gracefully
      expect(result, isA<bool>());
    });
  });
}
