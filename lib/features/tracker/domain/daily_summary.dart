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
    this.totalSodiumMg = 0.0,
    this.targetSodiumMg = 2300.0,
    this.totalFiberG = 0.0,
    this.targetFiberG = 25.0,
    this.totalSugarG = 0.0,
    this.targetSugarG = 36.0,
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
  final double totalSodiumMg;
  final double targetSodiumMg;
  final double totalFiberG;
  final double targetFiberG;
  final double totalSugarG;
  final double targetSugarG;

  List<FoodLog> getMealLogs(String mealType) =>
      logs.where((l) => l.mealType == mealType).toList();

  int getMealCalories(String mealType) =>
      getMealLogs(mealType).fold(0, (sum, item) => sum + item.calories);

  int getMealCarbs(String mealType) =>
      getMealLogs(mealType).fold(0, (sum, item) => sum + item.carbsG);

  int getMealProtein(String mealType) =>
      getMealLogs(mealType).fold(0, (sum, item) => sum + item.proteinG);

  int getMealFat(String mealType) =>
      getMealLogs(mealType).fold(0, (sum, item) => sum + item.fatG);

  factory DailySummary.fromLogs({
    required String date,
    required List<FoodLog> logs,
    int targetCalories = 2000,
    double targetSodiumMg = 2300.0,
    double targetFiberG = 25.0,
    double targetSugarG = 36.0,
  }) {
    int totalCal = 0;
    int protein = 0;
    int carbs = 0;
    int fat = 0;
    double sodium = 0.0;
    double fiber = 0.0;
    double sugar = 0.0;

    for (final log in logs) {
      totalCal += log.calories;
      protein += log.proteinG;
      carbs += log.carbsG;
      fat += log.fatG;
      sodium += log.sodiumMg;
      fiber += log.fiberG;
      sugar += log.sugarG;
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
      totalSodiumMg: sodium,
      targetSodiumMg: targetSodiumMg,
      totalFiberG: fiber,
      targetFiberG: targetFiberG,
      totalSugarG: sugar,
      targetSugarG: targetSugarG,
    );
  }
}
