class ScanResult {
  const ScanResult({
    required this.isFood,
    required this.totalCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.dishes,
  });

  final bool isFood;
  final int totalCalories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final List<DishItem> dishes;

  int get totalWeightG => dishes.fold(0, (sum, d) => sum + d.estimatedWeightG);
  String get primaryDishName => dishes.isNotEmpty ? dishes.first.dishName : 'Món ăn';
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
      dishes: dishes
          .map((d) => DishItem(
                dishName: d.dishName,
                confidenceScore: d.confidenceScore,
                estimatedWeightG: (d.estimatedWeightG * ratio).round(),
                calories: (d.calories * ratio).round(),
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
  });

  String dishName;
  double confidenceScore;
  int estimatedWeightG;
  int calories;
}

