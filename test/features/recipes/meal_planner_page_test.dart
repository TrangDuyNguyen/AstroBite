import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/recipes/domain/entities/meal_plan_item.dart';
import 'package:astrobite/features/recipes/domain/entities/recipe.dart';
import 'package:astrobite/features/recipes/domain/repositories/meal_plan_repository.dart';
import 'package:astrobite/features/recipes/presentation/pages/meal_planner_page.dart';
import 'package:astrobite/features/recipes/presentation/controllers/recipe_builder_controller.dart';
import 'package:astrobite/features/recipes/presentation/widgets/add_meal_plan_item_sheet.dart';
import 'package:astrobite/features/recipes/recipes_providers.dart';

class _MockMealPlanRepo implements MealPlanRepository {
  final List<MealPlanItem> items = [];

  @override
  Future<List<MealPlanItem>> getMealPlanItems(String userId, String date) async {
    return items.where((i) => i.date == date).toList();
  }

  @override
  Future<MealPlanItem> saveMealPlanItem(MealPlanItem item) async {
    final saved = item.copyWith(id: 'item_${items.length + 1}');
    items.add(saved);
    return saved;
  }

  @override
  Future<void> markAsLoggedForUser(String userId, String itemId) async {
    final idx = items.indexWhere((i) => i.id == itemId);
    if (idx != -1) {
      items[idx] = items[idx].copyWith(isLogged: true);
    }
  }

  @override
  Future<void> deleteMealPlanItemForUser(String userId, String itemId) async {
    items.removeWhere((i) => i.id == itemId);
  }
}

void main() {
  group('MealPlannerPage Widget Tests', () {
    testWidgets('renders all meal slots and opens AddMealPlanItemSheet when tapping +', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final mockRepo = _MockMealPlanRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mealPlanRepositoryProvider.overrideWithValue(mockRepo),
            authStateProvider.overrideWith((ref) => Stream.value(null)),
            recipesProvider('guest_user').overrideWith((ref) => Future.value(<Recipe>[])),
          ],
          child: const MaterialApp(
            home: MealPlannerPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check header title
      expect(find.text('Kế Hoạch Bữa Ăn'), findsOneWidget);

      // Check empty slots exist for all 4 meal types
      expect(find.textContaining('Lên thực đơn cho Bữa sáng'), findsOneWidget);
      expect(find.textContaining('Lên thực đơn cho Bữa trưa'), findsOneWidget);
      expect(find.textContaining('Lên thực đơn cho Bữa tối'), findsOneWidget);
      expect(find.textContaining('Lên thực đơn cho Bữa phụ'), findsOneWidget);

      // Tap + button on the first meal slot (Bữa sáng)
      final addIcons = find.byIcon(Icons.add_rounded);
      expect(addIcons, findsWidgets);
      await tester.tap(addIcons.first);
      await tester.pumpAndSettle();

      // Check AddMealPlanItemSheet is shown
      expect(find.byType(AddMealPlanItemSheet), findsOneWidget);
      expect(find.textContaining('Thêm Vào Bữa sáng'), findsOneWidget);
      expect(find.text('Từ Công Thức'), findsOneWidget);
      expect(find.text('Tự Nhập Món'), findsOneWidget);

      // Switch to custom entry tab
      await tester.tap(find.text('Tự Nhập Món'));
      await tester.pumpAndSettle();

      // Enter food name and calories
      await tester.enterText(find.widgetWithText(TextFormField, 'Tên món ăn'), 'Phở Bò');
      await tester.enterText(find.widgetWithText(TextFormField, 'Năng lượng (kcal)'), '450');
      await tester.pumpAndSettle();

      // Tap submit
      await tester.tap(find.text('Thêm Vào Kế Hoạch'));
      await tester.pumpAndSettle();

      // Check sheet is closed and item is added
      expect(find.byType(AddMealPlanItemSheet), findsNothing);
      expect(find.text('Phở Bò'), findsOneWidget);
      expect(find.textContaining('450 kcal'), findsWidgets);
    });
  });
}
