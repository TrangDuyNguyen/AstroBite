import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';

/// Data payload synchronized with native iOS WidgetKit and Android AppWidget.
class WidgetSyncPayload {
  const WidgetSyncPayload({
    required this.remainingCalories,
    required this.consumedCalories,
    required this.targetCalories,
    required this.carbsGrams,
    required this.fatGrams,
    required this.proteinGrams,
    required this.currentStreak,
    required this.hasShield,
    required this.lastUpdated,
  });

  final int remainingCalories;
  final int consumedCalories;
  final int targetCalories;
  final int carbsGrams;
  final int fatGrams;
  final int proteinGrams;
  final int currentStreak;
  final bool hasShield;
  final DateTime lastUpdated;

  Map<String, dynamic> toMap() {
    return {
      'remaining_calories': remainingCalories,
      'consumed_calories': consumedCalories,
      'target_calories': targetCalories,
      'carbs_grams': carbsGrams,
      'fat_grams': fatGrams,
      'protein_grams': proteinGrams,
      'current_streak': currentStreak,
      'has_shield': hasShield,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  factory WidgetSyncPayload.fromSummaryAndStreak({
    required DailySummary summary,
    StreakRecord? streak,
  }) {
    return WidgetSyncPayload(
      remainingCalories: max(0, summary.targetCalories - summary.totalCalories),
      consumedCalories: summary.totalCalories,
      targetCalories: summary.targetCalories,
      carbsGrams: summary.totalCarbsG,
      fatGrams: summary.totalFatG,
      proteinGrams: summary.totalProteinG,
      currentStreak: streak?.currentStreak ?? 0,
      hasShield: streak?.hasShield ?? false,
      lastUpdated: DateTime.now(),
    );
  }
}

/// Service handling background synchronization of calorie & macro budgets to OS widgets.
class WidgetSyncService {
  WidgetSyncService({
    this.appGroupId = 'group.com.astrobite.app',
    this.androidWidgetName = 'AstroBiteWidgetProvider',
    this.iOSWidgetName = 'AstroBiteWidget',
  });

  final String appGroupId;
  final String androidWidgetName;
  final String iOSWidgetName;

  /// In-memory cache of the latest synchronized payload.
  WidgetSyncPayload? _lastPayload;
  WidgetSyncPayload? get lastPayload => _lastPayload;

  /// Synchronizes [summary] and optional [streak] to native widget storage.
  Future<bool> sync({
    required DailySummary summary,
    StreakRecord? streak,
  }) async {
    final payload = WidgetSyncPayload.fromSummaryAndStreak(
      summary: summary,
      streak: streak,
    );
    _lastPayload = payload;

    try {
      await HomeWidget.setAppGroupId(appGroupId);

      // Save each field as key-value for native widgets
      await Future.wait([
        HomeWidget.saveWidgetData<int>('remaining_calories', payload.remainingCalories),
        HomeWidget.saveWidgetData<int>('consumed_calories', payload.consumedCalories),
        HomeWidget.saveWidgetData<int>('target_calories', payload.targetCalories),
        HomeWidget.saveWidgetData<int>('carbs_grams', payload.carbsGrams),
        HomeWidget.saveWidgetData<int>('fat_grams', payload.fatGrams),
        HomeWidget.saveWidgetData<int>('protein_grams', payload.proteinGrams),
        HomeWidget.saveWidgetData<int>('current_streak', payload.currentStreak),
        HomeWidget.saveWidgetData<bool>('has_shield', payload.hasShield),
        HomeWidget.saveWidgetData<String>('last_updated', payload.lastUpdated.toIso8601String()),
      ]);

      // Trigger OS widget view update
      await HomeWidget.updateWidget(
        name: androidWidgetName,
        iOSName: iOSWidgetName,
      );
      return true;
    } catch (e) {
      // In widget tests or desktop environments, channel calls may fail gracefully
      debugPrint('WidgetSyncService: Graceful fallback on unsupported environment: $e');
      return false;
    }
  }

  /// Requests the OS to pin the widget directly to the home screen (Android 8.0+).
  Future<bool> requestPinWidget() async {
    try {
      await HomeWidget.requestPinWidget(
        androidName: androidWidgetName,
      );
      return true;
    } catch (e) {
      debugPrint('WidgetSyncService: Pin widget failed: $e');
      return false;
    }
  }

  /// Registers deep-link uri listener when widget actions are tapped.
  void initDeepLink(Function(Uri? uri) onUri) {
    try {
      HomeWidget.initiallyLaunchedFromHomeWidget().then(onUri);
      HomeWidget.widgetClicked.listen(onUri);
    } catch (e) {
      debugPrint('WidgetSyncService deep link listener failed gracefully: $e');
    }
  }
}

final widgetSyncServiceProvider = Provider<WidgetSyncService>((ref) {
  return WidgetSyncService();
});
