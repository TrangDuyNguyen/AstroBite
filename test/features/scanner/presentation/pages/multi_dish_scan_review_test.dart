import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/scanner/domain/entities/scan_result.dart';
import 'package:astrobite/features/scanner/presentation/pages/scan_review_page.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';

class FakeUser implements User {
  @override
  String get uid => 'user-multi-99';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthRepository implements AuthRepository {
  @override
  User? get currentUser => FakeUser();

  @override
  Stream<User?> get authStateChanges => Stream.value(FakeUser());

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

  @override
  Future<int> syncPendingLogs({required String userId}) async => 0;

  @override
  Future<List<FoodLogDto>> getPendingSyncLogs({required String userId}) async => [];
}

void main() {
  late FakeAuthRepository fakeAuthRepo;
  late FakeFoodLogRepository fakeLogRepo;

  final multiDishScanResult = ScanResult(
    isFood: true,
    totalCalories: 750,
    proteinG: 35,
    carbsG: 85,
    fatG: 22,
    sodiumMg: 1100.0,
    fiberG: 5.5,
    sugarG: 4.0,
    dishes: [
      DishItem(
        dishName: 'Cơm tấm',
        confidenceScore: 0.95,
        estimatedWeightG: 200,
        calories: 300,
        carbsG: 55,
        proteinG: 5,
        fatG: 2,
        sodiumMg: 50.0,
        fiberG: 1.0,
        sugarG: 0.5,
      ),
      DishItem(
        dishName: 'Sườn nướng',
        confidenceScore: 0.90,
        estimatedWeightG: 150,
        calories: 350,
        carbsG: 10,
        proteinG: 25,
        fatG: 18,
        sodiumMg: 850.0,
        fiberG: 0.5,
        sugarG: 3.0,
      ),
      DishItem(
        dishName: 'Chả trứng',
        confidenceScore: 0.88,
        estimatedWeightG: 80,
        calories: 100,
        carbsG: 20,
        proteinG: 5,
        fatG: 2,
        sodiumMg: 200.0,
        fiberG: 4.0,
        sugarG: 0.5,
      ),
    ],
  );

  setUp(() {
    fakeAuthRepo = FakeAuthRepository();
    fakeLogRepo = FakeFoodLogRepository();
  });

  Widget createWidget() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepo),
        foodLogRepositoryProvider.overrideWithValue(fakeLogRepo),
      ],
      child: MaterialApp(
        home: ScanReviewPage(scanResult: multiDishScanResult),
      ),
    );
  }

  group('Multi-Dish ScanReviewPage Tests', () {
    testWidgets('renders all dishes and meal micronutrients correctly', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // Check all 3 dishes present
      expect(find.text('Cơm tấm'), findsOneWidget);
      expect(find.text('Sườn nướng'), findsOneWidget);
      expect(find.text('Chả trứng'), findsOneWidget);

      // Check segment header
      expect(find.text('Thành phần nhận diện (3 món)'), findsOneWidget);

      // Check total calories initially 750 kcal
      expect(find.text('750 kcal'), findsWidgets);

      // Check micronutrient chips
      expect(find.textContaining('Muối:'), findsOneWidget);
      expect(find.textContaining('Xơ:'), findsOneWidget);
      expect(find.textContaining('Đường:'), findsOneWidget);
    });

    testWidgets('unchecking a dish subtracts its calories from total and updates save label', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // Find checkboxes: first is Cơm tấm (300 kcal), second is Sườn nướng (350 kcal), third is Chả trứng (100 kcal)
      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(3));

      // Uncheck 'Chả trứng' (index 2: -100 kcal)
      await tester.tap(checkboxes.at(2));
      await tester.pumpAndSettle();

      // Total should now be 750 - 100 = 650 kcal
      expect(find.text('650 kcal'), findsWidgets);
    });

    testWidgets('saving multi-dish meal writes multi_scan source and dishes array', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final saveBtn = find.widgetWithText(FilledButton, 'Lưu vào Bữa trưa (750 kcal)');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(fakeLogRepo.savedLogs.length, 1);
      final saved = fakeLogRepo.savedLogs.first;
      expect(saved.source, 'multi_scan');
      expect(saved.calories, 750);
      expect(saved.dishes?.length, 3);
      expect(saved.dishName, contains('Cơm tấm'));
      expect(saved.dishName, contains('Sườn nướng'));
    });
  });
}
