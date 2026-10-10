import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported application languages.
enum AppLanguage {
  system,
  vietnamese,
  english;

  /// Returns corresponding [Locale] or `null` for system default.
  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.vietnamese => const Locale('vi'),
    AppLanguage.english => const Locale('en'),
  };

  /// Parses language from stored code.
  static AppLanguage fromCode(String? code) {
    return switch (code) {
      'vi' => AppLanguage.vietnamese,
      'en' => AppLanguage.english,
      _ => AppLanguage.system,
    };
  }

  /// Serialization code for persistence.
  String get code => switch (this) {
    AppLanguage.system => 'system',
    AppLanguage.vietnamese => 'vi',
    AppLanguage.english => 'en',
  };
}

/// State notifier managing user selected application language.
class AppLanguageNotifier extends StateNotifier<AppLanguage> {
  AppLanguageNotifier() : super(AppLanguage.system) {
    _loadSavedLanguage();
  }

  static const _prefKey = 'astrobite_app_language';

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null) {
        state = AppLanguage.fromCode(savedCode);
      }
    } catch (_) {
      // Graceful fallback to system default if SharedPreferences is unavailable
    }
  }

  /// Updates and persists the selected application language.
  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, language.code);
    } catch (_) {
      // Ignore persistence errors
    }
  }
}

/// Provider for app language state and controller.
final appLanguageProvider =
    StateNotifierProvider<AppLanguageNotifier, AppLanguage>((ref) {
  return AppLanguageNotifier();
});

/// Provider exposing the current [Locale] (or null for OS system locale).
final appLocaleProvider = Provider<Locale?>((ref) {
  final language = ref.watch(appLanguageProvider);
  return language.locale;
});
