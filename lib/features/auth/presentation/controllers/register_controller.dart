import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/auth_providers.dart';

final registerControllerProvider =
    StateNotifierProvider.autoDispose<RegisterController, AsyncValue<void>>((ref) {
  return RegisterController(ref);
});

class RegisterController extends StateNotifier<AsyncValue<void>> {
  RegisterController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _ref.read(authRepositoryProvider).registerWithEmail(
            email: email,
            password: password,
          );
    });
    return !state.hasError;
  }
}
