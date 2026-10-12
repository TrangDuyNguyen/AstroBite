import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/utils/nutrition_calculator.dart';
import '../../domain/entities/meal_slot.dart';

final mealSlotsNotifierProvider =
    StateNotifierProvider<MealSlotsController, List<MealSlot>>((ref) {
  return MealSlotsController();
});

/// State controller managing active meal slots on the Dashboard.
class MealSlotsController extends StateNotifier<List<MealSlot>> {
  MealSlotsController() : super(MealSlot.defaultSlots);

  /// Add a new meal slot and dynamically rebalance suggested calorie ratios.
  void addSlot(MealSlot newSlot) {
    // Generate unique ID if already exists
    var uniqueId = newSlot.id;
    var counter = 1;
    while (state.any((s) => s.id == uniqueId)) {
      uniqueId = '${newSlot.id}_$counter';
      counter++;
    }

    final slotToAdd = newSlot.copyWith(
      id: uniqueId,
      orderIndex: state.length,
    );

    final updated = [...state, slotToAdd];
    state = _rebalanceSlots(updated);
  }

  /// Remove a meal slot by ID and rebalance calorie ratios among remaining slots.
  MealSlot? removeSlot(String slotId) {
    final index = state.indexWhere((s) => s.id == slotId && s.isRemovable);
    if (index == -1) return null;

    final removedSlot = state[index];
    final updated = List<MealSlot>.from(state)..removeAt(index);
    state = _rebalanceSlots(updated);
    return removedSlot;
  }

  /// Restore a previously deleted meal slot (e.g. when user taps Undo).
  void restoreSlot(MealSlot slot, [int? preferredIndex]) {
    final index = preferredIndex != null && preferredIndex <= state.length
        ? preferredIndex
        : state.length;
    final updated = List<MealSlot>.from(state)..insert(index, slot);
    state = _rebalanceSlots(updated);
  }

  /// Reset to standard baseline meals (Breakfast, Lunch, Dinner, Snack).
  void resetToDefaults() {
    state = MealSlot.defaultSlots;
  }

  /// Internal helper to rebalance suggested calorie percentages.
  List<MealSlot> _rebalanceSlots(List<MealSlot> slots) {
    if (slots.isEmpty) return slots;
    final rawRatios = slots.map((s) => s.calorieRatio).toList();
    final newRatios = NutritionCalculator.rebalanceMealRatios(rawRatios);

    return List.generate(slots.length, (i) {
      return slots[i].copyWith(
        calorieRatio: newRatios[i],
        orderIndex: i,
      );
    });
  }
}
