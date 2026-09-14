import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/features/tracker/presentation/widgets/daily_summary_card.dart';

void main() {
  group('DailySummaryCard Widget Tests', () {
    testWidgets('renders remaining calories and macros within budget', (tester) async {
      final logs = [
        const FoodLog(
          id: '1',
          date: '2026-09-14',
          mealType: 'breakfast',
          dishName: 'Phở bò',
          estimatedWeightG: 350,
          calories: 500,
          proteinG: 30,
          carbsG: 60,
          fatG: 15,
          source: 'manual',
        ),
      ];

      final summary = DailySummary.fromLogs(
        date: '2026-09-14',
        logs: logs,
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(summary: summary),
            ),
          ),
        ),
      );

      // Remaining: 2000 - 500 = 1500 kcal
      expect(find.text('1500 kcal'), findsOneWidget);
      expect(find.text(AppStrings.kcalRemaining), findsOneWidget);

      // Macro bars
      expect(find.text(AppStrings.protein), findsOneWidget);
      expect(find.text(AppStrings.carbs), findsOneWidget);
      expect(find.text(AppStrings.fat), findsOneWidget);
    });

    testWidgets('renders warning state when exceeding target calories (over budget)', (tester) async {
      final logs = [
        const FoodLog(
          id: '1',
          date: '2026-09-14',
          mealType: 'dinner',
          dishName: 'Buffet',
          estimatedWeightG: 800,
          calories: 2150,
          proteinG: 90,
          carbsG: 200,
          fatG: 70,
          source: 'manual',
        ),
      ];

      final summary = DailySummary.fromLogs(
        date: '2026-09-14',
        logs: logs,
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DailySummaryCard(summary: summary),
            ),
          ),
        ),
      );

      // Over budget: 2150 - 2000 = +150 kcal
      expect(find.text('+150 kcal'), findsOneWidget);
      expect(find.text(AppStrings.overBudget), findsOneWidget);
    });
  });
}
