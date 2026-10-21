import 'package:astrobite/features/tracker/domain/entities/water_log.dart';
import 'package:astrobite/features/tracker/domain/entities/water_quick_preset.dart';
import 'package:astrobite/features/tracker/domain/water_goal_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WaterQuickPreset Tests', () {
    test('maps preset amounts correctly', () {
      expect(WaterQuickPreset.fromAmount(250), WaterQuickPreset.glass250);
      expect(WaterQuickPreset.fromAmount(500), WaterQuickPreset.bottle500);
      expect(WaterQuickPreset.fromAmount(750), WaterQuickPreset.flask750);
      expect(WaterQuickPreset.fromAmount(330), WaterQuickPreset.custom);
    });
  });

  group('WaterDayLog Entity Tests', () {
    test('calculates progress and goal reached correctly', () {
      final initial = WaterDayLog.initial(date: '2026-10-21', targetMl: 2000);
      expect(initial.currentMl, 0);
      expect(initial.progress, 0.0);
      expect(initial.isGoalReached, false);
      expect(initial.remainingMl, 2000);

      final updated = initial.addIntake(500);
      expect(updated.currentMl, 500);
      expect(updated.progress, 0.25);
      expect(updated.progressPercent, 25);
      expect(updated.isGoalReached, false);
      expect(updated.remainingMl, 1500);
      expect(updated.entries.length, 1);

      final completed = updated.addIntake(1600);
      expect(completed.currentMl, 2100);
      expect(completed.isGoalReached, true);
      expect(completed.remainingMl, 0);
      expect(completed.entries.length, 2);
    });

    test('serializes to and from JSON accurately', () {
      final log = WaterDayLog.initial(date: '2026-10-21', targetMl: 2500).addIntake(250, note: 'Morning glass');
      final json = log.toJson();

      final restored = WaterDayLog.fromJson(json);
      expect(restored.id, log.id);
      expect(restored.date, '2026-10-21');
      expect(restored.currentMl, 250);
      expect(restored.targetMl, 2500);
      expect(restored.entries.length, 1);
      expect(restored.entries.first.note, 'Morning glass');
    });
  });

  group('WaterGoalCalculator Pure Function Tests', () {
    test('calculates hydration goal accurately for varied body weights', () {
      // 60kg * 35 = 2100ml
      expect(WaterGoalCalculator.calculateRecommendedGoalMl(weightKg: 60), 2100);
      // 70kg * 35 = 2450ml
      expect(WaterGoalCalculator.calculateRecommendedGoalMl(weightKg: 70), 2450);
      // 70kg + 60 min exercise = 2450 + 700 = 3150ml
      expect(
        WaterGoalCalculator.calculateRecommendedGoalMl(weightKg: 70, activeMinutes: 60),
        3150,
      );
      // Clamps to minimum 1500ml
      expect(WaterGoalCalculator.calculateRecommendedGoalMl(weightKg: 30), 1500);
      // Clamps to maximum 4500ml
      expect(WaterGoalCalculator.calculateRecommendedGoalMl(weightKg: 150), 4500);
    });

    test('evaluates hydration feedback correctly', () {
      expect(WaterGoalCalculator.evaluateStatus(0, 2000), HydrationFeedback.empty);
      expect(WaterGoalCalculator.evaluateStatus(500, 2000), HydrationFeedback.low);
      expect(WaterGoalCalculator.evaluateStatus(1200, 2000), HydrationFeedback.moderate);
      expect(WaterGoalCalculator.evaluateStatus(1800, 2000), HydrationFeedback.almostDone);
      expect(WaterGoalCalculator.evaluateStatus(2000, 2000), HydrationFeedback.completed);
      expect(WaterGoalCalculator.evaluateStatus(2500, 2000), HydrationFeedback.completed);
    });
  });
}
