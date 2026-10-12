import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/entities/meal_slot.dart';
import 'package:astrobite/features/tracker/presentation/widgets/add_meal_slot_sheet.dart';

void main() {
  group('AddMealSlotBottomSheet Widget Tests', () {
    testWidgets('allows selecting preset and returns new MealSlot on confirm', (tester) async {
      MealSlot? addedSlot;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AddMealSlotBottomSheet.show(
                    context,
                    onAddSlot: (slot) => addedSlot = slot,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Tap to open sheet
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Thêm Bữa Phụ Mới'), findsOneWidget);
      expect(find.text('Bữa xế chiều'), findsOneWidget);
      expect(find.text('Bữa trước / sau tập'), findsOneWidget);

      // Select 'Bữa trước / sau tập'
      await tester.tap(find.text('Bữa trước / sau tập'));
      await tester.pumpAndSettle();

      // Tap confirm button
      await tester.tap(find.text('Thêm Bữa Phụ'));
      await tester.pumpAndSettle();

      expect(addedSlot, isNotNull);
      expect(addedSlot?.label, 'Bữa trước / sau tập');
      expect(addedSlot?.id, 'snack_workout');
      expect(addedSlot?.isRemovable, isTrue);
    });
  });
}
