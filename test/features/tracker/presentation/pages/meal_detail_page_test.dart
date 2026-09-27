import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/pages/meal_detail_page.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

void main() {
  Widget createWidgetUnderTest({
    String mealType = 'lunch',
    DailySummary? customSummary,
  }) {
    final summary = customSummary ??
        DailySummary.fromLogs(
          date: '2026-09-27',
          logs: const [
            FoodLog(
              id: 'log-1',
              date: '2026-09-27',
              mealType: 'lunch',
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
              date: '2026-09-27',
              mealType: 'lunch',
              dishName: 'Trà đào cam sả',
              estimatedWeightG: 200,
              calories: 80,
              proteinG: 1,
              carbsG: 18,
              fatG: 0,
              source: 'manual',
            ),
          ],
          targetCalories: 2000,
        );

    return ProviderScope(
      overrides: [
        todaySummaryProvider.overrideWithValue(summary),
      ],
      child: MaterialApp(
        home: MealDetailPage(mealType: mealType),
      ),
    );
  }

  group('MealDetailPage Widget Tests (Sprint 13)', () {
    testWidgets('renders header, total calories, and food items in ClayCards', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest(mealType: 'lunch'));
      await tester.pumpAndSettle();

      // Meal title in AppBar
      expect(find.text(AppStrings.lunch), findsOneWidget);

      // Total calories badge (450 + 80 = 530 kcal)
      expect(find.text('530 kcal'), findsOneWidget);

      // Verify macro breakdown pills
      expect(find.text(AppStrings.carbs), findsOneWidget);
      expect(find.text('73g'), findsOneWidget); // 55 + 18
      expect(find.text(AppStrings.protein), findsOneWidget);
      expect(find.text('29g'), findsOneWidget); // 28 + 1
      expect(find.text(AppStrings.fat), findsOneWidget);
      expect(find.text('12g'), findsOneWidget);

      // Food items
      expect(find.text('Phở bò tái'), findsOneWidget);
      expect(find.text('Trà đào cam sả'), findsOneWidget);

      // Clay components present
      expect(find.byType(ClayCard), findsWidgets);
      expect(find.byType(ClayButton), findsWidgets);
      expect(find.byType(ClayIconButton), findsWidgets);
    });

    testWidgets('renders empty state when meal has no logs', (tester) async {
      final emptySummary = DailySummary.fromLogs(
        date: '2026-09-27',
        logs: const [],
        targetCalories: 2000,
      );

      await tester.pumpWidget(createWidgetUnderTest(
        mealType: 'dinner',
        customSummary: emptySummary,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Chưa có món ăn nào trong ${AppStrings.dinner}'), findsOneWidget);
      expect(find.text('Thêm món ngay'), findsOneWidget);
    });
  });
}
