import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/features/profile/presentation/widgets/language_settings_card.dart';
import 'package:astrobite/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguageSettingsCard Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('renders Vietnamese strings and opens picker sheet', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('vi'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: LanguageSettingsCard(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify card renders in Vietnamese
      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(find.text('Theo hệ thống'), findsOneWidget);

      // Tap card to open modal sheet
      await tester.tap(find.byType(LanguageSettingsCard));
      await tester.pumpAndSettle();

      // Check sheet options
      expect(find.text('Chọn ngôn ngữ'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      // Select English
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      // Modal closed, card now reflects English
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('renders English strings when locale is en', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: LanguageSettingsCard(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify card renders in English
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
    });
  });
}
