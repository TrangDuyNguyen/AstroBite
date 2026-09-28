import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/presentation/widgets/zero_gravity_food_background.dart';

void main() {
  group('ZeroGravityFoodBackground Widget Tests', () {
    testWidgets('renders all 10 3D sculpted clay food and fruit drawings in zero gravity', (tester) async {
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

      // Verify that all 10 signature 3D clay food & fruit art items are present
      expect(find.byType(Clay3DFoodArt), findsNWidgets(10));
      for (final type in Clay3DFoodType.values) {
        expect(
          find.byWidgetPredicate((w) => w is Clay3DFoodArt && w.foodType == type),
          findsOneWidget,
        );
      }

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

      expect(
        find.byWidgetPredicate((w) => w is Clay3DFoodArt && w.foodType == Clay3DFoodType.apple),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is Clay3DFoodArt && w.foodType == Clay3DFoodType.pizza),
        findsOneWidget,
      );
    });
  });
}
