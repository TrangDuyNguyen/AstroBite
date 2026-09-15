import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/scanner/domain/entities/scan_result.dart';
import 'package:astrobite/features/scanner/presentation/pages/scan_review_page.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/shared/widgets/meal_type_chip.dart';

class FakeUser implements User {
  @override
  String get uid => 'user-777';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthRepository implements AuthRepository {
  User? userToReturn = FakeUser();

  @override
  User? get currentUser => userToReturn;

  @override
  Stream<User?> get authStateChanges => Stream.value(userToReturn);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFoodLogRepository implements FoodLogRepository {
  final List<FoodLogDto> savedLogs = [];

  @override
  Future<void> addFoodLog({required String userId, required FoodLogDto log}) async {
    savedLogs.add(log);
  }

  @override
  Stream<List<FoodLogDto>> watchDailyLogs({required String userId, required String date}) {
    return Stream.value(savedLogs);
  }

  @override
  Future<void> deleteFoodLog({required String userId, required String logId}) async {}

  @override
  Future<List<FoodLogDto>> getLogsForDateRange({
    required String userId,
    required String startDate,
    required String endDate,
  }) async => savedLogs;
}

void main() {
  late FakeAuthRepository fakeAuthRepo;
  late FakeFoodLogRepository fakeLogRepo;

  final sampleScanResult = ScanResult(
    isFood: true,
    totalCalories: 500,
    proteinG: 30,
    carbsG: 60,
    fatG: 15,
    dishes: [
      DishItem(
        dishName: 'Phở Bò Tái',
        confidenceScore: 0.92,
        estimatedWeightG: 400,
        calories: 500,
      ),
    ],
  );

  setUp(() {
    fakeAuthRepo = FakeAuthRepository();
    fakeLogRepo = FakeFoodLogRepository();
  });

  Widget createWidgetUnderTest({ScanResult? result}) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepo),
        foodLogRepositoryProvider.overrideWithValue(fakeLogRepo),
      ],
      child: MaterialApp(
        home: ScanReviewPage(scanResult: result ?? sampleScanResult),
      ),
    );
  }

  group('ScanReviewPage Widget Tests', () {
    testWidgets('renders scan result with correct nutrition values and celestial layout', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Dish name & confidence
      expect(find.text('Phở Bò Tái'), findsOneWidget);
      expect(find.text('92% tin cậy'), findsOneWidget);

      // Calorie & macros
      expect(find.text('500 kcal'), findsWidgets);
      expect(find.text('60g'), findsOneWidget); // Carbs
      expect(find.text('30g'), findsOneWidget); // Protein
      expect(find.text('15g'), findsOneWidget); // Fat

      // Initial estimated weight badge
      expect(find.text('400g'), findsOneWidget);

      // Meal type chips
      expect(find.byType(MealTypeChip), findsNWidgets(4));
    });

    testWidgets('adjusting portion slider dynamically recalculates calories and macros', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find slider
      final sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);

      // Drag slider to the left or right
      await tester.drag(sliderFinder, const Offset(-100, 0));
      await tester.pumpAndSettle();

      // Portion weight should no longer be 400g
      expect(find.text('400g'), findsNothing);
    });

    testWidgets('selecting meal type and saving writes to food log repository', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final dinnerChip = find.text(AppStrings.dinner);
      await tester.tap(dinnerChip);
      await tester.pumpAndSettle();

      // Find save button (contains 'Lưu vào Bữa tối (500 kcal)')
      final saveBtn = find.widgetWithText(FilledButton, 'Lưu vào Bữa tối (500 kcal)');
      expect(saveBtn, findsOneWidget);

      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify that repository received log
      expect(fakeLogRepo.savedLogs.length, 1);
      final saved = fakeLogRepo.savedLogs.first;
      expect(saved.dishName, 'Phở Bò Tái');
      expect(saved.mealType, 'dinner');
      expect(saved.calories, 500);
      expect(saved.estimatedWeightG, 400);
      expect(saved.source, 'ai_scan');
    });

    testWidgets('shows empty state when no scan data is provided', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuthRepo),
            foodLogRepositoryProvider.overrideWithValue(fakeLogRepo),
          ],
          child: const MaterialApp(
            home: ScanReviewPage(scanResult: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Chưa có dữ liệu phân tích món ăn.'), findsOneWidget);
      expect(find.text('Quay lại Camera'), findsOneWidget);
    });
  });
}
