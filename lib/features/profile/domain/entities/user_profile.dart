import 'package:astrobite/core/utils/nutrition_calculator.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.gender,
    required this.birthYear,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    required this.dailyTargetCalories,
    this.isOnboardingCompleted = false,
    this.targetWeightKg,
    this.fitnessGoal = 'maintain',
  });

  final String uid;
  final String gender;
  final int birthYear;
  final double heightCm;
  final double weightKg;
  final String activityLevel;
  final int dailyTargetCalories;
  final bool isOnboardingCompleted;
  final double? targetWeightKg;
  final String fitnessGoal;

  int get age => DateTime.now().year - birthYear;

  double get bmr => NutritionCalculator.calculateBMR(
        weightKg: weightKg,
        heightCm: heightCm,
        age: age,
        gender: gender,
      );

  double get tdee => NutritionCalculator.calculateTDEE(
        bmr: bmr,
        activityLevel: activityLevel,
      );

  double get bmi {
    if (heightCm <= 0) return 0;
    final heightM = heightCm / 100.0;
    return weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    final val = bmi;
    if (val <= 0) return 'Chưa rõ';
    if (val < 18.5) return 'Gầy';
    if (val < 24.9) return 'Bình thường';
    if (val < 29.9) return 'Thừa cân';
    return 'Béo phì';
  }

  factory UserProfile.defaultProfile(String uid) {
    return UserProfile(
      uid: uid,
      gender: 'male',
      birthYear: 1995,
      heightCm: 170,
      weightKg: 65,
      activityLevel: 'moderate',
      dailyTargetCalories: 2000,
      isOnboardingCompleted: false,
      fitnessGoal: 'maintain',
    );
  }
}
