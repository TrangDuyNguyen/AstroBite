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
  });
}
