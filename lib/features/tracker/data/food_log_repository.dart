import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/food_log_dto.dart';

class FoodLogRepository {
  FoodLogRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _foodLogsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('foodLogs');

  Stream<List<FoodLogDto>> watchDailyLogs({
    required String userId,
    required String date,
  }) {
    return _foodLogsRef(userId)
        .where('date', isEqualTo: date)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FoodLogDto.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Future<void> addFoodLog({
    required String userId,
    required FoodLogDto log,
  }) async {
    final docRef = _foodLogsRef(userId).doc();
    await docRef.set(log.copyWith(id: docRef.id).toJson());
  }

  Future<void> deleteFoodLog({
    required String userId,
    required String logId,
  }) async {
    await _foodLogsRef(userId).doc(logId).delete();
  }

  Future<List<FoodLogDto>> getLogsForDateRange({
    required String userId,
    required String startDate,
    required String endDate,
  }) async {
    final snapshot = await _foodLogsRef(userId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();

    return snapshot.docs
        .map((doc) => FoodLogDto.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
