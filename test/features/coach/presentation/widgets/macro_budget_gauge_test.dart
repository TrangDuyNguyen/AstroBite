import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/presentation/widgets/macro_budget_gauge.dart';

void main() {
  group('MacroBudgetGauge Widget Tests', () {
    testWidgets('renders safe budget state when calories within target', (tester) async {
      const props = MacroBudgetGaugeProps(
        projectedCalories: 350,
        remainingCalories: 800,
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacroBudgetGauge(props: props),
          ),
        ),
      );

      expect(find.text('TÁC ĐỘNG NGÂN SÁCH NGÀY'), findsOneWidget);
      expect(find.text('+350 kcal'), findsOneWidget);
      expect(find.text('Còn lại sau bữa: 450 kcal'), findsOneWidget);
      expect(find.text('Mục tiêu: 2000 kcal'), findsOneWidget);
      expect(find.byIcon(Icons.pie_chart_rounded), findsOneWidget);
    });

    testWidgets('renders warning state when projected calories exceed remaining budget', (tester) async {
      const props = MacroBudgetGaugeProps(
        projectedCalories: 600,
        remainingCalories: 200,
        targetCalories: 2000,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacroBudgetGauge(props: props),
          ),
        ),
      );

      expect(find.text('+600 kcal'), findsOneWidget);
      expect(find.text('⚠️ Vượt 400 kcal mục tiêu'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });
  });
}
