import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';

final networkSyncCoordinatorProvider = Provider<NetworkSyncCoordinator>((ref) {
  final coordinator = NetworkSyncCoordinator(ref: ref);
  ref.onDispose(coordinator.dispose);
  return coordinator;
});

/// ASTRO-013: Network restoration listener and offline-sync coordinator.
/// Automatically detects internet connectivity and synchronizes pending
/// food logs and water intakes upon network recovery.
class NetworkSyncCoordinator {
  NetworkSyncCoordinator({
    required Ref ref,
    Connectivity? connectivity,
  })  : _ref = ref,
        _connectivity = connectivity ?? Connectivity();

  final Ref _ref;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  AppLifecycleListener? _lifecycleListener;
  bool _wasOffline = false;

  /// Initializes connectivity listeners and lifecycle observers.
  Future<void> initialize() async {
    // 1. Initial connectivity check
    try {
      final initialResults = await _connectivity.checkConnectivity();
      _handleConnectivityChange(initialResults);
    } catch (_) {
      // Graceful fallback for environments where platform channel is not wired
    }

    // 2. Continuous connectivity change stream
    _connectivitySub = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (_) {},
    );

    // 3. App resume listener to trigger sync if returning to foreground
    _lifecycleListener = AppLifecycleListener(
      onResume: triggerSync,
    );
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final isOffline = results.isEmpty ||
        results.every((r) => r == ConnectivityResult.none);

    _ref.read(isOfflineProvider.notifier).state = isOffline;

    // Trigger sync when transitioning from offline to online, or on active network
    if (_wasOffline && !isOffline) {
      triggerSync();
    }
    _wasOffline = isOffline;
  }

  /// Triggers pending food and water sync for the active authenticated user.
  Future<int> triggerSync() async {
    try {
      final user = _ref.read(authRepositoryProvider).currentUser;
      if (user == null) return 0;

      final foodSynced = await _ref
          .read(foodLogRepositoryProvider)
          .syncPendingLogs(userId: user.uid);

      final waterSynced = await _ref
          .read(waterRepositoryProvider)
          .syncPendingWaterLogs(userId: user.uid);

      return foodSynced + waterSynced;
    } catch (_) {
      return 0;
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
    _lifecycleListener?.dispose();
  }
}

