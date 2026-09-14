import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';

void main() {
  group('DailySummary', () {
    test('calculates total calories and macros correctly from logs', () {
      final logs = [
        const FoodLog(
          id: '1', date: '2026-07-27', mealType: 'breakfast',
          dishName: 'Phở bò', estimatedWeightG: 350, calories: 450,
          proteinG: 25, carbsG: 55, fatG: 12, source: 'manual',
        ),
        const FoodLog(
          id: '2', date: '2026-07-27', mealType: 'lunch',
          dishName: 'Cơm tấm sườn', estimatedWeightG: 300, calories: 550,
          proteinG: 30, carbsG: 70, fatG: 16, source: 'ai_scan',
        ),
      ];

      final summary = DailySummary.fromLogs(
        date: '2026-07-27',
        logs: logs,
        targetCalories: 2000,
      );

      expect(summary.totalCalories, 1000);
      expect(summary.totalProteinG, 55);
      expect(summary.totalCarbsG, 125);
      expect(summary.totalFatG, 28);
      expect(summary.getMealCalories('breakfast'), 450);
      expect(summary.getMealCalories('lunch'), 550);
      expect(summary.getMealCalories('dinner'), 0);
      expect(summary.targetCalories, 2000);
      expect(summary.targetProteinG, (2000 * 0.30 / 4).round());
      expect(summary.targetCarbsG, (2000 * 0.50 / 4).round());
      expect(summary.targetFatG, (2000 * 0.20 / 9).round());
    });

    test('supports custom target calories from user profile', () {
      final summary = DailySummary.fromLogs(
        date: '2026-07-27',
        logs: [],
        targetCalories: 1850,
      );

      expect(summary.totalCalories, 0);
      expect(summary.targetCalories, 1850);
      expect(summary.targetProteinG, (1850 * 0.30 / 4).round());
      expect(summary.targetCarbsG, (1850 * 0.50 / 4).round());
      expect(summary.targetFatG, (1850 * 0.20 / 9).round());
    });

    test('detects when total calories exceed target calories', () {
      final logs = [
        const FoodLog(
          id: '1', date: '2026-07-27', mealType: 'breakfast',
          dishName: 'Bún bò Huế', estimatedWeightG: 400, calories: 650,
          proteinG: 35, carbsG: 75, fatG: 22, source: 'manual',
        ),
        const FoodLog(
          id: '2', date: '2026-07-27', mealType: 'lunch',
          dishName: 'Cơm gà xối mỡ', estimatedWeightG: 450, calories: 850,
          proteinG: 40, carbsG: 95, fatG: 30, source: 'manual',
        ),
        const FoodLog(
          id: '3', date: '2026-07-27', mealType: 'dinner',
          dishName: 'Lẩu hải sản', estimatedWeightG: 500, calories: 700,
          proteinG: 45, carbsG: 50, fatG: 25, source: 'manual',
        ),
      ];

      final summary = DailySummary.fromLogs(
        date: '2026-07-27',
        logs: logs,
        targetCalories: 2000,
      );

      expect(summary.totalCalories, 2200);
      expect(summary.totalCalories > summary.targetCalories, isTrue);
      expect(summary.totalCalories - summary.targetCalories, 200);
    });
  });
}
