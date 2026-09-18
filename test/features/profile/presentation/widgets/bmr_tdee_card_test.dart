import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/profile/domain/entities/user_profile.dart';
import 'package:astrobite/features/profile/presentation/widgets/bmr_tdee_card.dart';

void main() {
  group('BmrTdeeCard Widget Tests', () {
    testWidgets('renders BMR and TDEE values correctly', (tester) async {
      final profile = UserProfile(
        uid: 'user123',
        gender: 'male',
        birthYear: 1995,
        heightCm: 170,
        weightKg: 65,
        activityLevel: 'moderate',
        dailyTargetCalories: 2000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BmrTdeeCard(profile: profile),
          ),
        ),
      );

      // Check card title
      expect(find.text('Chỉ số năng lượng (BMR & TDEE)'), findsOneWidget);

      // Check metrics labels
      expect(find.text('BMR'), findsOneWidget);
      expect(find.text('TDEE'), findsOneWidget);

      // Check values (BMR = 1563 kcal rounded, TDEE = 2422 kcal rounded)
      expect(find.text('${profile.bmr.round()} kcal'), findsOneWidget);
      expect(find.text('${profile.tdee.round()} kcal'), findsOneWidget);

      // Check subtitles
      expect(find.text('Năng lượng nghỉ ngơi'), findsOneWidget);
      expect(find.text('Năng lượng tiêu thụ/ngày'), findsOneWidget);
    });
  });
}
