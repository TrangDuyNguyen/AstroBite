import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/test_l10n.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/presentation/widgets/cockpit_components/clay_micronutrient_sheet.dart';
import 'package:astrobite/features/tracker/presentation/widgets/solar_orbital_cockpit.dart';

void main() {
  group('SolarOrbitalCockpit Widget Tests', () {
    testWidgets('renders remaining calories and macro rows correctly', (tester) async {
      final summary = DailySummary(
        date: '2026-10-12',
        totalCalories: 800,
        targetCalories: 2000,
        totalProteinG: 60,
        targetProteinG: 150,
        totalCarbsG: 100,
        targetCarbsG: 250,
        totalFatG: 20,
        targetFatG: 50,
        logs: const [],
        totalSodiumMg: 500.0,
        targetSodiumMg: 2300.0,
        totalFiberG: 10.0,
        targetFiberG: 25.0,
        totalSugarG: 15.0,
        targetSugarG: 36.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolarOrbitalCockpit(summary: summary),
          ),
        ),
      );

      expect(find.text('SOLAR ORBITAL COCKPIT'), findsOneWidget);
      expect(find.text('Mục tiêu: 2000 kcal'), findsOneWidget);
      expect(find.text('1200 kcal'), findsOneWidget); // 2000 - 800 = 1200
      expect(find.text(testL10n.carbs), findsOneWidget);
      expect(find.text(testL10n.protein), findsOneWidget);
      expect(find.text(testL10n.fat), findsOneWidget);
      expect(find.textContaining('Vi chất: Natri 500mg'), findsOneWidget);
    });

    testWidgets('tapping micronutrients pill opens ClayMicronutrientSheet', (tester) async {
      final summary = DailySummary(
        date: '2026-10-12',
        totalCalories: 800,
        targetCalories: 2000,
        totalProteinG: 60,
        targetProteinG: 150,
        totalCarbsG: 100,
        targetCarbsG: 250,
        totalFatG: 20,
        targetFatG: 50,
        logs: const [],
        totalSodiumMg: 500.0,
        targetSodiumMg: 2300.0,
        totalFiberG: 10.0,
        targetFiberG: 25.0,
        totalSugarG: 15.0,
        targetSugarG: 36.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolarOrbitalCockpit(summary: summary),
          ),
        ),
      );

      final microPill = find.textContaining('Vi chất:');
      expect(microPill, findsOneWidget);

      await tester.tap(microPill);
      await tester.pumpAndSettle();

      expect(find.byType(ClayMicronutrientSheet), findsOneWidget);
      expect(find.text('Báo Cáo Vi Chất Hôm Nay'), findsOneWidget);
    });
  });
}
