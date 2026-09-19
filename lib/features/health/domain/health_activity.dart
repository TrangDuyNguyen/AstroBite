/// Domain entity representing a health activity data point.
class HealthActivity {
  const HealthActivity({
    required this.steps,
    required this.activeEnergyBurned,
    required this.workouts,
    required this.date,
  });

  final int steps;
  final double activeEnergyBurned;
  final List<WorkoutEntry> workouts;
  final DateTime date;

  double get totalWorkoutCalories =>
      workouts.fold(0.0, (sum, w) => sum + w.caloriesBurned);
}

class WorkoutEntry {
  const WorkoutEntry({
    required this.name,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  final String name;
  final int durationMinutes;
  final double caloriesBurned;

  String get icon {
    final lower = name.toLowerCase();
    if (lower.contains('run') || lower.contains('chạy')) return '🏃';
    if (lower.contains('gym') || lower.contains('weight')) return '💪';
    if (lower.contains('swim') || lower.contains('bơi')) return '🏊';
    if (lower.contains('bike') || lower.contains('đạp')) return '🚴';
    if (lower.contains('yoga')) return '🧘';
    return '🏋️';
  }
}

/// Energy balance calculation result.
class EnergyBalance {
  const EnergyBalance({
    required this.caloriesIn,
    required this.caloriesOut,
    required this.calorieTarget,
  });

  final double caloriesIn;
  final double caloriesOut;
  final int calorieTarget;

  double get netCalories => caloriesIn - caloriesOut;
  double get remaining => calorieTarget - netCalories;
  double get progress => calorieTarget > 0 ? netCalories / calorieTarget : 0;
  bool get isOverBudget => netCalories > calorieTarget;
}
