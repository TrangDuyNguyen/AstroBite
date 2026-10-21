import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/entities/water_log.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/widgets/clay_water_card.dart';
import 'package:astrobite/features/tracker/presentation/widgets/water_tracking_sheet.dart';
import 'package:astrobite/features/tracker/presentation/widgets/water_wave_painter.dart';

void main() {
  group('ClayWaterCard Widget Tests', () {
    testWidgets('renders ClayWaterCard with default progress and quick buttons', (tester) async {
      final sampleLog = WaterDayLog(
        id: '20261021',
        date: '2026-10-21',
        currentMl: 750,
        targetMl: 2000,
        entries: const [],
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dailyWaterStreamProvider.overrideWith((ref) => Stream.value(sampleLog)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClayWaterCard(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Nước Uống Hôm Nay'), findsOneWidget);
      expect(find.text('2000 ml 🎯'), findsOneWidget);
      expect(find.text('750'), findsOneWidget);
      expect(find.text(' / 2000 ml'), findsOneWidget);
      expect(find.text('Còn 1250 ml nữa để đạt 100%'), findsOneWidget);
      expect(find.text('+250 ml'), findsOneWidget);
      expect(find.text('+500 ml'), findsOneWidget);
      expect(find.text('Tùy chọn'), findsOneWidget);
      expect(find.byType(WaterWaveIndicator), findsOneWidget);
    });

    testWidgets('renders celebration banner when goal is reached', (tester) async {
      final sampleLog = WaterDayLog(
        id: '20261021',
        date: '2026-10-21',
        currentMl: 2250,
        targetMl: 2000,
        entries: const [],
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dailyWaterStreamProvider.overrideWith((ref) => Stream.value(sampleLog)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClayWaterCard(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('🎉 Đạt mục tiêu!'), findsOneWidget);
      expect(find.text('Đã vượt 250 ml so với mục tiêu'), findsOneWidget);
    });

    testWidgets('tapping Tùy chọn opens WaterTrackingSheet', (tester) async {
      final sampleLog = WaterDayLog(
        id: '20261021',
        date: '2026-10-21',
        currentMl: 500,
        targetMl: 2000,
        entries: const [],
        updatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dailyWaterStreamProvider.overrideWith((ref) => Stream.value(sampleLog)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ClayWaterCard(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Tap on 'Tùy chọn'
      await tester.tap(find.text('Tùy chọn'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(WaterTrackingSheet), findsOneWidget);
      expect(find.text('Ghi Nhận Nước Uống'), findsOneWidget);
      expect(find.text('Thêm +250 ml'), findsOneWidget);
    });

    testWidgets('WaterWaveIndicator renders at custom size without overflow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: WaterWaveIndicator(
                progress: 0.65,
                size: 96,
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('65%'), findsOneWidget);
      expect(find.byType(WaterWaveIndicator), findsOneWidget);
    });
  });
}
