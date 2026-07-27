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
    });
  });
}
