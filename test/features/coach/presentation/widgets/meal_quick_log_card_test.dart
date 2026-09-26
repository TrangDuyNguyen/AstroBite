import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/presentation/widgets/meal_quick_log_card.dart';

void main() {
  group('MealQuickLogCard Widget Tests', () {
    testWidgets('renders dish name, calories and 3 macros accurately', (tester) async {
      const props = MealQuickLogProps(
        dishName: 'Ức gà áp chảo sốt tiêu',
        calories: 360,
        protein: 38.0,
        carbs: 12.0,
        fat: 6.0,
        weightG: 180,
        mealType: 'lunch',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MealQuickLogCard(props: props),
          ),
        ),
      );

      expect(find.text('Ức gà áp chảo sốt tiêu'), findsOneWidget);
      expect(find.text('360 kcal'), findsOneWidget);
      expect(find.text('180g'), findsOneWidget);
      expect(find.text('LUNCH'), findsOneWidget);
      expect(find.text('Carbs'), findsOneWidget);
      expect(find.text('12.0g'), findsOneWidget);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('38.0g'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);
      expect(find.text('6.0g'), findsOneWidget);
      expect(find.text('⚡ Ghi vào nhật ký ngay'), findsOneWidget);
    });

    testWidgets('stepper adjusts weight and proportionally recalculates calories and macros', (tester) async {
      const props = MealQuickLogProps(
        dishName: 'Cá hồi áp chảo',
        calories: 200,
        protein: 20.0,
        carbs: 0.0,
        fat: 10.0,
        weightG: 100,
        mealType: 'dinner',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MealQuickLogCard(props: props),
          ),
        ),
      );

      expect(find.text('100g'), findsOneWidget);
      expect(find.text('200 kcal'), findsOneWidget);

      // Tap +20g
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('120g'), findsOneWidget);
      expect(find.text('240 kcal'), findsOneWidget);
      expect(find.text('24.0g'), findsOneWidget); // Protein scaled 1.2x
      expect(find.text('12.0g'), findsOneWidget); // Fat scaled 1.2x
    });

    testWidgets('1-Tap Log triggers onLogMeal and updates button to success state', (tester) async {
      MealQuickLogProps? loggedProps;

      const props = MealQuickLogProps(
        dishName: 'Bát yến mạch sữa hạt',
        calories: 250,
        protein: 8.0,
        carbs: 45.0,
        fat: 5.0,
        weightG: 200,
        mealType: 'breakfast',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealQuickLogCard(
              props: props,
              onLogMeal: (p) => loggedProps = p,
            ),
          ),
        ),
      );

      await tester.tap(find.text('⚡ Ghi vào nhật ký ngay'));
      await tester.pumpAndSettle();

      expect(loggedProps, isNotNull);
      expect(loggedProps!.dishName, 'Bát yến mạch sữa hạt');
      expect(loggedProps!.calories, 250);
      expect(find.text('✓ Đã ghi vào nhật ký'), findsOneWidget);
    });
  });
}
