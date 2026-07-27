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
  });

  final String uid;
  final String gender;
  final int birthYear;
  final double heightCm;
  final double weightKg;
  final String activityLevel;
  final int dailyTargetCalories;

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

  factory UserProfile.defaultProfile(String uid) {
    return UserProfile(
      uid: uid,
      gender: 'male',
      birthYear: 1995,
      heightCm: 170,
      weightKg: 65,
      activityLevel: 'moderate',
      dailyTargetCalories: 2000,
    );
  }
}
