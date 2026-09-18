import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/domain/entities/user_profile.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/features/profile/presentation/pages/profile_page.dart';
import 'package:astrobite/features/profile/presentation/widgets/bmr_tdee_card.dart';

class FakeUser implements User {
  @override
  String get uid => 'user123';

  @override
  String get email => 'test@astrobite.app';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ProfilePage Widget Tests', () {
    testWidgets('renders user profile details and BMR/TDEE card', (tester) async {
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
            home: ProfilePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check header and user email
      expect(find.text(AppStrings.profile), findsOneWidget);
      expect(find.text('test@astrobite.app'), findsOneWidget);

      // Check BmrTdeeCard is rendered
      expect(find.byType(BmrTdeeCard), findsOneWidget);
    });
  });
}
