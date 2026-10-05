import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/scanner/data/models/scan_result_dto.dart';
import 'package:astrobite/features/scanner/domain/entities/scan_result.dart';
import 'package:astrobite/features/scanner/presentation/pages/scan_review_page.dart';
import 'package:astrobite/features/scanner/presentation/widgets/broth_toggle_chip.dart';
import 'package:astrobite/features/scanner/presentation/widgets/topping_checklist_wrap.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _FakeUser implements User {
  @override
  String get uid => 'user-viet-999';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepository implements AuthRepository {
  @override
  User? get currentUser => _FakeUser();

  @override
  Stream<User?> get authStateChanges => Stream.value(_FakeUser());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFoodLogRepository implements FoodLogRepository {
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
  group('Vietnamese Culinary Decomposition Unit Tests (Sprint 19 - EPIC-GLOBAL)', () {
    test('TC-S19-01: DishItem with broth deducts calories and sodium when includeBroth is false', () {
      final dish = DishItem(
        dishName: 'Phở Bò Tái Nạm',
        confidenceScore: 0.95,
        estimatedWeightG: 600,
        calories: 520,
        carbsG: 65,
        proteinG: 28,
        fatG: 16,
        sodiumMg: 1850.0,
        hasBroth: true,
        brothCalories: 190,
        brothSodiumMg: 1350.0,
        includeBroth: true,
      );

      // Default: Eating both broth and meat/noodles
      expect(dish.effectiveCalories, 520);
      expect(dish.effectiveSodiumMg, 1850.0);
      expect(dish.effectiveFatG, 16);

      // Gạt toggle sang Chỉ ăn cái
      dish.includeBroth = false;
      expect(dish.effectiveCalories, 330); // 520 - 190 = 330
      expect(dish.effectiveSodiumMg, 500.0); // 1850 - 1350 = 500
      expect(dish.effectiveFatG, 8); // 16 - (190 * 0.4 / 9).round() = 16 - 8 = 8
    });

    test('TC-S19-02: Rapid toggle 10 times restores original values without drift', () {
      final dish = DishItem(
        dishName: 'Bún Bò Huế',
        confidenceScore: 0.93,
        estimatedWeightG: 550,
        calories: 600,
        carbsG: 70,
        proteinG: 32,
        fatG: 20,
        sodiumMg: 2100.0,
        hasBroth: true,
        brothCalories: 220,
        brothSodiumMg: 1600.0,
        includeBroth: true,
      );

      for (int i = 0; i < 10; i++) {
        dish.includeBroth = !dish.includeBroth;
      }

      // After even number of toggles (10), includeBroth is back to true
      expect(dish.includeBroth, isTrue);
      expect(dish.effectiveCalories, 600);
      expect(dish.effectiveSodiumMg, 2100.0);
      expect(dish.effectiveFatG, 20);
    });

    test('TC-S19-03: Sub-items decomposition deducts topping calories and macros', () {
      final dish = DishItem(
        dishName: 'Cơm Tấm Sườn Bì Chả',
        confidenceScore: 0.94,
        estimatedWeightG: 450,
        calories: 680,
        carbsG: 75,
        proteinG: 35,
        fatG: 26,
        subItems: [
          SubDishItem(name: 'Cơm tấm trắng', calories: 210, carbsG: 45, isSelected: true),
          SubDishItem(name: 'Sườn nướng', calories: 230, proteinG: 22, fatG: 14, isSelected: true),
          SubDishItem(name: 'Chả trứng', calories: 110, proteinG: 8, fatG: 7, isSelected: true),
          SubDishItem(name: 'Bì heo', calories: 70, proteinG: 5, fatG: 3, isSelected: true),
          SubDishItem(name: 'Mỡ hành', calories: 60, fatG: 6, isSelected: true),
        ],
      );

      expect(dish.effectiveCalories, 680);
      expect(dish.effectiveFatG, 26);

      // Bỏ mỡ hành
      dish.subItems.last.isSelected = false;
      expect(dish.effectiveCalories, 620); // 680 - 60 = 620
      expect(dish.effectiveFatG, 20); // 26 - 6 = 20
    });

    test('TC-S19-04: Extreme topping unselection clamps to base and does not become negative', () {
      final dish = DishItem(
        dishName: 'Cơm Tấm',
        confidenceScore: 0.9,
        estimatedWeightG: 400,
        calories: 400,
        subItems: [
          SubDishItem(name: 'Cơm', calories: 200, isSelected: true),
          SubDishItem(name: 'Topping 1', calories: 150, isSelected: false),
          SubDishItem(name: 'Topping 2', calories: 150, isSelected: false),
        ],
      );

      // 400 - 150 - 150 = 100
      expect(dish.effectiveCalories, 100);
      expect(dish.effectiveCalories, greaterThanOrEqualTo(0));
    });

    test('TC-S19-06: Corrupted AI data clamp protection (broth_calories > total calories)', () {
      final dish = DishItem(
        dishName: 'Canh Chua',
        confidenceScore: 0.8,
        estimatedWeightG: 300,
        calories: 120,
        hasBroth: true,
        brothCalories: 250, // Corrupted: broth > total!
        includeBroth: false,
      );

      // Clamped: max(0, 120 - 250) = 0, never negative
      expect(dish.effectiveCalories, 0);
    });

    test('TC-S19-07: ScanResultDto Json serialization & backward compatibility', () {
      // JSON without broth or sub-items (old format)
      final legacyJson = {
        'is_food': true,
        'total_calories': 400,
        'macros': {'protein_g': 20, 'carbs_g': 50, 'fat_g': 10},
        'dishes': [
          {
            'dish_name': 'Bánh Mì Thịt',
            'confidence_score': 0.9,
            'estimated_weight_g': 200,
            'calories': 400,
          }
        ],
      };

      final dto = ScanResultDto.fromJson(legacyJson);
      expect(dto.dishes.first.hasBroth, isFalse);
      expect(dto.dishes.first.brothCalories, 0);
      expect(dto.dishes.first.includeBroth, isTrue);
      expect(dto.dishes.first.subItems, isEmpty);

      // JSON with broth and sub-items (Sprint 19 new format)
      final newJson = {
        'is_food': true,
        'total_calories': 520,
        'macros': {'protein_g': 28, 'carbs_g': 65, 'fat_g': 16},
        'dishes': [
          {
            'dish_name': 'Phở Bò Tái Nạm',
            'confidence_score': 0.95,
            'estimated_weight_g': 600,
            'calories': 520,
            'has_broth': true,
            'broth_calories': 190,
            'broth_sodium_mg': 1350.0,
            'include_broth': true,
            'sub_items': [
              {
                'name': 'Thịt bò tái',
                'calories': 150,
                'protein_g': 24,
                'fat_g': 6,
                'is_selected': true,
              }
            ],
          }
        ],
      };

      final newDto = ScanResultDto.fromJson(newJson);
      expect(newDto.dishes.first.hasBroth, isTrue);
      expect(newDto.dishes.first.brothCalories, 190);
      expect(newDto.dishes.first.brothSodiumMg, 1350.0);
      expect(newDto.dishes.first.subItems?.first.name, 'Thịt bò tái');
      expect(newDto.dishes.first.subItems?.first.calories, 150);
    });
  });

  group('Vietnamese Culinary Decomposition Widget Tests', () {
    late _FakeAuthRepository fakeAuth;
    late _FakeFoodLogRepository fakeLog;

    setUp(() {
      fakeAuth = _FakeAuthRepository();
      fakeLog = _FakeFoodLogRepository();
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeAuth),
          foodLogRepositoryProvider.overrideWithValue(fakeLog),
        ],
        child: MaterialApp(home: child),
      );
    }

    testWidgets('BrothToggleChip renders and toggles between include and exclude states', (tester) async {
      bool currentInclude = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return BrothToggleChip(
                  hasBroth: true,
                  includeBroth: currentInclude,
                  brothCalories: 190,
                  brothSodiumMg: 1350.0,
                  onToggle: (val) => setState(() => currentInclude = val),
                );
              },
            ),
          ),
        ),
      );

      // Initial state: Eating both (Ăn cả nước)
      expect(find.textContaining('Ăn cả nước (+190 kcal)'), findsOneWidget);
      expect(find.textContaining('1350mg Muối'), findsOneWidget);

      // Tap to switch to "Chỉ ăn cái"
      await tester.tap(find.byKey(const Key('broth_toggle_chip_inkwell')));
      await tester.pumpAndSettle();

      expect(currentInclude, isFalse);
      expect(find.textContaining('Chỉ ăn cái (-190 kcal)'), findsOneWidget);
    });

    testWidgets('ToppingChecklistWrap renders chips and toggles selection', (tester) async {
      final subItems = [
        SubDishItem(name: 'Sườn nướng', calories: 230, isSelected: true),
        SubDishItem(name: 'Mỡ hành', calories: 60, isSelected: true),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ToppingChecklistWrap(
                  subItems: subItems,
                  onToggleSubItem: (idx, isSel) {
                    setState(() {
                      subItems[idx].isSelected = isSel;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('TOPPING & MÓN PHỤ (CHẠM ĐỂ BỎ BỚT)'), findsOneWidget);
      expect(find.text('Sườn nướng (230 kcal)'), findsOneWidget);
      expect(find.text('Mỡ hành (60 kcal)'), findsOneWidget);

      // Tap on Mỡ hành to unselect
      await tester.tap(find.byKey(const Key('topping_chip_1')));
      await tester.pumpAndSettle();

      expect(subItems[1].isSelected, isFalse);
    });

    testWidgets('ScanReviewPage updates displayed calories when broth is toggled and saves correct values', (tester) async {
      final soupResult = ScanResult(
        isFood: true,
        totalCalories: 520,
        proteinG: 28,
        carbsG: 65,
        fatG: 16,
        sodiumMg: 1850.0,
        dishes: [
          DishItem(
            dishName: 'Phở Bò Tái Nạm',
            confidenceScore: 0.95,
            estimatedWeightG: 600,
            calories: 520,
            carbsG: 65,
            proteinG: 28,
            fatG: 16,
            sodiumMg: 1850.0,
            hasBroth: true,
            brothCalories: 190,
            brothSodiumMg: 1350.0,
            includeBroth: true,
          ),
        ],
      );

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(ScanReviewPage(scanResult: soupResult)));
      await tester.pumpAndSettle();

      // Check initial render
      expect(find.text('Phở Bò Tái Nạm'), findsWidgets);
      expect(find.textContaining('Ăn cả nước (+190 kcal)'), findsOneWidget);

      // Tap Broth toggle to switch to "Chỉ ăn cái"
      final brothChip = find.byKey(const Key('broth_toggle_chip_inkwell'));
      await tester.ensureVisible(brothChip);
      await tester.tap(brothChip);
      await tester.pumpAndSettle();

      expect(find.textContaining('Chỉ ăn cái (-190 kcal)'), findsOneWidget);

      // Save food log
      final saveBtn = find.textContaining('Lưu vào');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify saved log has effective calories deducted
      expect(fakeLog.savedLogs, isNotEmpty);
      final savedLog = fakeLog.savedLogs.first;
      expect(savedLog.calories, 330); // 520 - 190 = 330!
      expect(savedLog.dishes?.first['has_broth'], isTrue);
      expect(savedLog.dishes?.first['include_broth'], isFalse);
      expect(savedLog.dishes?.first['broth_calories'], 190);
    });

    testWidgets('ScanReviewPage hides BrothToggleChip on dry non-broth dish (TC-S19-05)', (tester) async {
      final dryResult = ScanResult(
        isFood: true,
        totalCalories: 350,
        proteinG: 15,
        carbsG: 45,
        fatG: 10,
        dishes: [
          DishItem(
            dishName: 'Gỏi Cuốn Tôm Thịt',
            confidenceScore: 0.92,
            estimatedWeightG: 250,
            calories: 350,
            hasBroth: false,
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(ScanReviewPage(scanResult: dryResult)));
      await tester.pumpAndSettle();

      expect(find.text('Gỏi Cuốn Tôm Thịt'), findsWidgets);
      expect(find.byKey(const Key('broth_toggle_chip_inkwell')), findsNothing);
    });
  });
}
