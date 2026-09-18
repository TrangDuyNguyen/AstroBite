import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_keys.dart';

const String _kCustomApiKeyPrefKey = 'gemini_custom_api_key';

/// State of the Gemini API Key configuration.
class GeminiApiKeyState {
  const GeminiApiKeyState({
    required this.customKey,
    required this.defaultKey,
  });

  final String customKey;
  final String defaultKey;

  /// Prioritizes environment key (.env / --dart-define) first;
  /// falls back to user custom key if environment key is not provided.
  String get activeKey => defaultKey.isNotEmpty ? defaultKey : customKey;

  /// True if any valid key is available.
  bool get hasKey => activeKey.isNotEmpty;

  /// True if currently using the environment key (.env).
  bool get isUsingEnvKey => defaultKey.isNotEmpty;

  /// True if currently using custom key configured by the user (only active if .env key is empty).
  bool get isUsingCustomKey => defaultKey.isEmpty && customKey.isNotEmpty;

  /// Masked version of the active key for safe UI display.
  String get maskedActiveKey {
    final key = activeKey;
    if (key.isEmpty) return 'Chưa cấu hình';
    if (key.length <= 8) return '••••••••';
    return '${key.substring(0, 4)}••••••••${key.substring(key.length - 4)}';
  }
}

/// Service notifier for managing custom and environment Gemini API keys.
class GeminiApiKeyNotifier extends StateNotifier<GeminiApiKeyState> {
  GeminiApiKeyNotifier()
      : super(const GeminiApiKeyState(
          customKey: '',
          defaultKey: AppKeys.defaultGeminiApiKey,
        )) {
    _loadSavedKey();
  }

  Future<void> _loadSavedKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kCustomApiKeyPrefKey) ?? '';
      state = GeminiApiKeyState(
        customKey: saved.trim(),
        defaultKey: AppKeys.defaultGeminiApiKey.trim(),
      );
    } catch (_) {
      // If SharedPreferences platform channel is not available yet, fallback to default key
      state = GeminiApiKeyState(
        customKey: '',
        defaultKey: AppKeys.defaultGeminiApiKey.trim(),
      );
    }
  }

  Future<void> setCustomKey(String key) async {
    final trimmed = key.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (trimmed.isEmpty) {
        await prefs.remove(_kCustomApiKeyPrefKey);
      } else {
        await prefs.setString(_kCustomApiKeyPrefKey, trimmed);
      }
    } catch (_) {
      // Ignored if platform channel fails
    }
    state = GeminiApiKeyState(
      customKey: trimmed,
      defaultKey: state.defaultKey,
    );
  }

  Future<void> clearCustomKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kCustomApiKeyPrefKey);
    } catch (_) {
      // Ignored if platform channel fails
    }
    state = GeminiApiKeyState(
      customKey: '',
      defaultKey: state.defaultKey,
    );
  }

  /// Static helper to resolve the active key asynchronously for datasources.
  /// Prioritizes the environment key from .env/AppKeys first.
  static Future<String> getActiveKey() async {
    final envKey = AppKeys.defaultGeminiApiKey.trim();
    if (envKey.isNotEmpty) return envKey;

    try {
      final prefs = await SharedPreferences.getInstance();
      final custom = prefs.getString(_kCustomApiKeyPrefKey)?.trim() ?? '';
      if (custom.isNotEmpty) return custom;
    } catch (_) {
      // If SharedPreferences platform channel fails, fallback to empty
    }
    return '';
  }
}

final geminiApiKeyServiceProvider =
    StateNotifierProvider<GeminiApiKeyNotifier, GeminiApiKeyState>((ref) {
  return GeminiApiKeyNotifier();
});
