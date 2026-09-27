import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/recipes/presentation/pages/recipes_page.dart';
import 'package:astrobite/features/recipes/presentation/controllers/recipe_builder_controller.dart';
import 'package:astrobite/features/recipes/domain/entities/recipe.dart';

void main() {
  group('RecipesPage Widget Tests', () {
    testWidgets('renders empty state and FAB gracefully without crashing on empty user', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(null)),
            recipesProvider('').overrideWith((ref) => Future.value(<Recipe>[])),
          ],
          child: const MaterialApp(
            home: RecipesPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check header title
      expect(find.text('Công Thức Của Tôi'), findsOneWidget);

      // Check empty state
      expect(find.textContaining('Chưa có công thức nào'), findsOneWidget);

      // Check FAB is present
      expect(find.text('Tạo Công Thức'), findsOneWidget);
    });
  });
}
