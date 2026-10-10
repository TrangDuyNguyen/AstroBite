/// Props for [MealQuickLogCard].
class MealQuickLogProps {
  const MealQuickLogProps({
    required this.dishName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.sodium,
    this.weightG = 100,
    this.mealType = 'lunch',
  });

  final String dishName;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int? sodium;
  final int weightG;
  final String mealType;

  factory MealQuickLogProps.fromMap(Map<String, dynamic> map) {
    final rawCal = map['calories'];
    final int cal = rawCal is num ? rawCal.round() : int.tryParse('$rawCal') ?? 0;

    final rawPro = map['protein'];
    final double pro = rawPro is num ? rawPro.toDouble() : double.tryParse('$rawPro') ?? 0.0;

    final rawCarb = map['carbs'];
    final double carb = rawCarb is num ? rawCarb.toDouble() : double.tryParse('$rawCarb') ?? 0.0;

    final rawFat = map['fat'];
    final double fatVal = rawFat is num ? rawFat.toDouble() : double.tryParse('$rawFat') ?? 0.0;

    final rawWeight = map['weightG'] ?? map['weight_g'] ?? map['portion_grams'];
    final int weight = rawWeight is num ? rawWeight.round() : int.tryParse('$rawWeight') ?? 100;

    final rawSodium = map['sodium'];
    final int? sodiumVal = rawSodium is num ? rawSodium.round() : int.tryParse('$rawSodium');

    return MealQuickLogProps(
      dishName: map['dishName']?.toString() ?? map['name']?.toString() ?? 'Gợi ý món ăn',
      calories: cal,
      protein: pro,
      carbs: carb,
      fat: fatVal,
      sodium: sodiumVal,
      weightG: weight > 0 ? weight : 100,
      mealType: map['mealType']?.toString() ?? 'lunch',
    );
  }

  Map<String, dynamic> toMap() => {
        'dishName': dishName,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        if (sodium != null) 'sodium': sodium,
        'weightG': weightG,
        'mealType': mealType,
      };
}
