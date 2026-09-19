import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/health/domain/health_activity.dart';

void main() {
  group('HealthActivity & EnergyBalance Domain Tests', () {
    test('WorkoutEntry returns correct emoji icon for various activity names', () {
      const running = WorkoutEntry(name: 'Outdoor Running', durationMinutes: 30, caloriesBurned: 280);
      expect(running.icon, equals('🏃'));

      const joggingVi = WorkoutEntry(name: 'Chạy bộ công viên', durationMinutes: 20, caloriesBurned: 180);
      expect(joggingVi.icon, equals('🏃'));

      const gym = WorkoutEntry(name: 'Gym Workout', durationMinutes: 45, caloriesBurned: 220);
      expect(gym.icon, equals('💪'));

      const swim = WorkoutEntry(name: 'Bơi lội tự do', durationMinutes: 30, caloriesBurned: 250);
      expect(swim.icon, equals('🏊'));

      const bike = WorkoutEntry(name: 'Đạp xe ngoài trời', durationMinutes: 40, caloriesBurned: 300);
      expect(bike.icon, equals('🚴'));

      const yoga = WorkoutEntry(name: 'Vinyasa Yoga', durationMinutes: 50, caloriesBurned: 150);
      expect(yoga.icon, equals('🧘'));

      const general = WorkoutEntry(name: 'General Training', durationMinutes: 25, caloriesBurned: 120);
      expect(general.icon, equals('🏋️'));
    });

    test('HealthActivity calculates total workout calories correctly', () {
      final now = DateTime(2026, 9, 19);
      final activity = HealthActivity(
        steps: 8420,
        activeEnergyBurned: 450.0,
        workouts: const [
          WorkoutEntry(name: 'Running', durationMinutes: 30, caloriesBurned: 250.0),
          WorkoutEntry(name: 'Yoga', durationMinutes: 20, caloriesBurned: 100.0),
        ],
        date: now,
      );

      expect(activity.steps, equals(8420));
      expect(activity.activeEnergyBurned, equals(450.0));
      expect(activity.totalWorkoutCalories, equals(350.0));
    });

    test('EnergyBalance computes net calories, remaining, progress and budget warning', () {
      // Normal balance within budget: In: 1800, Out: 400, Target: 2000
      // Net = 1400, Remaining = 600, Progress = 1400/2000 = 0.70
      const normal = EnergyBalance(
        caloriesIn: 1800,
        caloriesOut: 400,
        calorieTarget: 2000,
      );

      expect(normal.netCalories, equals(1400));
      expect(normal.remaining, equals(600));
      expect(normal.progress, closeTo(0.70, 0.001));
      expect(normal.isOverBudget, isFalse);

      // Over budget: In: 2600, Out: 200, Target: 2000
      // Net = 2400, Remaining = -400, isOverBudget = true
      const over = EnergyBalance(
        caloriesIn: 2600,
        caloriesOut: 200,
        calorieTarget: 2000,
      );

      expect(over.netCalories, equals(2400));
      expect(over.remaining, equals(-400));
      expect(over.isOverBudget, isTrue);
    });

    test('EnergyBalance handles zero target gracefully', () {
      const zeroTarget = EnergyBalance(
        caloriesIn: 1500,
        caloriesOut: 300,
        calorieTarget: 0,
      );

      expect(zeroTarget.progress, equals(0));
      expect(zeroTarget.isOverBudget, isTrue);
    });
  });
}
