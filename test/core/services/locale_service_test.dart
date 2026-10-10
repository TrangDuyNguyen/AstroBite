import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/core/services/locale_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleService & AppLanguage Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('AppLanguage enum properties and mappings', () {
      expect(AppLanguage.system.locale, isNull);
      expect(AppLanguage.system.code, equals('system'));

      expect(AppLanguage.vietnamese.locale, equals(const Locale('vi')));
      expect(AppLanguage.vietnamese.code, equals('vi'));

      expect(AppLanguage.english.locale, equals(const Locale('en')));
      expect(AppLanguage.english.code, equals('en'));

      expect(AppLanguage.fromCode('vi'), equals(AppLanguage.vietnamese));
      expect(AppLanguage.fromCode('en'), equals(AppLanguage.english));
      expect(AppLanguage.fromCode('unknown'), equals(AppLanguage.system));
      expect(AppLanguage.fromCode(null), equals(AppLanguage.system));
    });

    test('AppLanguageNotifier initializes to system when prefs empty', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final lang = container.read(appLanguageProvider);
      expect(lang, equals(AppLanguage.system));
      expect(container.read(appLocaleProvider), isNull);
    });

    test('AppLanguageNotifier updates and persists language selection', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(appLanguageProvider.notifier);
      await notifier.setLanguage(AppLanguage.english);

      expect(container.read(appLanguageProvider), equals(AppLanguage.english));
      expect(container.read(appLocaleProvider), equals(const Locale('en')));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('astrobite_app_language'), equals('en'));

      await notifier.setLanguage(AppLanguage.vietnamese);
      expect(container.read(appLanguageProvider), equals(AppLanguage.vietnamese));
      expect(container.read(appLocaleProvider), equals(const Locale('vi')));
      expect(prefs.getString('astrobite_app_language'), equals('vi'));
    });
  });
}
