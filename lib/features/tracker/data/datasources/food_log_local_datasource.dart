import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_log_dto.dart';

class FoodLogLocalDatasource {
  FoodLogLocalDatasource({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  String _dateKey(String userId, String date) =>
      'cached_food_logs_${userId}_$date';

  String _queueKey(String userId) => 'pending_sync_queue_$userId';

  Future<List<FoodLogDto>> getCachedLogs({
    required String userId,
    required String date,
  }) async {
    try {
      final prefs = await _getPrefs();
      final raw = prefs.getString(_dateKey(userId, date));
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => FoodLogDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCachedLogs({
    required String userId,
    required String date,
    required List<FoodLogDto> logs,
  }) async {
    try {
      final prefs = await _getPrefs();
      final raw = jsonEncode(logs.map((l) => l.toJson()).toList());
      await prefs.setString(_dateKey(userId, date), raw);
    } catch (_) {}
  }

  Future<void> upsertCachedLog({
    required String userId,
    required FoodLogDto log,
  }) async {
    final current = await getCachedLogs(userId: userId, date: log.date);
    final idx = current.indexWhere((l) => l.id == log.id);
    if (idx >= 0) {
      current[idx] = log;
    } else {
      current.add(log);
    }
    await saveCachedLogs(userId: userId, date: log.date, logs: current);
  }

  Future<void> deleteCachedLog({
    required String userId,
    required String date,
    required String logId,
  }) async {
    final current = await getCachedLogs(userId: userId, date: date);
    current.removeWhere((l) => l.id == logId);
    await saveCachedLogs(userId: userId, date: date, logs: current);
  }

  Future<List<FoodLogDto>> getPendingSyncLogs({
    required String userId,
  }) async {
    try {
      final prefs = await _getPrefs();
      final raw = prefs.getString(_queueKey(userId));
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => FoodLogDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addToPendingQueue({
    required String userId,
    required FoodLogDto log,
  }) async {
    final queue = await getPendingSyncLogs(userId: userId);
    queue.removeWhere((l) => l.id == log.id);
    queue.add(log);
    final prefs = await _getPrefs();
    await prefs.setString(
      _queueKey(userId),
      jsonEncode(queue.map((l) => l.toJson()).toList()),
    );
  }

  Future<void> removeFromPendingQueue({
    required String userId,
    required String logId,
  }) async {
    final queue = await getPendingSyncLogs(userId: userId);
    queue.removeWhere((l) => l.id == logId);
    final prefs = await _getPrefs();
    await prefs.setString(
      _queueKey(userId),
      jsonEncode(queue.map((l) => l.toJson()).toList()),
    );
  }

  Future<void> deleteCachedLogById({
    required String userId,
    required String logId,
  }) async {
    try {
      final prefs = await _getPrefs();
      final prefix = 'cached_food_logs_${userId}_';
      for (final key in prefs.getKeys()) {
        if (key.startsWith(prefix)) {
          final raw = prefs.getString(key);
          if (raw != null && raw.contains(logId)) {
            final list = jsonDecode(raw) as List<dynamic>;
            final filtered =
                list.where((item) => (item as Map)['id'] != logId).toList();
            await prefs.setString(key, jsonEncode(filtered));
          }
        }
      }
    } catch (_) {}
  }

  Future<void> removeDuplicatePendingLogs({required String userId}) async {
    try {
      final queue = await getPendingSyncLogs(userId: userId);
      final seen = <String>{};
      final cleaned = <FoodLogDto>[];
      for (final log in queue) {
        final key =
            '${log.date}_${log.mealType}_${log.dishName.trim().toLowerCase()}_${log.calories}_${log.estimatedWeightG}';
        if (seen.add(key)) {
          cleaned.add(log);
        }
      }
      if (cleaned.length != queue.length) {
        final prefs = await _getPrefs();
        await prefs.setString(
          _queueKey(userId),
          jsonEncode(cleaned.map((l) => l.toJson()).toList()),
        );
      }
    } catch (_) {}
  }
}
