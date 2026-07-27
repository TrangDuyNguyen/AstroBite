import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile_dto.dart';
import '../../domain/profile_providers.dart';

final profileControllerProvider =
    StateNotifierProvider.autoDispose<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(ref);
});

class ProfileController extends StateNotifier<AsyncValue<void>> {
  ProfileController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<bool> saveProfile(UserProfileDto profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _ref.read(profileRepositoryProvider).saveProfile(profile);
    });
    return !state.hasError;
  }
}
