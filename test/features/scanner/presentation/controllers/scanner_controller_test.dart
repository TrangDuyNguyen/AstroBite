import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/scanner/data/models/scan_result_dto.dart';
import 'package:astrobite/features/scanner/domain/repositories/food_scan_repository.dart';
import 'package:astrobite/features/scanner/domain/scanner_providers.dart';
import 'package:astrobite/features/scanner/domain/usecases/scan_food_usecase.dart';
import 'package:astrobite/features/scanner/presentation/controllers/scanner_controller.dart';

class FakeUser implements User {
  @override
  String get uid => 'test-user-123';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthRepository implements AuthRepository {
  User? userToReturn;

  @override
  User? get currentUser => userToReturn;

  @override
  Stream<User?> get authStateChanges => Stream.value(userToReturn);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFoodScanRepo implements FoodScanRepository {
  ScanResultDto? dtoToReturn;
  int scanCount = 0;

  @override
  Future<int> getTodayScanCount(String userId, String date) async => scanCount;

  @override
  Future<void> incrementScanCount(String userId, String date) async {}

  @override
  Future<ScanResultDto?> scanFoodImage(Uint8List imageBytes) async => dtoToReturn;
}

void main() {
  late ProviderContainer container;
  late FakeAuthRepository fakeAuthRepo;
  late FakeFoodScanRepo fakeScanRepo;

  final sampleBytes = Uint8List.fromList([1, 2, 3]);

  setUp(() {
    fakeAuthRepo = FakeAuthRepository()..userToReturn = FakeUser();
    fakeScanRepo = FakeFoodScanRepo();

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepo),
        foodScanRepositoryProvider.overrideWithValue(fakeScanRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ScannerController Tests', () {
    test('initial state is AsyncData(null)', () {
      final state = container.read(scannerControllerProvider);
      expect(state, const AsyncData<ScanFoodResult?>(null));
    });

    test('returns null if currentUser is null', () async {
      fakeAuthRepo.userToReturn = null;
      final controller = container.read(scannerControllerProvider.notifier);

      final result = await controller.scanImage(sampleBytes);

      expect(result, isNull);
      expect(container.read(scannerControllerProvider), const AsyncData<ScanFoodResult?>(null));
    });

    test('successfully scans and updates state to ScanSuccess', () async {
      fakeScanRepo.dtoToReturn = const ScanResultDto(
        isFood: true,
        totalCalories: 600,
        macros: MacroDto(proteinG: 25, carbsG: 75, fatG: 20),
        dishes: [
          DishDto(
            dishName: 'Cơm tấm',
            confidenceScore: 0.9,
            estimatedWeightG: 350,
            calories: 600,
          ),
        ],
      );

      final controller = container.read(scannerControllerProvider.notifier);
      final result = await controller.scanImage(sampleBytes);

      expect(result, isA<ScanSuccess>());
      final state = container.read(scannerControllerProvider);
      expect(state.value, isA<ScanSuccess>());
      final success = state.value as ScanSuccess;
      expect(success.result.totalCalories, 600);
      expect(success.result.primaryDishName, 'Cơm tấm');
    });

    test('reset clears state back to AsyncData(null)', () async {
      fakeScanRepo.dtoToReturn = const ScanResultDto(
        isFood: true,
        totalCalories: 600,
        macros: MacroDto(proteinG: 25, carbsG: 75, fatG: 20),
        dishes: [],
      );

      final controller = container.read(scannerControllerProvider.notifier);
      await controller.scanImage(sampleBytes);

      expect(container.read(scannerControllerProvider).value, isNotNull);

      controller.reset();
      expect(container.read(scannerControllerProvider), const AsyncData<ScanFoodResult?>(null));
    });
  });
}
