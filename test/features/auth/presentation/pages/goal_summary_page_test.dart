import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/auth/presentation/pages/goal_summary_page.dart';
import 'package:astrobite/features/profile/data/models/user_profile_dto.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/features/profile/domain/repositories/profile_repository.dart';

class FakeAuthRepo implements AuthRepository {
  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential> signInWithEmail({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> registerWithEmail({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {}

  @override
  Future<void> signOut() async {}
}

class FakeProfileRepo implements ProfileRepository {
  @override
  Stream<UserProfileDto?> watchProfile(String userId) => Stream.value(null);

  @override
  Future<UserProfileDto?> getProfile(String userId) async => null;

  @override
  Future<void> saveProfile(UserProfileDto profile) async {}
}

void main() {
  group('GoalSummaryPage Widget Tests', () {
    testWidgets('renders calculated targets and macro bars correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(FakeAuthRepo()),
            profileRepositoryProvider.overrideWithValue(FakeProfileRepo()),
          ],
          child: const MaterialApp(
            home: GoalSummaryPage(
              gender: 'male',
              birthYear: 1998,
              heightCm: 175,
              weightKg: 80,
              targetWeightKg: 75,
              activityLevel: 'light',
              fitnessGoal: 'lose_weight',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kế Hoạch Dinh Dưỡng'), findsOneWidget);
      expect(find.text('MỤC TIÊU HÀNG NGÀY'), findsOneWidget);
      expect(find.text('Bắt Đầu Hành Trình AstroBite'), findsOneWidget);
      expect(find.text('Carbohydrates (45%)'), findsOneWidget);
      expect(find.text('Protein (30%)'), findsOneWidget);
      expect(find.text('Chất Béo / Fat (25%)'), findsOneWidget);
    });
  });
}
