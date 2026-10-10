import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/recipes/presentation/pages/recipe_builder_page.dart';
import 'package:astrobite/features/recipes/presentation/controllers/recipe_builder_controller.dart';
import 'package:astrobite/features/recipes/domain/entities/recipe_ingredient.dart';

void main() {
  group('RecipeBuilderPage Widget Tests', () {
    testWidgets('renders all core UI elements and empty ingredients on initial load', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RecipeBuilderPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check header title & Save button
      expect(find.text('Tạo Công Thức Món Ăn'), findsOneWidget);
      expect(find.text('Lưu'), findsOneWidget);

      // Check section labels
      expect(find.text('Tên Công Thức'), findsOneWidget);
      expect(find.text('Ghi Chú Chế Biến (tuỳ chọn)'), findsOneWidget);
      expect(find.text('Tổng Dinh Dưỡng Công Thức'), findsOneWidget);
      expect(find.text('Nguyên Liệu'), findsOneWidget);

      // Check macro summary defaults (0 kcal, 0.0g)
      expect(find.text('0 kcal'), findsOneWidget);
      expect(find.text('Carbs'), findsOneWidget);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);

      // Check empty state
      expect(find.text('Chưa có nguyên liệu nào'), findsOneWidget);
      expect(find.text('Thêm'), findsOneWidget);
    });

    testWidgets('renders ingredient tile and updates macro summary when ingredients present', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Add one ingredient
      container.read(recipeBuilderProvider.notifier).addIngredient(
        const RecipeIngredient(
          foodId: 'ing_1',
          name: 'Ức gà phi lê',
          amountGrams: 150,
          calories: 240,
          carbs: 0,
          protein: 46,
          fat: 5,
        ),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: RecipeBuilderPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check ingredient tile is rendered
      expect(find.text('Ức gà phi lê'), findsOneWidget);
      expect(find.text('150g • 240 kcal'), findsOneWidget);

      // Check macro summary card reflects values
      expect(find.text('240 kcal'), findsOneWidget);
      expect(find.text('46.0g'), findsOneWidget);
    });
  });
}
