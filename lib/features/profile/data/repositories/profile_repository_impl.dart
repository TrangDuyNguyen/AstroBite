import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_dto.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({ProfileRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? ProfileRemoteDatasource();

  final ProfileRemoteDatasource _remoteDatasource;

  @override
  Stream<UserProfileDto?> watchProfile(String userId) {
    return _remoteDatasource.watchProfile(userId);
  }

  @override
  Future<UserProfileDto?> getProfile(String userId) {
    return _remoteDatasource.getProfile(userId);
  }

  @override
  Future<void> saveProfile(UserProfileDto profile) {
    return _remoteDatasource.saveProfile(profile);
  }
}
