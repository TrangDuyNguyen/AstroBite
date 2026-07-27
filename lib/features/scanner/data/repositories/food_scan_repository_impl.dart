import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/food_scan_repository.dart';
import '../datasources/gemini_remote_datasource.dart';
import '../models/scan_result_dto.dart';

class FoodScanRepositoryImpl implements FoodScanRepository {
  FoodScanRepositoryImpl({
    GeminiRemoteDatasource? remoteDatasource,
    FirebaseFirestore? firestore,
  })  : _remoteDatasource = remoteDatasource ?? GeminiRemoteDatasource(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final GeminiRemoteDatasource _remoteDatasource;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _aiUsageRef(String userId, String date) =>
      _firestore.collection('users').doc(userId).collection('aiUsage').doc(date);

  @override
  Future<int> getTodayScanCount(String userId, String date) async {
    final doc = await _aiUsageRef(userId, date).get();
    if (!doc.exists || doc.data() == null) return 0;
    return (doc.data()!['scanCount'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<void> incrementScanCount(String userId, String date) async {
    final ref = _aiUsageRef(userId, date);
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) {
        transaction.set(ref, {
          'scanCount': 1,
          'lastScannedAt': FieldValue.serverTimestamp(),
        });
      } else {
        final current = (doc.data()?['scanCount'] as num?)?.toInt() ?? 0;
        transaction.update(ref, {
          'scanCount': current + 1,
          'lastScannedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Future<ScanResultDto?> scanFoodImage(Uint8List imageBytes) async {
    return _remoteDatasource.analyzeFoodImage(imageBytes);
  }
}
