import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/analytics/domain/analytics_providers.dart';
import 'package:astrobite/features/analytics/presentation/pages/analytics_page.dart';
import 'package:astrobite/features/analytics/presentation/widgets/calorie_trend_chart.dart';
import 'package:astrobite/features/analytics/presentation/widgets/weight_trend_chart.dart';

void main() {
  group('AnalyticsPage Widget Tests', () {
    testWidgets('renders segments, charts, and handles switching days', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final mockData7Days = {
        '2026-09-12': 1850,
        '2026-09-13': 2000,
        '2026-09-14': 1920,
      };
      final mockData30Days = {
        '2026-08-20': 2100,
        '2026-09-14': 1950,
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            calorieTrendsProvider(7).overrideWith((ref) async => mockData7Days),
            calorieTrendsProvider(30).overrideWith((ref) async => mockData30Days),
          ],
          child: const MaterialApp(
            home: AnalyticsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check title and labels
      expect(find.text(AppStrings.analytics), findsOneWidget);
      expect(find.text('7 ngày'), findsOneWidget);
      expect(find.text('30 ngày'), findsOneWidget);
      expect(find.text('Xu hướng Calo nạp vào (7 ngày)'), findsOneWidget);
      expect(find.text('Xu hướng Cân nặng (kg)'), findsOneWidget);

      // Check chart widgets are rendered
      expect(find.byType(CalorieTrendChart), findsOneWidget);
      expect(find.byType(WeightTrendChart), findsOneWidget);

      // Tap on '30 ngày' segment
      await tester.tap(find.text('30 ngày'));
      await tester.pumpAndSettle();

      expect(find.text('Xu hướng Calo nạp vào (30 ngày)'), findsOneWidget);
    });
  });
}
