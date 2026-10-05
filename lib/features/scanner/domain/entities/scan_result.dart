class ScanResult {
  const ScanResult({
    required this.isFood,
    required this.totalCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.dishes,
    this.sodiumMg = 0.0,
    this.fiberG = 0.0,
    this.sugarG = 0.0,
  });

  final bool isFood;
  final int totalCalories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final double sodiumMg;
  final double fiberG;
  final double sugarG;
  final List<DishItem> dishes;

  List<DishItem> get activeDishes =>
      dishes.where((d) => d.isSelected).toList();

  int get totalWeightG => dishes.fold(0, (sum, d) => sum + d.estimatedWeightG);
  int get activeWeightG =>
      activeDishes.fold(0, (sum, d) => sum + d.estimatedWeightG);

  T _activeValue<T extends num>(
    T total,
    T Function(DishItem d) effectiveGetter,
    T Function(DishItem d) originalGetter,
    T zero,
  ) {
    if (activeDishes.isEmpty) return zero;
    if (activeDishes.length == dishes.length) {
      if (T == double) {
        final deductions = activeDishes.fold<double>(
          0.0,
          (sum, d) => sum + ((originalGetter(d) as double) - (effectiveGetter(d) as double)),
        );
        final result = (total as double) - deductions;
        return (result < 0 ? 0.0 : result) as T;
      } else {
        final deductions = activeDishes.fold<int>(
          0,
          (sum, d) => sum + ((originalGetter(d) as int) - (effectiveGetter(d) as int)),
        );
        final result = (total as int) - deductions;
        return (result < 0 ? 0 : result) as T;
      }
    }
    return activeDishes.fold(zero, (sum, d) => (sum + effectiveGetter(d)) as T);
  }

  int get activeCalories => _activeValue(totalCalories, (d) => d.effectiveCalories, (d) => d.calories, 0);
  int get activeProteinG => _activeValue(proteinG, (d) => d.effectiveProteinG, (d) => d.proteinG, 0);
  int get activeCarbsG => _activeValue(carbsG, (d) => d.effectiveCarbsG, (d) => d.carbsG, 0);
  int get activeFatG => _activeValue(fatG, (d) => d.effectiveFatG, (d) => d.fatG, 0);
  double get activeSodiumMg => _activeValue(sodiumMg, (d) => d.effectiveSodiumMg, (d) => d.sodiumMg, 0.0);
  double get activeFiberG => _activeValue(fiberG, (d) => d.fiberG, (d) => d.fiberG, 0.0);
  double get activeSugarG => _activeValue(sugarG, (d) => d.sugarG, (d) => d.sugarG, 0.0);

  String get primaryDishName {
    if (activeDishes.isEmpty) {
      return dishes.isNotEmpty ? dishes.first.dishName : 'Món ăn';
    }
    if (activeDishes.length == 1) return activeDishes.first.dishName;
    return activeDishes.map((d) => d.dishName).join(', ');
  }

  double get primaryConfidenceScore =>
      dishes.isNotEmpty ? dishes.first.confidenceScore : 0.85;

  ScanResult scaleToWeight(int newWeightG) {
    final baseWeight = totalWeightG > 0 ? totalWeightG : 300;
    final ratio = newWeightG / baseWeight;
    return ScanResult(
      isFood: isFood,
      totalCalories: (totalCalories * ratio).round(),
      proteinG: (proteinG * ratio).round(),
      carbsG: (carbsG * ratio).round(),
      fatG: (fatG * ratio).round(),
      sodiumMg: sodiumMg * ratio,
      fiberG: fiberG * ratio,
      sugarG: sugarG * ratio,
      dishes: dishes
          .map((d) => DishItem(
                dishName: d.dishName,
                confidenceScore: d.confidenceScore,
                estimatedWeightG: (d.estimatedWeightG * ratio).round(),
                calories: (d.calories * ratio).round(),
                carbsG: (d.carbsG * ratio).round(),
                proteinG: (d.proteinG * ratio).round(),
                fatG: (d.fatG * ratio).round(),
                sodiumMg: d.sodiumMg * ratio,
                fiberG: d.fiberG * ratio,
                sugarG: d.sugarG * ratio,
                isSelected: d.isSelected,
                hasBroth: d.hasBroth,
                brothCalories: (d.brothCalories * ratio).round(),
                brothSodiumMg: d.brothSodiumMg * ratio,
                includeBroth: d.includeBroth,
                subItems: d.subItems
                    .map((s) => s.copyWith(
                          calories: (s.calories * ratio).round(),
                          carbsG: (s.carbsG * ratio).round(),
                          proteinG: (s.proteinG * ratio).round(),
                          fatG: (s.fatG * ratio).round(),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}

class SubDishItem {
  SubDishItem({
    required this.name,
    required this.calories,
    this.carbsG = 0,
    this.proteinG = 0,
    this.fatG = 0,
    this.isSelected = true,
  });

  String name;
  int calories;
  int carbsG;
  int proteinG;
  int fatG;
  bool isSelected;

  SubDishItem copyWith({
    String? name,
    int? calories,
    int? carbsG,
    int? proteinG,
    int? fatG,
    bool? isSelected,
  }) {
    return SubDishItem(
      name: name ?? this.name,
      calories: calories ?? this.calories,
      carbsG: carbsG ?? this.carbsG,
      proteinG: proteinG ?? this.proteinG,
      fatG: fatG ?? this.fatG,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class DishItem {
  DishItem({
    required this.dishName,
    required this.confidenceScore,
    required this.estimatedWeightG,
    required this.calories,
    this.carbsG = 0,
    this.proteinG = 0,
    this.fatG = 0,
    this.sodiumMg = 0.0,
    this.fiberG = 0.0,
    this.sugarG = 0.0,
    this.isSelected = true,
    this.hasBroth = false,
    this.brothCalories = 0,
    this.brothSodiumMg = 0.0,
    this.includeBroth = true,
    List<SubDishItem>? subItems,
  }) : subItems = subItems ?? [];

  String dishName;
  double confidenceScore;
  int estimatedWeightG;
  int calories;
  int carbsG;
  int proteinG;
  int fatG;
  double sodiumMg;
  double fiberG;
  double sugarG;
  bool isSelected;
  bool hasBroth;
  int brothCalories;
  double brothSodiumMg;
  bool includeBroth;
  List<SubDishItem> subItems;

  int get effectiveCalories {
    int cal = calories;
    if (hasBroth && !includeBroth) {
      cal = (cal - brothCalories).clamp(0, cal);
    }
    if (subItems.isNotEmpty) {
      for (final s in subItems) {
        if (!s.isSelected) {
          cal = (cal - s.calories).clamp(0, cal);
        }
      }
    }
    return cal;
  }

  double get effectiveSodiumMg {
    double sod = sodiumMg;
    if (hasBroth && !includeBroth) {
      sod = (sod - brothSodiumMg).clamp(0.0, sod);
    }
    return sod;
  }

  int get effectiveFatG {
    int fat = fatG;
    if (hasBroth && !includeBroth && brothCalories > 0) {
      final brothFat = (brothCalories * 0.4 / 9).round();
      fat = (fat - brothFat).clamp(0, fat);
    }
    if (subItems.isNotEmpty) {
      for (final s in subItems) {
        if (!s.isSelected && s.fatG > 0) {
          fat = (fat - s.fatG).clamp(0, fat);
        }
      }
    }
    return fat;
  }

  int get effectiveCarbsG {
    int carbs = carbsG;
    if (subItems.isNotEmpty) {
      for (final s in subItems) {
        if (!s.isSelected && s.carbsG > 0) {
          carbs = (carbs - s.carbsG).clamp(0, carbs);
        }
      }
    }
    return carbs;
  }

  int get effectiveProteinG {
    int protein = proteinG;
    if (subItems.isNotEmpty) {
      for (final s in subItems) {
        if (!s.isSelected && s.proteinG > 0) {
          protein = (protein - s.proteinG).clamp(0, protein);
        }
      }
    }
    return protein;
  }

  DishItem copyWith({
    String? dishName,
    double? confidenceScore,
    int? estimatedWeightG,
    int? calories,
    int? carbsG,
    int? proteinG,
    int? fatG,
    double? sodiumMg,
    double? fiberG,
    double? sugarG,
    bool? isSelected,
    bool? hasBroth,
    int? brothCalories,
    double? brothSodiumMg,
    bool? includeBroth,
    List<SubDishItem>? subItems,
  }) {
    return DishItem(
      dishName: dishName ?? this.dishName,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      estimatedWeightG: estimatedWeightG ?? this.estimatedWeightG,
      calories: calories ?? this.calories,
      carbsG: carbsG ?? this.carbsG,
      proteinG: proteinG ?? this.proteinG,
      fatG: fatG ?? this.fatG,
      sodiumMg: sodiumMg ?? this.sodiumMg,
      fiberG: fiberG ?? this.fiberG,
      sugarG: sugarG ?? this.sugarG,
      isSelected: isSelected ?? this.isSelected,
      hasBroth: hasBroth ?? this.hasBroth,
      brothCalories: brothCalories ?? this.brothCalories,
      brothSodiumMg: brothSodiumMg ?? this.brothSodiumMg,
      includeBroth: includeBroth ?? this.includeBroth,
      subItems: subItems ?? this.subItems.map((s) => s.copyWith()).toList(),
    );
  }
}


