/// Entity representing the parsed nutritional result from a voice recording.
class VoiceDishItem {
  const VoiceDishItem({
    required this.dishName,
    required this.estimatedWeightG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.notes,
  });

  final String dishName;
  final int estimatedWeightG;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String? notes;

  Map<String, dynamic> toMap() => {
        'dish_name': dishName,
        'estimated_weight_g': estimatedWeightG,
        'calories': calories,
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        if (notes != null) 'notes': notes,
      };

  factory VoiceDishItem.fromMap(Map<String, dynamic> map) {
    return VoiceDishItem(
      dishName: map['dish_name']?.toString() ?? 'Món ăn',
      estimatedWeightG: (map['estimated_weight_g'] as num?)?.round() ?? 100,
      calories: (map['calories'] as num?)?.round() ?? 0,
      proteinG: (map['protein_g'] as num?)?.toDouble() ?? 0.0,
      carbsG: (map['carbs_g'] as num?)?.toDouble() ?? 0.0,
      fatG: (map['fat_g'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes']?.toString(),
    );
  }
}

class VoiceLogResult {
  const VoiceLogResult({
    required this.rawTranscript,
    required this.mealType,
    required this.totalCalories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.sodiumMg,
    required this.dishes,
    this.confidenceScore = 0.9,
    this.createdAt,
  });

  final String rawTranscript;
  final String mealType;
  final int totalCalories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double? sodiumMg;
  final List<VoiceDishItem> dishes;
  final double confidenceScore;
  final DateTime? createdAt;

  String get primaryDishName {
    if (dishes.isEmpty) return 'Bữa ăn';
    if (dishes.length == 1) return dishes.first.dishName;
    return dishes.map((d) => d.dishName).join(', ');
  }

  int get totalWeightG =>
      dishes.fold(0, (sum, d) => sum + d.estimatedWeightG);

  Map<String, dynamic> toMap() => {
        'raw_transcript': rawTranscript,
        'meal_type': mealType,
        'total_calories': totalCalories,
        'protein_g': proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        if (sodiumMg != null) 'sodium_mg': sodiumMg,
        'dishes': dishes.map((d) => d.toMap()).toList(),
        'confidence_score': confidenceScore,
      };
}
