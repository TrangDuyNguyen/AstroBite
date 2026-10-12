import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/scanner/domain/entities/scan_mode.dart';
import 'package:astrobite/features/scanner/presentation/widgets/camera_mode_pill_switcher.dart';
import 'package:astrobite/l10n/app_localizations.dart';

void main() {
  Widget createWidget({
    required ScanMode currentMode,
    required ValueChanged<ScanMode> onModeChanged,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: Scaffold(
        body: CameraModePillSwitcher(
          currentMode: currentMode,
          onModeChanged: onModeChanged,
        ),
      ),
    );
  }

  group('CameraModePillSwitcher Widget Tests', () {
    testWidgets('renders both Dish and Packaged tabs with icons', (tester) async {
      await tester.pumpWidget(createWidget(
        currentMode: ScanMode.dish,
        onModeChanged: (_) {},
      ));
      await tester.pumpAndSettle();

      expect(find.text('Món ăn'), findsOneWidget);
      expect(find.text('Đóng gói'), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_rounded), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    });

    testWidgets('tapping inactive tab invokes onModeChanged callback', (tester) async {
      ScanMode? selectedMode;

      await tester.pumpWidget(createWidget(
        currentMode: ScanMode.dish,
        onModeChanged: (mode) => selectedMode = mode,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Đóng gói'));
      await tester.pumpAndSettle();

      expect(selectedMode, ScanMode.packaged);
    });

    testWidgets('tapping already active tab does not invoke onModeChanged', (tester) async {
      int callCount = 0;

      await tester.pumpWidget(createWidget(
        currentMode: ScanMode.dish,
        onModeChanged: (_) => callCount++,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Món ăn'));
      await tester.pumpAndSettle();

      expect(callCount, 0);
    });
  });
}
