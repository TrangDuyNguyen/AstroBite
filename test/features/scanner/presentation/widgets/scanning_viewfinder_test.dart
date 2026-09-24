import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/scanner/presentation/widgets/scanning_viewfinder.dart';

void main() {
  group('ScanningViewfinder AR HUD Widget Tests', () {
    testWidgets('renders telemetry telemetry coordinates and focal lock badge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScanningViewfinder(
              isScanning: false, // keep stationary for test
            ),
          ),
        ),
      );
      await tester.pump();

      // Telemetry focal lock badge
      expect(find.text('[FOCAL LOCK: 98.4% CONFIDENCE]'), findsOneWidget);

      // Coordinates
      expect(find.text('X: 104.2'), findsOneWidget);
      expect(find.text('Y: 382.7'), findsOneWidget);
      expect(find.text('Z: 0.84m'), findsOneWidget);
      expect(find.text('FPS: 60'), findsOneWidget);
    });

    testWidgets('renders floating AI verified dish tag when detectedDishName provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScanningViewfinder(
              isScanning: false,
              detectedDishName: 'Phở Bò Tái Nạm',
              detectedCalories: 450,
            ),
          ),
        ),
      );
      await tester.pump();

      // Floating Tag contents
      expect(find.text('Phở Bò Tái Nạm'), findsOneWidget);
      expect(find.text('AI VERIFIED'), findsOneWidget);
      expect(find.text('450 kcal'), findsOneWidget);
    });
  });
}
