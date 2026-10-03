import 'package:home_widget/home_widget.dart';
import 'package:flutter/foundation.dart';

/// Service to handle synchronization of data from Flutter to Native OS Widgets
/// using the home_widget package.
class HomeWidgetService {
  // Use a constant app group for iOS if applicable
  static const String _appGroupId = 'group.com.astrobite.widget';
  
  // Widget names matching the native definitions
  static const String _iOSWidgetName = 'AstroBiteWidget';
  static const String _androidWidgetName = 'AstroBiteWidgetProvider';

  static Future<void> initialize() async {
    // Set the group ID for iOS
    await HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Updates the native widget with the latest macro and calorie data.
  /// This implements the One-Way Data Sync as defined in Gate 0 ADR.
  static Future<void> updateWidgetData({
    required int targetCalories,
    required int consumedCalories,
    required int targetCarbs,
    required int consumedCarbs,
    required int targetFat,
    required int consumedFat,
    required int targetProtein,
    required int consumedProtein,
  }) async {
    try {
      final remainingCalories = (targetCalories - consumedCalories).clamp(0, targetCalories);
      
      // We pass primitive types or JSON strings to SharedPreferences/UserDefaults
      await HomeWidget.saveWidgetData<int>('target_calories', targetCalories);
      await HomeWidget.saveWidgetData<int>('consumed_calories', consumedCalories);
      await HomeWidget.saveWidgetData<int>('remaining_calories', remainingCalories);
      
      await HomeWidget.saveWidgetData<int>('target_carbs', targetCarbs);
      await HomeWidget.saveWidgetData<int>('consumed_carbs', consumedCarbs);
      
      await HomeWidget.saveWidgetData<int>('target_fat', targetFat);
      await HomeWidget.saveWidgetData<int>('consumed_fat', consumedFat);
      
      await HomeWidget.saveWidgetData<int>('target_protein', targetProtein);
      await HomeWidget.saveWidgetData<int>('consumed_protein', consumedProtein);

      // Trigger an update to the home screen widget
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating Home Widget: $e');
      }
    }
  }

  /// Clear the widget data (e.g. on logout)
  static Future<void> clearWidgetData() async {
    try {
      await HomeWidget.saveWidgetData<int>('remaining_calories', 0);
      await HomeWidget.saveWidgetData<int>('consumed_calories', 0);
      // ... clear other fields as needed
      
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing Home Widget: $e');
      }
    }
  }
}
