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
