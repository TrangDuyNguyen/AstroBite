import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/entities/meal_slot.dart';
import 'package:astrobite/features/tracker/presentation/controllers/meal_slots_controller.dart';

void main() {
  group('MealSlotsController Unit Tests', () {
    late MealSlotsController controller;

    setUp(() {
      controller = MealSlotsController();
    });

    test('initial state contains 4 baseline slots and sums to 1.0 ratio', () {
      final slots = controller.state;
      expect(slots.length, 4);
      expect(slots[0].id, 'breakfast');
      expect(slots[1].id, 'lunch');
      expect(slots[2].id, 'dinner');
      expect(slots[3].id, 'snack');

      final sumRatios = slots.fold<double>(0.0, (acc, s) => acc + s.calorieRatio);
      expect(sumRatios, closeTo(1.0, 0.01));
    });

    test('addSlot adds new snack and rebalances calorie ratios', () {
      final preset = MealSlot(
        id: 'snack_afternoon',
        label: 'Bữa xế chiều',
        baseMealType: 'snack',
        icon: MealSlot.presets[1].icon,
        clayBgColor: MealSlot.presets[1].clayBgColor,
        calorieRatio: 0.10,
        isRemovable: true,
      );

      controller.addSlot(preset);

      final slots = controller.state;
      expect(slots.length, 5);
      expect(slots.last.label, 'Bữa xế chiều');
      expect(slots.last.isRemovable, isTrue);

      final sumRatios = slots.fold<double>(0.0, (acc, s) => acc + s.calorieRatio);
      expect(sumRatios, closeTo(1.0, 0.01));
    });

    test('removeSlot removes a removable snack and rebalances remaining slots', () {
      // Remove default snack
      final removed = controller.removeSlot('snack');
      expect(removed, isNotNull);
      expect(removed?.id, 'snack');

      final slots = controller.state;
      expect(slots.length, 3);
      expect(slots.any((s) => s.id == 'snack'), isFalse);

      final sumRatios = slots.fold<double>(0.0, (acc, s) => acc + s.calorieRatio);
      expect(sumRatios, closeTo(1.0, 0.01));
    });

    test('removeSlot fails gracefully when attempting to remove non-removable breakfast', () {
      final removed = controller.removeSlot('breakfast');
      expect(removed, isNull);
      expect(controller.state.length, 4);
    });

    test('restoreSlot restores a slot after undo', () {
      final removed = controller.removeSlot('snack');
      expect(controller.state.length, 3);

      controller.restoreSlot(removed!, 3);
      expect(controller.state.length, 4);
      expect(controller.state[3].id, 'snack');

      final sumRatios = controller.state.fold<double>(0.0, (acc, s) => acc + s.calorieRatio);
      expect(sumRatios, closeTo(1.0, 0.01));
    });
  });
}
