import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/scanner/presentation/widgets/scanning_viewfinder.dart';

void main() {
  group('ScanningViewfinder AR HUD Widget Tests', () {
    testWidgets('renders AI food detection status badge and reticle', (tester) async {
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

      // Modern AI detection badge
      expect(find.text('✨ ĐANG ĐỊNH VỊ MÓN ĂN'), findsOneWidget);
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
