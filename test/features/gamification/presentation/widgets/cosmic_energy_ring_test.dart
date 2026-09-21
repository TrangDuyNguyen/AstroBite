import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/gamification/presentation/widgets/cosmic_energy_ring.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';

void main() {
  group('CosmicEnergyRing Widget Tests', () {
    testWidgets('renders empty/initial state when 0 calories consumed', (tester) async {
      const summary = DailySummary(
        date: '2026-09-19',
        totalCalories: 0,
        targetCalories: 2000,
        totalProteinG: 0,
        targetProteinG: 140,
        totalCarbsG: 0,
        targetCarbsG: 220,
        totalFatG: 0,
        targetFatG: 65,
        logs: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CosmicEnergyRing(summary: summary),
          ),
        ),
      );

      expect(find.text('THẮP SÁNG TIỂU VŨ TRỤ HÔM NAY'), findsOneWidget);
      expect(find.text('2000 kcal'), findsOneWidget); // remaining
    });

    testWidgets('renders Perfect Day state when calories in [85%..110%]', (tester) async {
      const summary = DailySummary(
        date: '2026-09-19',
        totalCalories: 1900, // 95% of 2000
        targetCalories: 2000,
        totalProteinG: 130,
        targetProteinG: 140,
        totalCarbsG: 200,
        targetCarbsG: 220,
        totalFatG: 60,
        targetFatG: 65,
        logs: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CosmicEnergyRing(summary: summary),
          ),
        ),
      );

      expect(find.text('NĂNG LƯỢNG CÂN BẰNG HOÀN HẢO'), findsOneWidget);
      expect(find.text('🪐'), findsOneWidget);
    });

    testWidgets('renders Over Budget state when calories exceed target', (tester) async {
      const summary = DailySummary(
        date: '2026-09-19',
        totalCalories: 2400,
        targetCalories: 2000,
        totalProteinG: 160,
        targetProteinG: 140,
        totalCarbsG: 260,
        targetCarbsG: 220,
        totalFatG: 80,
        targetFatG: 65,
        logs: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CosmicEnergyRing(summary: summary),
          ),
        ),
      );

      expect(find.text('VƯỢT NGÂN SÁCH NĂNG LƯỢNG'), findsOneWidget);
      expect(find.text('⚡'), findsOneWidget);
    });
  });
}
