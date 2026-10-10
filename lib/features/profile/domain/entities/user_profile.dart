import 'package:astrobite/core/constants/profile_enums.dart';
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

  Gender get genderEnum => Gender.fromValue(gender);
  ActivityLevel get activityLevelEnum => ActivityLevel.fromValue(activityLevel);
  FitnessGoal get fitnessGoalEnum => FitnessGoal.fromValue(fitnessGoal);

  int get age => DateTime.now().year - birthYear;

  double get bmr => NutritionCalculator.calculateBMR(
        weightKg: weightKg,
        heightCm: heightCm,
        age: age,
        gender: genderEnum,
      );

  double get tdee => NutritionCalculator.calculateTDEE(
        bmr: bmr,
        activityLevel: activityLevelEnum,
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
      gender: ProfileDefaults.gender.value,
      birthYear: ProfileDefaults.birthYear,
      heightCm: ProfileDefaults.heightCm,
      weightKg: ProfileDefaults.weightKg,
      activityLevel: ProfileDefaults.activityLevel.value,
      dailyTargetCalories: ProfileDefaults.dailyTargetCalories,
      isOnboardingCompleted: false,
      fitnessGoal: ProfileDefaults.fitnessGoal.value,
    );
  }
}
