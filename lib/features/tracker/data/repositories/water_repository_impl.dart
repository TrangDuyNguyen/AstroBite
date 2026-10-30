import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/repositories/water_repository.dart';

/// Cache-First Water Repository implementation using SharedPreferences and Cloud Firestore
/// ASTRO-014: Equipped with a durable offline pending-sync queue across app lifecycles.
class WaterRepositoryImpl implements WaterRepository {
  WaterRepositoryImpl({
    SharedPreferences? prefs,
    FirebaseFirestore? firestore,
  })  : _prefs = prefs,
        _firestore = firestore;

  SharedPreferences? _prefs;
  final FirebaseFirestore? _firestore;

  Future<SharedPreferences> _getPrefs() async =>
      _prefs ??= await SharedPreferences.getInstance();

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  String _cacheKey(String userId, String date) => 'water_log_${userId}_$date';
  String _pendingKey(String userId) => 'pending_water_sync_$userId';

  DocumentReference<Map<String, dynamic>> _docRef(String userId, String date) =>
      _db.collection('users').doc(userId).collection('water_logs').doc(date.replaceAll('-', ''));

  @override
  Future<WaterDayLog> getDailyWater({
    required String userId,
    required String date,
    int defaultTargetMl = 2000,
  }) async {
    try {
      final prefs = await _getPrefs();
      final cached = prefs.getString(_cacheKey(userId, date));
      if (cached != null && cached.isNotEmpty) {
        return WaterDayLog.fromJson(jsonDecode(cached) as Map<String, dynamic>);
      }
    } catch (_) {}

    try {
      final snap = await _docRef(userId, date).get();
      if (snap.exists && snap.data() != null) {
        final log = WaterDayLog.fromJson(snap.data()!);
        await _saveLocalCache(userId, date, log);
        return log;
      }
    } catch (_) {}

    final initial = WaterDayLog.initial(date: date, targetMl: defaultTargetMl);
    await _saveLocalCache(userId, date, initial);
    return initial;
  }

  @override
  Stream<WaterDayLog> watchDailyWater({
    required String userId,
    required String date,
    int defaultTargetMl = 2000,
  }) async* {
    // 1. Instant local cache emission (< 10ms)
    final initial = await getDailyWater(
      userId: userId,
      date: date,
      defaultTargetMl: defaultTargetMl,
    );
    yield initial;

    // 2. Stream remote updates with offline resilience and automatic retry (ASTRO-017)
    int retryDelayMs = 1000;
    const maxRetries = 5;
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        await for (final snap in _docRef(userId, date).snapshots()) {
          retryDelayMs = 1000;
          attempts = 0;
          if (snap.exists && snap.data() != null) {
            final remote = WaterDayLog.fromJson(snap.data()!);
            await _saveLocalCache(userId, date, remote);
            yield remote;
          }
        }
        break;
      } catch (_) {
        attempts++;
        if (attempts >= maxRetries) break;
        await Future<void>.delayed(Duration(milliseconds: retryDelayMs));
        retryDelayMs = (retryDelayMs * 2).clamp(1000, 16000);
      }
    }
  }

  @override
  Future<WaterDayLog> logWater({
    required String userId,
    required String date,
    required int amountMl,
    int defaultTargetMl = 2000,
    String? note,
  }) async {
    final current = await getDailyWater(
      userId: userId,
      date: date,
      defaultTargetMl: defaultTargetMl,
    );
    final updated = current.addIntake(amountMl, note: note);

    await _saveLocalCache(userId, date, updated);
    unawaited(_syncRemote(userId, date, updated));

    return updated;
  }

  @override
  Future<void> updateDailyTarget({
    required String userId,
    required String date,
    required int targetMl,
  }) async {
    final current = await getDailyWater(userId: userId, date: date);
    final updated = WaterDayLog(
      id: current.id,
      date: current.date,
      currentMl: current.currentMl,
      targetMl: targetMl,
      entries: current.entries,
      updatedAt: DateTime.now(),
    );
    await _saveLocalCache(userId, date, updated);
    unawaited(_syncRemote(userId, date, updated));
  }

  @override
  Future<int> syncPendingWaterLogs({required String userId}) async {
    try {
      final prefs = await _getPrefs();
      final pendingDates = prefs.getStringList(_pendingKey(userId)) ?? [];
      if (pendingDates.isEmpty) return 0;

      int synced = 0;
      for (final date in List<String>.from(pendingDates)) {
        final cachedJson = prefs.getString(_cacheKey(userId, date));
        if (cachedJson != null && cachedJson.isNotEmpty) {
          try {
            final log = WaterDayLog.fromJson(jsonDecode(cachedJson) as Map<String, dynamic>);
            await _docRef(userId, date).set(log.toJson(), SetOptions(merge: true));
            await _removeFromPending(userId, date);
            synced++;
          } catch (_) {
            // Keep in pending queue for next sync retry
          }
        } else {
          await _removeFromPending(userId, date);
        }
      }
      return synced;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _saveLocalCache(String userId, String date, WaterDayLog log) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_cacheKey(userId, date), jsonEncode(log.toJson()));
    } catch (_) {}
  }

  Future<void> _addToPending(String userId, String date) async {
    try {
      final prefs = await _getPrefs();
      final list = prefs.getStringList(_pendingKey(userId)) ?? [];
      if (!list.contains(date)) {
        list.add(date);
        await prefs.setStringList(_pendingKey(userId), list);
      }
    } catch (_) {}
  }

  Future<void> _removeFromPending(String userId, String date) async {
    try {
      final prefs = await _getPrefs();
      final list = prefs.getStringList(_pendingKey(userId)) ?? [];
      if (list.remove(date)) {
        await prefs.setStringList(_pendingKey(userId), list);
      }
    } catch (_) {}
  }

  Future<void> _syncRemote(String userId, String date, WaterDayLog log) async {
    try {
      await _docRef(userId, date).set(log.toJson(), SetOptions(merge: true));
      await _removeFromPending(userId, date);
    } catch (_) {
      // Offline fallback: enqueue to pending-sync queue for durable auto-recovery
      await _addToPending(userId, date);
    }
  }
}
