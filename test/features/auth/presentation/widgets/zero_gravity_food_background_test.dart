import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/presentation/widgets/zero_gravity_food_background.dart';

void main() {
  group('ZeroGravityFoodBackground Widget Tests', () {
    testWidgets('renders all 10 clay food and fruit icons in zero gravity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                ZeroGravityFoodBackground(),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that all signature clay food & fruit icons are present
      expect(find.byIcon(Icons.apple_rounded), findsOneWidget);
      expect(find.byIcon(Icons.eco_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bakery_dining_rounded), findsOneWidget);
      expect(find.byIcon(Icons.local_pizza_rounded), findsOneWidget);
      expect(find.byIcon(Icons.icecream_rounded), findsOneWidget);
      expect(find.byIcon(Icons.egg_alt_rounded), findsOneWidget);
      expect(find.byIcon(Icons.cookie_rounded), findsOneWidget);
      expect(find.byIcon(Icons.ramen_dining_rounded), findsOneWidget);
      expect(find.byIcon(Icons.local_cafe_rounded), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);

      // Verify that the background is wrapped in IgnorePointer and RepaintBoundary
      expect(find.byType(IgnorePointer), findsWidgets);
      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('respects disableAnimations setting and renders static resting state', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  ZeroGravityFoodBackground(),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.apple_rounded), findsOneWidget);
      expect(find.byIcon(Icons.local_pizza_rounded), findsOneWidget);
    });
  });
}
