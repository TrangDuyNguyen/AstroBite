import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:astrobite/features/analytics/presentation/widgets/weight_trend_chart.dart';

void main() {
  group('WeightTrendChart Widget Tests', () {
    testWidgets('renders LineChart wrapped in RepaintBoundary', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeightTrendChart(),
          ),
        ),
      );

      expect(find.byType(LineChart), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsWidgets);
    });
  });
}
