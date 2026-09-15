import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/core/constants/app_keys.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('GeminiApiKeyService Tests', () {
    test('initial state has empty custom key and AppKeys default key', () {
      final notifier = GeminiApiKeyNotifier();

      expect(notifier.state.customKey, '');
      expect(notifier.state.defaultKey, AppKeys.defaultGeminiApiKey);
      expect(notifier.state.isUsingCustomKey, isFalse);
    });

    test('setCustomKey persists key and updates state', () async {
      final notifier = GeminiApiKeyNotifier();
      await notifier.setCustomKey('AIzaSyTest1234567890');

      expect(notifier.state.customKey, 'AIzaSyTest1234567890');
      expect(notifier.state.activeKey, 'AIzaSyTest1234567890');
      expect(notifier.state.isUsingCustomKey, isTrue);
      expect(notifier.state.hasKey, isTrue);
      expect(notifier.state.maskedActiveKey, 'AIza••••••••7890');

      // Verify static async lookup
      final activeFromPref = await GeminiApiKeyNotifier.getActiveKey();
      expect(activeFromPref, 'AIzaSyTest1234567890');
    });

    test('clearCustomKey removes key and resets state', () async {
      final notifier = GeminiApiKeyNotifier();
      await notifier.setCustomKey('AIzaSyTest1234567890');
      expect(notifier.state.isUsingCustomKey, isTrue);

      await notifier.clearCustomKey();
      expect(notifier.state.customKey, '');
      expect(notifier.state.isUsingCustomKey, isFalse);

      final activeFromPref = await GeminiApiKeyNotifier.getActiveKey();
      expect(activeFromPref, AppKeys.defaultGeminiApiKey);
    });

    test('maskedActiveKey handles short or empty keys gracefully', () {
      const emptyState = GeminiApiKeyState(customKey: '', defaultKey: '');
      expect(emptyState.maskedActiveKey, 'Chưa cấu hình');

      const shortState = GeminiApiKeyState(customKey: '1234', defaultKey: '');
      expect(shortState.maskedActiveKey, '••••••••');
    });
  });
}
