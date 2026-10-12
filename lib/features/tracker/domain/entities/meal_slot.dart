import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Represents a configurable meal slot on the Dashboard.
/// Supports standard meals (Breakfast, Lunch, Dinner) and dynamic/custom snacks.
class MealSlot {
  const MealSlot({
    required this.id,
    required this.label,
    required this.baseMealType,
    required this.icon,
    required this.clayBgColor,
    required this.calorieRatio,
    this.isRemovable = false,
    this.orderIndex = 0,
  });

  final String id;
  final String label;
  final String baseMealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final IconData icon;
  final Color clayBgColor;
  final double calorieRatio;
  final bool isRemovable;
  final int orderIndex;

  int calculateSuggestedCalories(int targetCalories) =>
      (targetCalories * calorieRatio).round();

  MealSlot copyWith({
    String? id,
    String? label,
    String? baseMealType,
    IconData? icon,
    Color? clayBgColor,
    double? calorieRatio,
    bool? isRemovable,
    int? orderIndex,
  }) {
    return MealSlot(
      id: id ?? this.id,
      label: label ?? this.label,
      baseMealType: baseMealType ?? this.baseMealType,
      icon: icon ?? this.icon,
      clayBgColor: clayBgColor ?? this.clayBgColor,
      calorieRatio: calorieRatio ?? this.calorieRatio,
      isRemovable: isRemovable ?? this.isRemovable,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  /// Default 4 baseline slots for all users.
  static List<MealSlot> get defaultSlots => [
        MealSlot(
          id: 'breakfast',
          label: 'Bữa sáng',
          baseMealType: 'breakfast',
          icon: MealType.breakfast.icon,
          clayBgColor: MealType.breakfast.clayBgColor,
          calorieRatio: 0.25,
          isRemovable: false,
          orderIndex: 0,
        ),
        MealSlot(
          id: 'lunch',
          label: 'Bữa trưa',
          baseMealType: 'lunch',
          icon: MealType.lunch.icon,
          clayBgColor: MealType.lunch.clayBgColor,
          calorieRatio: 0.35,
          isRemovable: false,
          orderIndex: 1,
        ),
        MealSlot(
          id: 'dinner',
          label: 'Bữa tối',
          baseMealType: 'dinner',
          icon: MealType.dinner.icon,
          clayBgColor: MealType.dinner.clayBgColor,
          calorieRatio: 0.30,
          isRemovable: false,
          orderIndex: 2,
        ),
        MealSlot(
          id: 'snack',
          label: 'Bữa phụ',
          baseMealType: 'snack',
          icon: MealType.snack.icon,
          clayBgColor: MealType.snack.clayBgColor,
          calorieRatio: 0.10,
          isRemovable: true,
          orderIndex: 3,
        ),
      ];

  /// Available presets when adding a new snack slot.
  static List<MealSlotPreset> get presets => const [
        MealSlotPreset(
          presetId: 'snack_morning',
          label: 'Bữa xế sáng',
          icon: Icons.wb_twilight_rounded,
          clayBgColor: AppColors.clayBreakfast,
          defaultRatio: 0.10,
          emoji: '🍏',
        ),
        MealSlotPreset(
          presetId: 'snack_afternoon',
          label: 'Bữa xế chiều',
          icon: Icons.coffee_rounded,
          clayBgColor: AppColors.clayLunch,
          defaultRatio: 0.10,
          emoji: '☕',
        ),
        MealSlotPreset(
          presetId: 'snack_workout',
          label: 'Bữa trước / sau tập',
          icon: Icons.fitness_center_rounded,
          clayBgColor: AppColors.clayMint,
          defaultRatio: 0.10,
          emoji: '🏋️',
        ),
        MealSlotPreset(
          presetId: 'snack_late',
          label: 'Bữa khuya',
          icon: Icons.nightlight_round,
          clayBgColor: AppColors.clayDinner,
          defaultRatio: 0.10,
          emoji: '🌙',
        ),
      ];
}

class MealSlotPreset {
  const MealSlotPreset({
    required this.presetId,
    required this.label,
    required this.icon,
    required this.clayBgColor,
    required this.defaultRatio,
    required this.emoji,
  });

  final String presetId;
  final String label;
  final IconData icon;
  final Color clayBgColor;
  final double defaultRatio;
  final String emoji;
}
