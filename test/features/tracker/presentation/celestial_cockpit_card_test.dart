import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/test_l10n.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/presentation/widgets/celestial_cockpit_card.dart';

void main() {
  group('CelestialCockpitCard Widget Tests', () {
    final summary = DailySummary(
      date: '2026-09-22',
      totalCalories: 1450,
      targetCalories: 2100,
      totalProteinG: 85,
      targetProteinG: 130,
      totalCarbsG: 120,
      targetCarbsG: 220,
      totalFatG: 38,
      targetFatG: 65,
      totalSodiumMg: 1400.0,
      targetSodiumMg: 2300.0,
      totalFiberG: 22.0,
      targetFiberG: 25.0,
      totalSugarG: 28.0,
      targetSugarG: 36.0,
      logs: [],
    );

    testWidgets('renders cockpit header, remaining calories and macro bars', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialCockpitCard(summary: summary),
          ),
        ),
      );

      // Verify Cockpit Header
      expect(find.text('CELESTIAL COCKPIT'), findsOneWidget);
      expect(find.text('Mục tiêu: 2100 kcal'), findsOneWidget);

      // Verify Remaining Calories (2100 - 1450 = 650)
      expect(find.text('650 kcal'), findsOneWidget);

      // Verify 3 Macro Bars
      expect(find.text(testL10n.carbs), findsOneWidget);
      expect(find.text('120g / 220g'), findsOneWidget);

      expect(find.text(testL10n.protein), findsOneWidget);
      expect(find.text('85g / 130g'), findsOneWidget);

      expect(find.text(testL10n.fat), findsOneWidget);
      expect(find.text('38g / 65g'), findsOneWidget);
    });

    testWidgets('toggles collapsible micronutrients drawer on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CelestialCockpitCard(summary: summary),
            ),
          ),
        ),
      );

      // Initial state: details row not visible
      expect(find.text('Natri (Sodium)'), findsNothing);

      // Tap on the collapsible bar
      final collapsiblePill = find.byType(InkWell);
      expect(collapsiblePill, findsOneWidget);
      await tester.tap(collapsiblePill);
      await tester.pumpAndSettle();

      // Expanded state: details row appears
      expect(find.text('Natri (Sodium)'), findsOneWidget);
      expect(find.text('Chất xơ (Fiber)'), findsOneWidget);
      expect(find.text('Lượng đường (Sugar)'), findsOneWidget);

      // Tap again to collapse
      await tester.tap(collapsiblePill);
      await tester.pumpAndSettle();
      expect(find.text('Natri (Sodium)'), findsNothing);
    });

    testWidgets('displays over budget styling when calories exceed target', (tester) async {
      final overBudgetSummary = DailySummary(
        date: '2026-09-22',
        totalCalories: 2300,
        targetCalories: 2000,
        totalProteinG: 140,
        targetProteinG: 130,
        totalCarbsG: 250,
        targetCarbsG: 220,
        totalFatG: 75,
        targetFatG: 65,
        logs: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialCockpitCard(summary: overBudgetSummary),
          ),
        ),
      );

      // Check for +300 kcal over budget indicator
      expect(find.text('+300 kcal'), findsOneWidget);
      expect(find.text(testL10n.overBudget), findsOneWidget);
    });
  });
}
