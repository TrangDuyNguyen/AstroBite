class FoodLog {
  const FoodLog({
    required this.id,
    required this.date,
    required this.mealType,
    required this.dishName,
    required this.estimatedWeightG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.source,
    this.confidenceScore,
    this.imageUrl,
  });

  final String id;
  final String date;
  final String mealType;
  final String dishName;
  final int estimatedWeightG;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final String source;
  final double? confidenceScore;
  final String? imageUrl;
}
