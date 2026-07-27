import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../data/profile_repository.dart';
import 'entities/user_profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final userProfileStreamProvider = StreamProvider.autoDispose<UserProfile?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);

  final repo = ref.watch(profileRepositoryProvider);
  return repo.watchProfile(user.uid).map((dto) {
    if (dto == null) return UserProfile.defaultProfile(user.uid);
    return UserProfile(
      uid: dto.uid,
      gender: dto.gender,
      birthYear: dto.birthYear,
      heightCm: dto.heightCm,
      weightKg: dto.weightKg,
      activityLevel: dto.activityLevel,
      dailyTargetCalories: dto.dailyTargetCalories,
    );
  });
});
