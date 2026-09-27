import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/pages/home_page.dart';
import 'package:astrobite/features/tracker/presentation/widgets/celestial_time_avatar.dart';
import 'package:astrobite/features/tracker/presentation/widgets/daily_summary_card.dart';
import 'package:astrobite/features/tracker/presentation/widgets/meal_section.dart';

void main() {
  Widget createWidgetUnderTest({DailySummary? customSummary}) {
    final summary = customSummary ??
        DailySummary.fromLogs(
          date: '2026-09-14',
          logs: const [
            FoodLog(
              id: 'log-1',
              date: '2026-09-14',
              mealType: 'breakfast',
              dishName: 'Phở bò tái',
              estimatedWeightG: 350,
              calories: 450,
              proteinG: 28,
              carbsG: 55,
              fatG: 12,
              source: 'manual',
            ),
            FoodLog(
              id: 'log-2',
              date: '2026-09-14',
              mealType: 'lunch',
              dishName: 'Cơm tấm sườn',
              estimatedWeightG: 300,
              calories: 550,
              proteinG: 30,
              carbsG: 70,
              fatG: 16,
              source: 'manual',
            ),
          ],
          targetCalories: 2000,
        );

    return ProviderScope(
      overrides: [
        todaySummaryProvider.overrideWithValue(summary),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }

  group('HomePage Widget Tests', () {
    testWidgets('renders all core components on Today Overview dashboard', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());

      // AppBar title & actions
      expect(find.text(AppStrings.todayOverview), findsOneWidget);
      expect(find.byType(CelestialTimeAvatar), findsOneWidget);

      // AppBar date picker trigger
      expect(find.byIcon(Icons.arrow_drop_down_rounded), findsOneWidget);

      // DailySummaryCard
      expect(find.byType(DailySummaryCard), findsOneWidget);
      expect(find.text('1000 kcal'), findsOneWidget); // 2000 - (450 + 550) = 1000 remaining
      expect(find.text(AppStrings.kcalRemaining), findsOneWidget);

      // Section title
      expect(find.text(AppStrings.nutritionLog), findsOneWidget);

      // 4 Meal sections
      expect(find.byType(MealSection), findsNWidgets(4));
      expect(find.text(AppStrings.breakfast), findsOneWidget);
      expect(find.text(AppStrings.lunch), findsOneWidget);
      expect(find.text(AppStrings.dinner), findsOneWidget);
      expect(find.text(AppStrings.snack), findsOneWidget);

      // Verify logged meal items
      expect(find.text('Phở bò tái (350g)'), findsOneWidget);
      expect(find.text('Cơm tấm sườn (300g)'), findsOneWidget);
    });

    testWidgets('renders over budget warning on HomePage when calories exceed target', (tester) async {
      final overBudgetSummary = DailySummary.fromLogs(
        date: '2026-09-14',
        logs: const [
          FoodLog(
            id: 'log-1',
            date: '2026-09-14',
            mealType: 'dinner',
            dishName: 'Tiệc nướng BBQ',
            estimatedWeightG: 800,
            calories: 2250,
            proteinG: 100,
            carbsG: 180,
            fatG: 80,
            source: 'manual',
          ),
        ],
        targetCalories: 2000,
      );

      await tester.pumpWidget(createWidgetUnderTest(customSummary: overBudgetSummary));

      expect(find.text('+250 kcal'), findsOneWidget);
      expect(find.text(AppStrings.overBudget), findsOneWidget);
    });

    testWidgets('renders quick action buttons for recipe and meal planner', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Công thức món'), findsOneWidget);
      expect(find.text('Kế hoạch 7 ngày'), findsOneWidget);
      expect(find.byTooltip('Công thức món ăn'), findsOneWidget);
    });
  });
}
