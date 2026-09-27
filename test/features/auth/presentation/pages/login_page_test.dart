import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/auth/presentation/pages/login_page.dart';
import 'package:astrobite/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

class FakeUserCredential implements UserCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthRepository implements AuthRepository {
  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return FakeUserCredential();
  }

  @override
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return FakeUserCredential();
  }

  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {}

  @override
  Future<void> signOut() async {}
}

Widget createTestWidget() {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    ],
    child: const MaterialApp(
      home: LoginPage(),
    ),
  );
}

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('renders all essential login elements', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check header
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text('Đăng nhập để theo dõi mục tiêu dinh dưỡng'), findsOneWidget);

      // Check input fields
      expect(find.widgetWithText(TextFormField, AppStrings.email), findsOneWidget);
      expect(find.widgetWithText(TextFormField, AppStrings.password), findsOneWidget);

      // Check buttons and links
      expect(find.text(AppStrings.forgotPassword), findsOneWidget);
      expect(find.widgetWithText(ClayButton, AppStrings.login), findsOneWidget);
      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('Chưa có tài khoản?'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('toggles password visibility when eye icon is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially password field is obscured and shows visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap eye icon to show password
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap again to hide password
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('displays validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Login button with empty inputs
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle();

      expect(find.text('Email không hợp lệ'), findsOneWidget);
      expect(find.text('Mật khẩu tối thiểu 6 ký tự'), findsOneWidget);
    });

    testWidgets('opens forgot password dialog and closes on Cancel', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap Forgot Password
      await tester.tap(find.text(AppStrings.forgotPassword));
      await tester.pumpAndSettle();

      // Dialog should be open
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(AppStrings.resetPassword), findsOneWidget);
      expect(find.text(AppStrings.sendResetLink), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
