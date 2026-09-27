import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/solar_card.dart';
import 'package:astrobite/shared/widgets/macro_bar.dart';
import 'package:astrobite/shared/widgets/skeleton_loader.dart';
import 'package:astrobite/shared/widgets/meal_type_chip.dart';

void main() {
  group('Solar Fresh Design System Tests (Sprint 12)', () {
    test('AppColors defines Claymorphic palette correctly', () {
      expect(AppColors.surface, const Color(0xFFFAF8F5));
      expect(AppColors.surfaceContainer, const Color(0xFFFFFFFF));
      expect(AppColors.onSurface, const Color(0xFF1E2337));
      expect(AppColors.onSurfaceVariant, const Color(0xFF78829A));
      expect(AppColors.outline, const Color(0xFFE8E5DF));
      expect(AppColors.primary, const Color(0xFF1CB0F6)); // Duolingo Sky Blue
      expect(AppColors.secondary, const Color(0xFFFF5C8D)); // Strawberry Cream Pink
      expect(AppColors.tertiary, const Color(0xFFFF9600)); // Honey Tangerine Orange
      expect(AppColors.brandGreen, const Color(0xFF58CC02)); // Duolingo Lime
      expect(AppColors.shimmerBase, const Color(0xFFF0EFEB));
    });

    testWidgets('SolarCard renders child and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SolarCard(
              onTap: () => tapped = true,
              child: const Text('Solar Content'),
            ),
          ),
        ),
      );

      expect(find.text('Solar Content'), findsOneWidget);
      await tester.tap(find.text('Solar Content'));
      expect(tapped, isTrue);
    });

    testWidgets('MacroBar renders label and gram indicators', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MacroBar(
              label: 'Đạm',
              currentG: 45,
              targetG: 120,
              color: AppColors.protein,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Đạm'), findsOneWidget);
      expect(find.text('45g / 120g'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('SkeletonLoader renders with custom height and width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkeletonLoader(height: 48, width: 200),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      final container = tester.widget<Container>(containerFinder);
      expect(container.constraints?.minHeight, 48.0);
      expect(container.constraints?.maxWidth, 200.0);
    });

    testWidgets('MealTypeChip triggers tap callback and reflects selection', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MealTypeChip(
              mealType: 'breakfast',
              isSelected: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(MealTypeChip), findsOneWidget);
      await tester.tap(find.byType(MealTypeChip));
      expect(tapped, isTrue);
    });
  });
}
