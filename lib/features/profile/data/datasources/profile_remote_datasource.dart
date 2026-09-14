import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_dto.dart';

class ProfileRemoteDatasource {
  ProfileRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userRef(String userId) =>
      _firestore.collection('users').doc(userId);

  Stream<UserProfileDto?> watchProfile(String userId) {
    return _userRef(userId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) return null;
          return UserProfileDto.fromJson({...snapshot.data()!, 'uid': userId});
        })
        .handleError((_) => null);
  }

  Future<UserProfileDto?> getProfile(String userId) async {
    try {
      final snapshot = await _userRef(userId).get();
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserProfileDto.fromJson({...snapshot.data()!, 'uid': userId});
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(UserProfileDto profile) async {
    await _userRef(profile.uid).set(profile.toJson(), SetOptions(merge: true));
  }
}
