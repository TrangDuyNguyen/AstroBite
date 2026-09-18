import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:astrobite/features/analytics/presentation/widgets/calorie_trend_chart.dart';

void main() {
  group('CalorieTrendChart Widget Tests', () {
    testWidgets('renders empty state when dailyTotals is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CalorieTrendChart(dailyTotals: {}),
          ),
        ),
      );

      expect(find.text('Chưa có dữ liệu theo dõi'), findsOneWidget);
      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('renders LineChart with RepaintBoundary when dailyTotals has data', (tester) async {
      final mockData = {
        '2026-09-12': 1800,
        '2026-09-13': 2100,
        '2026-09-14': 1950,
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalorieTrendChart(dailyTotals: mockData),
          ),
        ),
      );

      expect(find.byType(LineChart), findsOneWidget);
      expect(find.byType(RepaintBoundary), findsWidgets);
      expect(find.text('Chưa có dữ liệu theo dõi'), findsNothing);
    });
  });
}
