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

  T _activeValue<T extends num>(T total, T Function(DishItem d) getter, T zero) {
    if (activeDishes.isEmpty) return zero;
    if (activeDishes.length == dishes.length) return total;
    return activeDishes.fold(zero, (sum, d) => (sum + getter(d)) as T);
  }

  int get activeCalories => _activeValue(totalCalories, (d) => d.calories, 0);
  int get activeProteinG => _activeValue(proteinG, (d) => d.proteinG, 0);
  int get activeCarbsG => _activeValue(carbsG, (d) => d.carbsG, 0);
  int get activeFatG => _activeValue(fatG, (d) => d.fatG, 0);
  double get activeSodiumMg => _activeValue(sodiumMg, (d) => d.sodiumMg, 0.0);
  double get activeFiberG => _activeValue(fiberG, (d) => d.fiberG, 0.0);
  double get activeSugarG => _activeValue(sugarG, (d) => d.sugarG, 0.0);

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
              ))
          .toList(),
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
  });

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
    );
  }
}


