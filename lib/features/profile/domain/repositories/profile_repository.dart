import '../../data/models/user_profile_dto.dart';

abstract class ProfileRepository {
  Stream<UserProfileDto?> watchProfile(String userId);
  Future<UserProfileDto?> getProfile(String userId);
  Future<void> saveProfile(UserProfileDto profile);
}
