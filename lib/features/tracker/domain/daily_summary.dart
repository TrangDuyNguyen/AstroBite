import 'entities/food_log.dart';

class DailySummary {
  const DailySummary({
    required this.date,
    required this.totalCalories,
    required this.targetCalories,
    required this.totalProteinG,
    required this.targetProteinG,
    required this.totalCarbsG,
    required this.targetCarbsG,
    required this.totalFatG,
    required this.targetFatG,
    required this.logs,
  });

  final String date;
  final int totalCalories;
  final int targetCalories;
  final int totalProteinG;
  final int targetProteinG;
  final int totalCarbsG;
  final int targetCarbsG;
  final int totalFatG;
  final int targetFatG;
  final List<FoodLog> logs;

  List<FoodLog> getMealLogs(String mealType) =>
      logs.where((l) => l.mealType == mealType).toList();

  int getMealCalories(String mealType) =>
      getMealLogs(mealType).fold(0, (sum, item) => sum + item.calories);

  factory DailySummary.fromLogs({
    required String date,
    required List<FoodLog> logs,
    int targetCalories = 2000,
  }) {
    int totalCal = 0;
    int protein = 0;
    int carbs = 0;
    int fat = 0;

    for (final log in logs) {
      totalCal += log.calories;
      protein += log.proteinG;
      carbs += log.carbsG;
      fat += log.fatG;
    }

    // Macro target defaults: 30% protein, 50% carbs, 20% fat
    final targetProtein = (targetCalories * 0.30 / 4).round();
    final targetCarbs = (targetCalories * 0.50 / 4).round();
    final targetFat = (targetCalories * 0.20 / 9).round();

    return DailySummary(
      date: date,
      totalCalories: totalCal,
      targetCalories: targetCalories,
      totalProteinG: protein,
      targetProteinG: targetProtein,
      totalCarbsG: carbs,
      targetCarbsG: targetCarbs,
      totalFatG: fat,
      targetFatG: targetFat,
      logs: logs,
    );
  }
}
