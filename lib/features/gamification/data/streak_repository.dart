import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/streak_record.dart';

/// Repository handling persistence and synchronization of [StreakRecord].
class StreakRepository {
  StreakRepository({FirebaseFirestore? firestore})
      : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  // In-memory local cache for instant zero-latency retrieval (Ponytail local-first)
  final Map<String, StreakRecord> _localCache = {};

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  /// Loads streak record for [userId] (local cache first, then Firestore fallback).
  Future<StreakRecord> getStreak(String userId) async {
    if (_localCache.containsKey(userId)) {
      return _localCache[userId]!;
    }

    try {
      final doc = await _db
          .collection('users')
          .doc(userId)
          .collection('gamification')
          .doc('streak')
          .get();

      if (doc.exists && doc.data() != null) {
        final record = StreakRecord.fromMap(doc.data()!);
        _localCache[userId] = record;
        return record;
      }
    } catch (_) {
      // Local fallback or offline
    }

    final initial = StreakRecord.initial();
    _localCache[userId] = initial;
    return initial;
  }

  /// Saves [record] to local cache and synchronizes with Firestore.
  Future<void> saveStreak(String userId, StreakRecord record) async {
    _localCache[userId] = record;

    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('gamification')
          .doc('streak')
          .set(record.toMap(), SetOptions(merge: true));
    } catch (_) {
      // Offline: will sync on next active connection
    }
  }

  /// Clears in-memory cache (useful for sign-out or tests).
  void clearCache() {
    _localCache.clear();
  }
}
