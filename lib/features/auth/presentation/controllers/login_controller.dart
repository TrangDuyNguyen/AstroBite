import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_error_handler.dart';
import '../../domain/auth_providers.dart';

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, AsyncValue<void>>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await _ref.read(authRepositoryProvider).signInWithEmail(
            email: email,
            password: password,
          );
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      final msg = AuthErrorHandler.getErrorMessage(e);
      state = AsyncError(Exception(msg), st);
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = const AsyncLoading();
    try {
      final credential =
          await _ref.read(authRepositoryProvider).signInWithGoogle();
      if (credential == null) {
        state = const AsyncData(null);
        return false;
      }
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      final msg = AuthErrorHandler.getErrorMessage(e);
      state = AsyncError(Exception(msg), st);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    state = const AsyncLoading();
    try {
      await _ref
          .read(authRepositoryProvider)
          .sendPasswordResetEmail(email: email);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      final msg = AuthErrorHandler.getErrorMessage(e);
      state = AsyncError(Exception(msg), st);
      return false;
    }
  }
}
