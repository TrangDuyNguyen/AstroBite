import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/auth/presentation/controllers/login_controller.dart';

class FakeUserCredential implements UserCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthRepository implements AuthRepository {
  bool shouldThrow = false;
  dynamic errorToThrow;
  UserCredential? googleCredentialToReturn;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) {
      throw errorToThrow ?? Exception('Login failed');
    }
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
  Future<UserCredential?> signInWithGoogle() async {
    if (shouldThrow) {
      throw errorToThrow ?? Exception('Google sign in failed');
    }
    return googleCredentialToReturn;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    if (shouldThrow) {
      throw errorToThrow ?? Exception('Reset email failed');
    }
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  late FakeAuthRepository fakeAuthRepository;
  late ProviderContainer container;

  setUp(() {
    fakeAuthRepository = FakeAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginController - Email Login', () {
    test('initial state is AsyncData(null)', () {
      final state = container.read(loginControllerProvider);
      expect(state, equals(const AsyncData<void>(null)));
    });

    test('login with valid credentials returns true and sets AsyncData', () async {
      final notifier = container.read(loginControllerProvider.notifier);
      final result = await notifier.login(
        email: 'user@astrobite.io',
        password: 'Password123',
      );

      expect(result, isTrue);
      expect(container.read(loginControllerProvider), equals(const AsyncData<void>(null)));
    });

    test('login with invalid credentials returns false and sets friendly AsyncError', () async {
      fakeAuthRepository.shouldThrow = true;
      fakeAuthRepository.errorToThrow = FirebaseAuthException(code: 'wrong-password');

      final notifier = container.read(loginControllerProvider.notifier);
      final result = await notifier.login(
        email: 'user@astrobite.io',
        password: 'WrongPassword',
      );

      expect(result, isFalse);
      final state = container.read(loginControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Mật khẩu không chính xác'));
    });
  });

  group('LoginController - Google Sign In', () {
    test('loginWithGoogle returns true when credential is received', () async {
      fakeAuthRepository.googleCredentialToReturn = FakeUserCredential();

      final notifier = container.read(loginControllerProvider.notifier);
      final result = await notifier.loginWithGoogle();

      expect(result, isTrue);
      expect(container.read(loginControllerProvider).hasError, isFalse);
    });

    test('loginWithGoogle returns false when user cancels (null credential)', () async {
      fakeAuthRepository.googleCredentialToReturn = null;

      final notifier = container.read(loginControllerProvider.notifier);
      final result = await notifier.loginWithGoogle();

      expect(result, isFalse);
      expect(container.read(loginControllerProvider).hasError, isFalse);
    });

    test('loginWithGoogle returns false and sets AsyncError on exception', () async {
      fakeAuthRepository.shouldThrow = true;
      fakeAuthRepository.errorToThrow = FirebaseAuthException(code: 'network-request-failed');

      final notifier = container.read(loginControllerProvider.notifier);
      final result = await notifier.loginWithGoogle();

      expect(result, isFalse);
      final state = container.read(loginControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Lỗi kết nối mạng'));
    });
  });

  group('LoginController - Password Reset', () {
    test('sendPasswordResetEmail returns true on success', () async {
      final notifier = container.read(loginControllerProvider.notifier);
      final result = await notifier.sendPasswordResetEmail(email: 'user@astrobite.io');

      expect(result, isTrue);
      expect(container.read(loginControllerProvider).hasError, isFalse);
    });

    test('sendPasswordResetEmail returns false on invalid-email error', () async {
      fakeAuthRepository.shouldThrow = true;
      fakeAuthRepository.errorToThrow = FirebaseAuthException(code: 'invalid-email');

      final notifier = container.read(loginControllerProvider.notifier);
      final result = await notifier.sendPasswordResetEmail(email: 'invalid-email');

      expect(result, isFalse);
      final state = container.read(loginControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error.toString(), contains('Địa chỉ email không đúng định dạng'));
    });
  });
}
