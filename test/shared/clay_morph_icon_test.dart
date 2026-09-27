import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/shared/ui_kit/indicators/clay_morph_icon.dart';

void main() {
  group('ClayMorphIcon Widget Tests (Morphicons Spring Physics)', () {
    testWidgets('renders initial icon correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ClayMorphIcon(
                icon: Icons.nightlight_outlined,
                size: 24,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.nightlight_outlined), findsOneWidget);
    });

    testWidgets('animates and morphs with spring physics when icon changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ClayMorphIcon(
                icon: Icons.nightlight_outlined,
                size: 24,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.nightlight_outlined), findsOneWidget);

      // Rebuild with new icon
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ClayMorphIcon(
                icon: Icons.nightlight_round,
                size: 24,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      // Animation in progress: both may briefly be in the tree during AnimatedSwitcher
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ClayMorphIcon), findsOneWidget);

      // Settle animation to completion
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
    });
  });
}
