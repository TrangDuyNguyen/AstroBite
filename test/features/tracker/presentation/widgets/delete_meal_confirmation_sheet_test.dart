import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/features/tracker/domain/entities/meal_slot.dart';
import 'package:astrobite/features/tracker/presentation/widgets/delete_meal_confirmation_sheet.dart';

void main() {
  group('DeleteMealConfirmationSheet Widget Tests', () {
    const slotToDelete = MealSlot(
      id: 'snack_afternoon',
      label: 'Bữa xế chiều',
      baseMealType: 'snack',
      icon: Icons.coffee_rounded,
      clayBgColor: Colors.orange,
      calorieRatio: 0.10,
      isRemovable: true,
    );

    final availableSlots = [
      MealSlot.defaultSlots[0], // breakfast
      MealSlot.defaultSlots[1], // lunch
      slotToDelete,
    ];

    const logs = [
      FoodLog(
        id: 'log-1',
        date: '2026-10-12',
        mealType: 'snack_afternoon',
        dishName: 'Chuối tiêu',
        estimatedWeightG: 100,
        calories: 90,
        proteinG: 1,
        carbsG: 23,
        fatG: 0,
        source: 'manual',
      ),
    ];

    testWidgets('shows warning, item count, and returns migration result on confirm', (tester) async {
      DeleteMealResult? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await DeleteMealConfirmationSheet.show(
                    context,
                    slotToDelete: slotToDelete,
                    availableSlots: availableSlots,
                    logs: logs,
                  );
                },
                child: const Text('Delete'),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Xóa "Bữa xế chiều"?'), findsOneWidget);
      expect(find.text('Bữa này đang có 1 món ăn (tổng 90 kcal)'), findsOneWidget);
      expect(find.text('Chuyển Món & Xóa Bữa Này'), findsOneWidget);
      expect(find.text('Xóa Hẳn (Bao Gồm Tất Cả Món Ăn)'), findsOneWidget);

      // Tap migrate
      await tester.tap(find.text('Chuyển Món & Xóa Bữa Này'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result?.action, DeleteMealAction.migrate);
      expect(result?.targetSlotId, 'breakfast');
    });

    testWidgets('returns deleteAll when choosing to delete all', (tester) async {
      DeleteMealResult? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await DeleteMealConfirmationSheet.show(
                    context,
                    slotToDelete: slotToDelete,
                    availableSlots: availableSlots,
                    logs: logs,
                  );
                },
                child: const Text('Delete'),
              ),
            ),
          ),
        ),
      );

      // Open sheet
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Tap delete all
      await tester.tap(find.text('Xóa Hẳn (Bao Gồm Tất Cả Món Ăn)'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result?.action, DeleteMealAction.deleteAll);
    });
  });
}
