import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    state = await AsyncValue.guard(() async {
      await _ref.read(authRepositoryProvider).signInWithEmail(
            email: email,
            password: password,
          );
    });
    return !state.hasError;
  }
}
