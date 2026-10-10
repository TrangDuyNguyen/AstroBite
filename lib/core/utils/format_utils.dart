/// Pure formatting utilities for numbers, calories, weights, and percentages.
library;

class FormatUtils {
  const FormatUtils._();

  /// Formats a large number to compact representation (e.g. 1500 -> '1.5k', 500 -> '500').
  static String formatCompactNumber(int number) {
    if (number < 1000) return '$number';
    final val = number / 1000.0;
    if (val == val.roundToDouble()) {
      return '${val.toInt()}k';
    }
    return '${val.toStringAsFixed(1)}k';
  }

  /// Formats calorie count with unit (e.g. 2100 -> '2100 kcal').
  static String formatCalories(int calories) {
    return '$calories kcal';
  }

  /// Formats weight in grams (e.g. 150 -> '150g').
  static String formatWeight(int weightG) {
    return '${weightG}g';
  }

  /// Formats a fraction to percentage string (e.g. 0.75 -> '75%').
  static String formatPercentage(double fraction) {
    return '${(fraction * 100).round()}%';
  }
}
