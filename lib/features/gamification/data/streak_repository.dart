import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/streak_record.dart';

/// Repository handling persistence and synchronization of [StreakRecord].
/// ASTRO-015: Uses SharedPreferences for durable offline persistence across restarts.
class StreakRepository {
  StreakRepository({
    FirebaseFirestore? firestore,
    SharedPreferences? prefs,
  })  : _firestore = firestore,
        _prefs = prefs;

  final FirebaseFirestore? _firestore;
  SharedPreferences? _prefs;

  // In-memory local cache for instant zero-latency retrieval (Ponytail local-first)
  final Map<String, StreakRecord> _localCache = {};

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  Future<SharedPreferences> _getPrefs() async =>
      _prefs ??= await SharedPreferences.getInstance();

  String _cacheKey(String userId) => 'streak_record_$userId';

  /// Loads streak record for [userId] (local cache -> SharedPreferences -> Firestore fallback).
  Future<StreakRecord> getStreak(String userId) async {
    if (_localCache.containsKey(userId)) {
      return _localCache[userId]!;
    }

    // 1. Try durable disk cache first (offline-safe across app restarts)
    try {
      final prefs = await _getPrefs();
      final cachedJson = prefs.getString(_cacheKey(userId));
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final map = jsonDecode(cachedJson) as Map<String, dynamic>;
        final diskRecord = StreakRecord.fromMap(map);
        _localCache[userId] = diskRecord;
        return diskRecord;
      }
    } catch (_) {
      // SharedPreferences read failure fallback
    }

    // 2. Fallback to remote Firestore if no local disk cache
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
        await _saveToDisk(userId, record);
        return record;
      }
    } catch (_) {
      // Local fallback or offline
    }

    final initial = StreakRecord.initial();
    _localCache[userId] = initial;
    await _saveToDisk(userId, initial);
    return initial;
  }

  /// Saves [record] to in-memory cache, durable disk cache, and synchronizes with Firestore.
  Future<void> saveStreak(String userId, StreakRecord record) async {
    _localCache[userId] = record;
    await _saveToDisk(userId, record);

    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('gamification')
          .doc('streak')
          .set(record.toMap(), SetOptions(merge: true));
    } catch (_) {
      // Offline: disk cache already persists changes for next sync
    }
  }

  Future<void> _saveToDisk(String userId, StreakRecord record) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_cacheKey(userId), jsonEncode(record.toMap()));
    } catch (_) {
      // Ignore disk write failure
    }
  }

  /// Clears in-memory cache and local disk cache (useful for sign-out or tests).
  Future<void> clearCache({String? userId}) async {
    _localCache.clear();
    try {
      final prefs = await _getPrefs();
      if (userId != null) {
        await prefs.remove(_cacheKey(userId));
      }
    } catch (_) {
      // Best effort
    }
  }
}
