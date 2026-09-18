import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    int localCount = 0;
    try {
      final prefs = await SharedPreferences.getInstance();
      localCount = prefs.getInt('scan_count_${userId}_$date') ?? 0;
    } catch (_) {}

    try {
      final doc = await _aiUsageRef(userId, date).get();
      if (doc.exists && doc.data() != null) {
        final remoteCount = (doc.data()!['scanCount'] as num?)?.toInt() ?? 0;
        final maxCount = remoteCount > localCount ? remoteCount : localCount;
        // Keep local cache up to date
        if (remoteCount > localCount) {
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('scan_count_${userId}_$date', maxCount);
          } catch (_) {}
        }
        return maxCount;
      }
    } catch (_) {
      // Fallback to local count if Firestore is unreachable/offline
    }
    return localCount;
  }

  @override
  Future<void> incrementScanCount(String userId, String date) async {
    // 1. Immediately persist to local cache for instant rate-limiting
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'scan_count_${userId}_$date';
      final current = prefs.getInt(key) ?? 0;
      await prefs.setInt(key, current + 1);
    } catch (_) {}

    // 2. Persist to Firestore
    try {
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
    } catch (_) {
      // Offline fallback: local count was already saved
    }
  }

  @override
  Future<ScanResultDto?> scanFoodImage(Uint8List imageBytes) async {
    return _remoteDatasource.analyzeFoodImage(imageBytes);
  }
}
