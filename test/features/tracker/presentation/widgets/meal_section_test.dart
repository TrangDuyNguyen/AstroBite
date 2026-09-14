import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/features/tracker/presentation/widgets/meal_section.dart';

void main() {
  Widget createWidgetUnderTest({
    required String mealType,
    required DailySummary summary,
    VoidCallback? onAddTap,
  }) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MealSection(
              mealType: mealType,
              summary: summary,
              onAddTap: onAddTap ?? () {},
            ),
          ),
        ),
      ),
    );
  }

  group('MealSection Widget Tests', () {
    testWidgets('renders empty meal section correctly', (tester) async {
      final summary = DailySummary.fromLogs(
        date: '2026-09-14',
        logs: [],
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          mealType: 'breakfast',
          summary: summary,
        ),
      );

      expect(find.text(AppStrings.breakfast), findsOneWidget);
      expect(find.text('0 kcal'), findsOneWidget);
      expect(find.text(AppStrings.noMealLogs), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('renders meal items when logs exist', (tester) async {
      final logs = [
        const FoodLog(
          id: 'log-1',
          date: '2026-09-14',
          mealType: 'breakfast',
          dishName: 'Bánh mì ốp la',
          estimatedWeightG: 180,
          calories: 350,
          proteinG: 15,
          carbsG: 40,
          fatG: 12,
          source: 'manual',
        ),
      ];

      final summary = DailySummary.fromLogs(
        date: '2026-09-14',
        logs: logs,
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          mealType: 'breakfast',
          summary: summary,
        ),
      );

      expect(find.text(AppStrings.breakfast), findsOneWidget);
      expect(find.text('350 kcal'), findsOneWidget);
      expect(find.text('Bánh mì ốp la (180g)'), findsOneWidget);
      expect(find.text('350 cal'), findsOneWidget);
      expect(find.text(AppStrings.noMealLogs), findsNothing);
    });

    testWidgets('triggers onAddTap when add icon button is tapped', (tester) async {
      bool addTapped = false;
      final summary = DailySummary.fromLogs(
        date: '2026-09-14',
        logs: [],
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          mealType: 'lunch',
          summary: summary,
          onAddTap: () => addTapped = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      expect(addTapped, isTrue);
    });

    testWidgets('swiping item opens confirmation dialog and cancel keeps item', (tester) async {
      final logs = [
        const FoodLog(
          id: 'log-1',
          date: '2026-09-14',
          mealType: 'dinner',
          dishName: 'Cơm tấm',
          estimatedWeightG: 300,
          calories: 550,
          proteinG: 25,
          carbsG: 70,
          fatG: 18,
          source: 'manual',
        ),
      ];

      final summary = DailySummary.fromLogs(
        date: '2026-09-14',
        logs: logs,
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          mealType: 'dinner',
          summary: summary,
        ),
      );

      // Swipe left on the food item
      await tester.drag(find.text('Cơm tấm (300g)'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Verify confirmation dialog is shown
      expect(find.text(AppStrings.confirmDelete), findsOneWidget);
      expect(find.text(AppStrings.deleteFoodConfirmMessage), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
      expect(find.text(AppStrings.delete), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text(AppStrings.cancel));
      await tester.pumpAndSettle();

      // Dialog is dismissed and item remains
      expect(find.text(AppStrings.confirmDelete), findsNothing);
      expect(find.text('Cơm tấm (300g)'), findsOneWidget);
    });
  });
}
