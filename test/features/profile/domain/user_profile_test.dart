import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/profile/domain/entities/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('calculates BMR and TDEE correctly', () {
      final profile = UserProfile(
        uid: 'user123',
        gender: 'male',
        birthYear: 1995, // 31 in 2026
        heightCm: 170,
        weightKg: 65,
        activityLevel: 'moderate',
        dailyTargetCalories: 2000,
      );

      expect(profile.age, 31);
      // BMR = 10*65 + 6.25*170 - 5*31 + 5 = 650 + 1062.5 - 155 + 5 = 1562.5
      expect(profile.bmr, 1562.5);
      // TDEE = 1562.5 * 1.55 = 2421.875
      expect(profile.tdee, 2421.875);
    });

    test('calculates female BMR and sedentary TDEE correctly', () {
      final profile = UserProfile(
        uid: 'user456',
        gender: 'female',
        birthYear: 1998,
        heightCm: 160,
        weightKg: 50,
        activityLevel: 'sedentary',
        dailyTargetCalories: 1600,
      );

      // BMR (female) = 10*50 + 6.25*160 - 5*(2026-1998) - 161
      // = 500 + 1000 - 140 - 161 = 1199.0
      expect(profile.bmr, 1199.0);
      // TDEE = 1199.0 * 1.2 = 1438.8
      expect(profile.tdee, closeTo(1438.8, 0.01));
    });

    test('defaultProfile provides valid defaults', () {
      final defaultProf = UserProfile.defaultProfile('uid-xyz');
      expect(defaultProf.uid, 'uid-xyz');
      expect(defaultProf.gender, 'male');
      expect(defaultProf.dailyTargetCalories, 2000);
      expect(defaultProf.isOnboardingCompleted, isFalse);
    });

    test('calculates BMI and BMI category correctly', () {
      final profile = UserProfile(
        uid: 'user-bmi',
        gender: 'male',
        birthYear: 1995,
        heightCm: 170,
        weightKg: 65,
        activityLevel: 'moderate',
        dailyTargetCalories: 2000,
      );

      // BMI = 65 / (1.7 * 1.7) = 22.4913...
      expect(profile.bmi, closeTo(22.49, 0.01));
      expect(profile.bmiCategory, 'Bình thường');

      final underweightProfile = UserProfile(
        uid: 'user-uw',
        gender: 'female',
        birthYear: 2000,
        heightCm: 165,
        weightKg: 45,
        activityLevel: 'light',
        dailyTargetCalories: 1500,
      );
      // BMI = 45 / (1.65 * 1.65) = 16.528...
      expect(underweightProfile.bmiCategory, 'Gầy');
    });
  });
}
