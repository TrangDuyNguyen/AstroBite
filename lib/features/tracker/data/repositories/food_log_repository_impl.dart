import 'dart:async';
import '../../domain/repositories/food_log_repository.dart';
import '../datasources/food_log_local_datasource.dart';
import '../datasources/food_log_remote_datasource.dart';
import '../models/food_log_dto.dart';

class FoodLogRepositoryImpl implements FoodLogRepository {
  FoodLogRepositoryImpl({
    FoodLogRemoteDatasource? remoteDatasource,
    FoodLogLocalDatasource? localDatasource,
  })  : _remoteDatasource = remoteDatasource ?? FoodLogRemoteDatasource(),
        _localDatasource = localDatasource ?? FoodLogLocalDatasource();

  final FoodLogRemoteDatasource _remoteDatasource;
  final FoodLogLocalDatasource _localDatasource;
  final Map<String, int> _recentLogDebounce = {};

  String _logSignature(FoodLogDto log) {
    return '${log.date}_${log.mealType}_${log.dishName.trim().toLowerCase()}_${log.calories}_${log.estimatedWeightG}';
  }

  List<FoodLogDto> _deduplicateLogs(List<FoodLogDto> logs) {
    final seenIds = <String>{};
    final seenSignatures = <String>{};
    final result = <FoodLogDto>[];

    for (final log in logs) {
      if (log.id.isNotEmpty && !seenIds.add(log.id)) {
        continue;
      }
      final sig = _logSignature(log);
      if (!seenSignatures.add(sig)) {
        continue;
      }
      result.add(log);
    }
    return result;
  }

  @override
  Stream<List<FoodLogDto>> watchDailyLogs({
    required String userId,
    required String date,
  }) async* {
    // 0. Auto-clean any duplicate pending sync items in queue
    await _localDatasource.removeDuplicatePendingLogs(userId: userId);

    // 1. Immediate local cache retrieval (< 50ms)
    final initialCached = await _localDatasource.getCachedLogs(
      userId: userId,
      date: date,
    );
    final deduplicatedInitial = _deduplicateLogs(initialCached);
    if (deduplicatedInitial.length != initialCached.length) {
      await _localDatasource.saveCachedLogs(
        userId: userId,
        date: date,
        logs: deduplicatedInitial,
      );
    }
    yield deduplicatedInitial;

    // 2. Stream remote updates with offline resilience
    try {
      await for (final remoteLogs in _remoteDatasource.watchDailyLogs(
        userId: userId,
        date: date,
      )) {
        // Retain pending sync local items not yet in remote
        final pending = await _localDatasource.getPendingSyncLogs(userId: userId);
        final pendingForDate = pending.where((p) => p.date == date).toList();

        final remoteIds = remoteLogs.map((r) => r.id).toSet();
        final remoteSignatures = remoteLogs
            .map((r) => _logSignature(r))
            .toSet();

        final filteredPending = pendingForDate.where((p) {
          if (remoteIds.contains(p.id)) return false;
          if (remoteSignatures.contains(_logSignature(p))) return false;
          return true;
        }).toList();

        final merged = _deduplicateLogs([
          ...remoteLogs,
          ...filteredPending,
        ]);

        await _localDatasource.saveCachedLogs(
          userId: userId,
          date: date,
          logs: merged,
        );
        yield merged;
      }
    } catch (_) {
      // Fallback: stay on cached logs if network stream errors
    }
  }

  @override
  Future<void> addFoodLog({
    required String userId,
    required FoodLogDto log,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final debounceKey =
        '${userId}_${log.date}_${log.mealType}_${log.dishName.trim().toLowerCase()}_${log.calories}';
    final lastTime = _recentLogDebounce[debounceKey];
    if (lastTime != null && (now - lastTime) < 2000) {
      // Ignore duplicate rapid clicks within 2.0s
      return;
    }
    _recentLogDebounce[debounceKey] = now;
    _recentLogDebounce.removeWhere((_, time) => now - time > 15000);

    final effectiveId = log.id.isNotEmpty
        ? log.id
        : 'log_${DateTime.now().millisecondsSinceEpoch}';
    final initialLog = log.copyWith(
      id: effectiveId,
      syncStatus: 'pending_sync',
    );

    // 1. Immediately persist to local cache for instant UI feedback
    await _localDatasource.upsertCachedLog(
      userId: userId,
      log: initialLog,
    );
    await _localDatasource.addToPendingQueue(
      userId: userId,
      log: initialLog,
    );

    // 2. Attempt remote Firestore persistence
    try {
      await _remoteDatasource.addFoodLog(userId: userId, log: initialLog);
      final syncedLog = initialLog.copyWith(syncStatus: 'synced');
      await _localDatasource.upsertCachedLog(
        userId: userId,
        log: syncedLog,
      );
      await _localDatasource.removeFromPendingQueue(
        userId: userId,
        logId: effectiveId,
      );
    } catch (_) {
      // Offline fallback: log remains pending_sync in cache and queue
    }
  }

  @override
  Future<void> deleteFoodLog({
    required String userId,
    required String logId,
  }) async {
    await _localDatasource.removeFromPendingQueue(
      userId: userId,
      logId: logId,
    );
    await _localDatasource.deleteCachedLogById(
      userId: userId,
      logId: logId,
    );
    try {
      await _remoteDatasource.deleteFoodLog(userId: userId, logId: logId);
    } catch (_) {
      // Offline: best effort remote delete
    }
  }

  @override
  Future<List<FoodLogDto>> getLogsForDateRange({
    required String userId,
    required String startDate,
    required String endDate,
  }) {
    return _remoteDatasource.getLogsForDateRange(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<int> syncPendingLogs({required String userId}) async {
    final pending = await _localDatasource.getPendingSyncLogs(userId: userId);
    int syncedCount = 0;

    for (final log in pending) {
      try {
        await _remoteDatasource.addFoodLog(userId: userId, log: log);
        final syncedLog = log.copyWith(syncStatus: 'synced');
        await _localDatasource.upsertCachedLog(
          userId: userId,
          log: syncedLog,
        );
        await _localDatasource.removeFromPendingQueue(
          userId: userId,
          logId: log.id,
        );
        syncedCount++;
      } catch (_) {
        // Remains in pending queue for next sync opportunity
      }
    }

    return syncedCount;
  }

  @override
  Future<List<FoodLogDto>> getPendingSyncLogs({required String userId}) {
    return _localDatasource.getPendingSyncLogs(userId: userId);
  }
}
