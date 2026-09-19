import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/health_activity.dart';

/// Repository wrapping the `health` plugin for cross-platform HealthKit/Health Connect access.
/// ponytail: abstract wrapper so we can swap the health plugin if needed (RSK-008 mitigation)
class HealthRepository {
  /// Check if health platform is available on this device.
  Future<bool> isAvailable() async {
    // ponytail: actual health plugin check goes here when `health` package is added
    // For now, return true on supported platforms
    return Platform.isIOS || Platform.isAndroid;
  }

  /// Request health permissions from the OS.
  /// Returns true if all required permissions were granted.
  Future<bool> requestPermissions() async {
    // ponytail: health plugin requestAuthorization() call goes here
    // This is the integration point for the `health` package
    return false; // Default: not granted until plugin is wired
  }

  /// Check if user has already granted permissions.
  Future<bool> hasPermissions() async {
    // ponytail: check existing authorization status
    return false;
  }

  /// Read today's health activity data.
  Future<HealthActivity> getTodayActivity() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // ponytail: read from health plugin
    // health.getHealthDataFromTypes(startOfDay, now, [STEPS, ACTIVE_ENERGY_BURNED, WORKOUT])
    return HealthActivity(
      steps: 0,
      activeEnergyBurned: 0,
      workouts: [],
      date: startOfDay,
    );
  }

  /// Write dietary energy consumed to Health platform.
  Future<bool> writeDietaryEnergy(double calories, DateTime timestamp) async {
    // ponytail: health.writeHealthData(calories, HealthDataType.DIETARY_ENERGY_CONSUMED, timestamp)
    return false;
  }

  /// Get health connection status from Firestore.
  Future<bool> isConnected(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return doc.data()?['health_connected'] as bool? ?? false;
  }

  /// Update health connection status in Firestore.
  Future<void> setConnected(String userId, bool connected, {String? platform}) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'health_connected': connected,
      'health_platform': connected ? (platform ?? _detectPlatform()) : null,
      'health_connected_at': connected ? FieldValue.serverTimestamp() : null,
    });
  }

  /// Check if write-back to Health is enabled.
  Future<bool> isWriteEnabled(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return doc.data()?['health_write_enabled'] as bool? ?? false;
  }

  /// Toggle write-back setting.
  Future<void> setWriteEnabled(String userId, bool enabled) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
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
