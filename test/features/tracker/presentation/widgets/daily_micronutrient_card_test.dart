import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/presentation/widgets/daily_micronutrient_card.dart';

void main() {
  Widget createWidget(DailySummary summary) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: DailyMicronutrientCard(summary: summary),
        ),
      ),
    );
  }

  group('DailyMicronutrientCard Widget Tests', () {
    testWidgets('renders all 3 micronutrient bars correctly', (tester) async {
      const summary = DailySummary(
        date: '2026-09-18',
        totalCalories: 1800,
        targetCalories: 2000,
        totalProteinG: 120,
        targetProteinG: 150,
        totalCarbsG: 200,
        targetCarbsG: 250,
        totalFatG: 50,
        targetFatG: 65,
        logs: [],
        totalSodiumMg: 1450.0,
        targetSodiumMg: 2300.0,
        totalFiberG: 18.0,
        targetFiberG: 25.0,
        totalSugarG: 22.0,
        targetSugarG: 36.0,
      );

      await tester.pumpWidget(createWidget(summary));
      await tester.pumpAndSettle();

      expect(find.text('Vi Chất Dinh Dưỡng Hôm Nay'), findsOneWidget);
      expect(find.text('Natri: 1450 / 2300 mg'), findsOneWidget);
      expect(find.text('Chất xơ: 18.0 / 25 g'), findsOneWidget);
      expect(find.text('Đường: 22.0 / 36 g'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNWidgets(3));
    });

    testWidgets('toggles expand and collapse when header is tapped', (tester) async {
      const summary = DailySummary(
        date: '2026-09-18',
        totalCalories: 1800,
        targetCalories: 2000,
        totalProteinG: 120,
        targetProteinG: 150,
        totalCarbsG: 200,
        targetCarbsG: 250,
        totalFatG: 50,
        targetFatG: 65,
        logs: [],
      );

      await tester.pumpWidget(createWidget(summary));
      await tester.pumpAndSettle();

      // Initially expanded
      expect(find.text('Natri: 0 / 2300 mg'), findsOneWidget);

      // Tap header to collapse
      await tester.tap(find.text('Vi Chất Dinh Dưỡng Hôm Nay'));
      await tester.pumpAndSettle();

      // Bars should be hidden
      expect(find.text('Natri: 0 / 2300 mg'), findsNothing);

      // Tap again to expand
      await tester.tap(find.text('Vi Chất Dinh Dưỡng Hôm Nay'));
      await tester.pumpAndSettle();

      expect(find.text('Natri: 0 / 2300 mg'), findsOneWidget);
    });
  });
}
