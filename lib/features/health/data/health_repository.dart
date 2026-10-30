import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../domain/health_activity.dart';

/// Repository wrapping the `health` plugin for cross-platform HealthKit/Health Connect access — ASTRO-019
class HealthRepository {
  final Health? _healthPlugin;
  final FirebaseFirestore? _firestore;
  bool _configured = false;

  static const List<HealthDataType> _readTypes = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.WORKOUT,
  ];

  static const List<HealthDataType> _writeTypes = [
    HealthDataType.DIETARY_ENERGY_CONSUMED,
  ];

  HealthRepository({
    Health? healthPlugin,
    FirebaseFirestore? firestore,
  })  : _healthPlugin = healthPlugin ?? _safeGetHealth(),
        _firestore = firestore ?? _safeGetFirestore();

  static Health? _safeGetHealth() {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        return Health();
      }
    } catch (e) {
      debugPrint('[HealthRepository] Health plugin not available: $e');
    }
    return null;
  }

  static FirebaseFirestore? _safeGetFirestore() {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      debugPrint('[HealthRepository] FirebaseFirestore not available: $e');
    }
    return null;
  }

  Future<void> _ensureConfigured() async {
    final plugin = _healthPlugin;
    if (_configured || plugin == null) return;
    try {
      await plugin.configure();
      _configured = true;
    } catch (e) {
      debugPrint('[HealthRepository] Health.configure error: $e');
    }
  }

  /// Check if health platform is available on this device.
  Future<bool> isAvailable() async {
    final plugin = _healthPlugin;
    if (plugin == null) return false;
    try {
      await _ensureConfigured();
      if (Platform.isAndroid) {
        final status = await plugin.getHealthConnectSdkStatus();
        return status == HealthConnectSdkStatus.sdkAvailable;
      }
      return Platform.isIOS;
    } catch (e) {
      debugPrint('[HealthRepository] isAvailable error: $e');
      return false;
    }
  }

  /// Request health permissions from the OS.
  Future<bool> requestPermissions() async {
    final plugin = _healthPlugin;
    if (plugin == null) return false;
    try {
      await _ensureConfigured();
      final types = [..._readTypes, ..._writeTypes];
      final permissions = [
        ...List.filled(_readTypes.length, HealthDataAccess.READ),
        ...List.filled(_writeTypes.length, HealthDataAccess.WRITE),
      ];
      final granted = await plugin.requestAuthorization(
        types,
        permissions: permissions,
      );
      return granted;
    } catch (e) {
      debugPrint('[HealthRepository] requestPermissions error: $e');
      return false;
    }
  }

  /// Check if user has already granted permissions.
  Future<bool> hasPermissions() async {
    final plugin = _healthPlugin;
    if (plugin == null) return false;
    try {
      await _ensureConfigured();
      final types = [..._readTypes, ..._writeTypes];
      final permissions = [
        ...List.filled(_readTypes.length, HealthDataAccess.READ),
        ...List.filled(_writeTypes.length, HealthDataAccess.WRITE),
      ];
      final has = await plugin.hasPermissions(
        types,
        permissions: permissions,
      );
      return has ?? false;
    } catch (e) {
      debugPrint('[HealthRepository] hasPermissions error: $e');
      return false;
    }
  }

  /// Read today's health activity data.
  Future<HealthActivity> getTodayActivity() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final plugin = _healthPlugin;

    if (plugin == null) {
      return HealthActivity(
        steps: 0,
        activeEnergyBurned: 0,
        workouts: const [],
        date: startOfDay,
      );
    }

    try {
      await _ensureConfigured();

      int totalSteps = 0;
      try {
        final steps = await plugin.getTotalStepsInInterval(startOfDay, now);
        totalSteps = steps ?? 0;
      } catch (_) {}

      double activeEnergy = 0.0;
      final workouts = <WorkoutEntry>[];

      try {
        final dataPoints = await plugin.getHealthDataFromTypes(
          types: [
            HealthDataType.ACTIVE_ENERGY_BURNED,
            HealthDataType.WORKOUT,
          ],
          startTime: startOfDay,
          endTime: now,
        );

        for (final dp in dataPoints) {
          if (dp.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
            final val = dp.value;
            if (val is NumericHealthValue) {
              activeEnergy += val.numericValue.toDouble();
            }
          } else if (dp.type == HealthDataType.WORKOUT) {
            final val = dp.value;
            if (val is WorkoutHealthValue) {
              final duration = dp.dateTo.difference(dp.dateFrom).inMinutes;
              workouts.add(WorkoutEntry(
                name: val.workoutActivityType.name,
                durationMinutes: duration > 0 ? duration : 1,
                caloriesBurned: (val.totalEnergyBurned ?? 0).toDouble(),
              ));
            }
          }
        }
      } catch (_) {}

      return HealthActivity(
        steps: totalSteps,
        activeEnergyBurned: activeEnergy,
        workouts: workouts,
        date: startOfDay,
      );
    } catch (e) {
      debugPrint('[HealthRepository] getTodayActivity error: $e');
      return HealthActivity(
        steps: 0,
        activeEnergyBurned: 0,
        workouts: const [],
        date: startOfDay,
      );
    }
  }

  /// Write dietary energy consumed to Health platform.
  Future<bool> writeDietaryEnergy(double calories, DateTime timestamp) async {
    final plugin = _healthPlugin;
    if (plugin == null || calories <= 0) return false;
    try {
      await _ensureConfigured();
      return await plugin.writeHealthData(
        value: calories,
        type: HealthDataType.DIETARY_ENERGY_CONSUMED,
        startTime: timestamp,
        endTime: timestamp,
      );
    } catch (e) {
      debugPrint('[HealthRepository] writeDietaryEnergy error: $e');
      return false;
    }
  }

  /// Get health connection status from Firestore.
  Future<bool> isConnected(String userId) async {
    final firestore = _firestore;
    if (firestore == null) return false;
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .get();
    return doc.data()?['health_connected'] as bool? ?? false;
  }

  /// Update health connection status in Firestore.
  Future<void> setConnected(String userId, bool connected, {String? platform}) async {
    final firestore = _firestore;
    if (firestore == null) return;
    await firestore.collection('users').doc(userId).update({
      'health_connected': connected,
      'health_platform': connected ? (platform ?? _detectPlatform()) : null,
      'health_connected_at': connected ? FieldValue.serverTimestamp() : null,
    });
  }

  /// Check if write-back to Health is enabled.
  Future<bool> isWriteEnabled(String userId) async {
    final firestore = _firestore;
    if (firestore == null) return false;
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .get();
    return doc.data()?['health_write_enabled'] as bool? ?? false;
  }

  /// Toggle write-back setting.
  Future<void> setWriteEnabled(String userId, bool enabled) async {
    final firestore = _firestore;
    if (firestore == null) return;
    await firestore.collection('users').doc(userId).update({
      'health_write_enabled': enabled,
    });
  }

  String _detectPlatform() {
    if (Platform.isIOS) return 'apple_healthkit';
    if (Platform.isAndroid) return 'health_connect';
    return 'unknown';
  }

  /// Human-readable platform name.
  String get platformName {
    if (Platform.isIOS) return 'Apple Health';
    if (Platform.isAndroid) return 'Health Connect';
    return 'Health';
  }
}
