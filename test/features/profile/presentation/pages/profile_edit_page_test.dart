import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/domain/entities/user_profile.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:astrobite/features/profile/presentation/widgets/biological_info_card.dart';
import 'package:astrobite/features/profile/presentation/widgets/fitness_goal_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeUser implements User {
  @override
  String get uid => 'user123';

  @override
  String get email => 'test@astrobite.app';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ProfileEditPage Widget Tests', () {
    testWidgets('renders BiologicalInfoCard, FitnessGoalCard and Save button correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final fakeUser = FakeUser();
      final profile = UserProfile(
        uid: 'user123',
        gender: 'male',
        birthYear: 1995,
        heightCm: 175,
        weightKg: 70,
        activityLevel: 'moderate',
        dailyTargetCalories: 2200,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(fakeUser)),
            userProfileStreamProvider.overrideWith((ref) => Stream.value(profile)),
          ],
          child: const MaterialApp(
            home: ProfileEditPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify title
      expect(find.text('Chỉnh sửa hồ sơ'), findsOneWidget);

      // Verify both modular cards are rendered
      expect(find.byType(BiologicalInfoCard), findsOneWidget);
      expect(find.byType(FitnessGoalCard), findsOneWidget);

      // Verify fields
      expect(find.text('Thông tin sinh học'), findsOneWidget);
      expect(find.text('Mục tiêu & Chế độ vận động'), findsOneWidget);
      expect(find.text('Lưu thay đổi'), findsOneWidget);
    });
  });
}
