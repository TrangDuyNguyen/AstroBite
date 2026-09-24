import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/pages/manual_entry_page.dart';
import 'package:astrobite/shared/widgets/meal_type_chip.dart';

class FakeUser implements User {
  @override
  String get uid => 'user-test-123';

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

  @override
  Future<int> syncPendingLogs({required String userId}) async => 0;

  @override
  Future<List<FoodLogDto>> getPendingSyncLogs({required String userId}) async => [];
}

void main() {
  late FakeAuthRepository fakeAuthRepo;
  late FakeFoodLogRepository fakeLogRepo;

  setUp(() {
    fakeAuthRepo = FakeAuthRepository();
    fakeLogRepo = FakeFoodLogRepository();
  });

  Widget createWidgetUnderTest({String? initialMealType}) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepo),
        foodLogRepositoryProvider.overrideWithValue(fakeLogRepo),
      ],
      child: MaterialApp(
        home: ManualEntryPage(initialMealType: initialMealType),
      ),
    );
  }

  group('ManualEntryPage Widget Tests', () {
    testWidgets('renders search bar, meal chips, and popular food list', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify 4 meal type chips
      expect(find.byType(MealTypeChip), findsNWidgets(4));

      // Verify search bar
      expect(find.byType(TextField), findsWidgets);

      // Verify default food card selected (Phở bò)
      expect(find.text('Phở bò'), findsWidgets);

      // Verify macros displayed
      expect(find.text('Tinh bột'), findsWidgets);
      expect(find.text('Chất đạm'), findsWidgets);
      expect(find.text('Chất béo'), findsWidgets);
    });

    testWidgets('pre-selects meal type when initialMealType is provided', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(initialMealType: 'dinner'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Bữa tối'), findsWidgets);
    });

    testWidgets('filters food list when query entered in search bar', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'Bún chả');
      await tester.pumpAndSettle();

      expect(find.text('Bún chả Hà Nội'), findsOneWidget);
      expect(find.text('Cơm tấm sườn bì chả'), findsNothing);
    });

    testWidgets('adjusts weight via slider and saves food log to repository', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(initialMealType: 'lunch'));
      await tester.pumpAndSettle();

      // Find save button
      final saveBtn = find.textContaining('Lưu vào Bữa trưa');
      expect(saveBtn, findsOneWidget);

      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(fakeLogRepo.savedLogs.length, 1);
      final saved = fakeLogRepo.savedLogs.first;
      expect(saved.dishName, 'Phở bò');
      expect(saved.mealType, 'lunch');
      expect(saved.calories, 450);
      expect(saved.source, 'manual_entry');
    });

    testWidgets('opens custom food sheet and submits custom food entry', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(initialMealType: 'breakfast'));
      await tester.pumpAndSettle();

      // Tap custom entry button
      final customEntryBtn = find.text('Tự nhập món');
      await tester.tap(customEntryBtn);
      await tester.pumpAndSettle();

      expect(find.text('Thêm món ăn tùy chỉnh'), findsOneWidget);

      // Enter dish name & calories
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Salad bơ trứng');
      await tester.enterText(textFields.at(1), '200'); // weight
      await tester.enterText(textFields.at(2), '250'); // calories

      // Submit
      final submitBtn = find.text('Thêm vào bữa ăn');
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(fakeLogRepo.savedLogs.length, 1);
      final saved = fakeLogRepo.savedLogs.first;
      expect(saved.dishName, 'Salad bơ trứng');
      expect(saved.estimatedWeightG, 200);
      expect(saved.calories, 250);
      expect(saved.source, 'manual_entry');
    });

    testWidgets('US-01: selects food via Recent Foods tray and updates scaling card', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Recent foods header is visible
      expect(find.text('Món gần đây:'), findsOneWidget);

      // Find chip for 'Ức gà áp chảo' in recent list and tap it
      final chickenChip = find.textContaining('Ức gà áp chảo');
      expect(chickenChip, findsWidgets);
      await tester.tap(chickenChip.first);
      await tester.pumpAndSettle();

      // Selected card should reflect Ức gà áp chảo and 165 kcal
      expect(find.text('Ức gà áp chảo'), findsWidgets);
      expect(find.text('165 kcal'), findsWidgets);
    });

    testWidgets('US-02: modifies weight via Quick Steppers (+50g, -50g, 1 Bát, 1 Đĩa)', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial weight for Phở bò is 350g (baseWeightG)
      expect(find.text('350g'), findsWidgets);

      // Tap '+50g' -> 400g
      final plus50 = find.text('+50g');
      expect(plus50, findsOneWidget);
      await tester.tap(plus50);
      await tester.pumpAndSettle();
      expect(find.text('400g'), findsWidgets);

      // Tap '1 Đĩa (~300g)'
      final platePreset = find.text('1 Đĩa (~300g)');
      expect(platePreset, findsOneWidget);
      await tester.tap(platePreset);
      await tester.pumpAndSettle();
      expect(find.text('300g'), findsWidgets);

      // Tap '1 Bát (~150g)'
      final bowlPreset = find.text('1 Bát (~150g)');
      expect(bowlPreset, findsOneWidget);
      await tester.tap(bowlPreset);
      await tester.pumpAndSettle();
      expect(find.text('150g'), findsWidgets);

      // Tap '-50g' twice -> 100g -> 50g (min limit BVA)
      final minus50 = find.text('-50g');
      await tester.tap(minus50);
      await tester.pumpAndSettle();
      expect(find.text('100g'), findsWidgets);

      await tester.tap(minus50);
      await tester.pumpAndSettle();
      expect(find.text('50g'), findsWidgets);

      // Tapping again should clamp at 50g
      await tester.tap(minus50);
      await tester.pumpAndSettle();
      expect(find.text('50g'), findsWidgets);
    });

    testWidgets('US-03: sticky bottom bar has meal chips and save CTA', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest(initialMealType: 'dinner'));
      await tester.pumpAndSettle();

      // Meal chips are in the bottom bar
      expect(find.byType(MealTypeChip), findsNWidgets(4));

      // Save button reflects dinner
      expect(find.textContaining('Lưu vào Bữa tối'), findsOneWidget);
    });
  });
}
