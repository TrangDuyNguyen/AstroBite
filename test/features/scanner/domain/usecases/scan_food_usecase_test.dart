import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/features/scanner/data/models/scan_result_dto.dart';
import 'package:astrobite/features/scanner/domain/repositories/food_scan_repository.dart';
import 'package:astrobite/features/scanner/domain/usecases/scan_food_usecase.dart';

class FakeFoodScanRepository implements FoodScanRepository {
  int scanCount = 0;
  int incrementCountCalls = 0;
  ScanResultDto? dtoToReturn;
  bool shouldThrow = false;
  String? errorMessage;

  @override
  Future<int> getTodayScanCount(String userId, String date) async {
    return scanCount;
  }

  @override
  Future<void> incrementScanCount(String userId, String date) async {
    incrementCountCalls++;
  }

  @override
  Future<ScanResultDto?> scanFoodImage(Uint8List imageBytes) async {
    if (shouldThrow) {
      throw Exception(errorMessage ?? 'Scan failed');
    }
    return dtoToReturn;
  }
}

void main() {
  late FakeFoodScanRepository fakeRepo;
  late ScanFoodUseCase useCase;

  final sampleImageBytes = Uint8List.fromList([1, 2, 3, 4]);

  setUp(() {
    fakeRepo = FakeFoodScanRepository();
    useCase = ScanFoodUseCase(repository: fakeRepo);
  });

  group('ScanFoodUseCase Tests', () {
    test('returns QuotaExceeded when daily limit is reached', () async {
      fakeRepo.scanCount = AppValues.maxDailyScans;

      final result = await useCase.execute(
        userId: 'user-1',
        imageBytes: sampleImageBytes,
      );

      expect(result, isA<QuotaExceeded>());
      expect(fakeRepo.incrementCountCalls, 0);
    });

    test('returns NotFoodResult when AI detects non-food object', () async {
      fakeRepo.scanCount = 0;
      fakeRepo.dtoToReturn = const ScanResultDto(
        isFood: false,
        totalCalories: 0,
        macros: MacroDto(proteinG: 0, carbsG: 0, fatG: 0),
        dishes: [],
      );

      final result = await useCase.execute(
        userId: 'user-1',
        imageBytes: sampleImageBytes,
      );

      expect(result, isA<NotFoodResult>());
      expect(fakeRepo.incrementCountCalls, 0);
    });

    test('returns ScanSuccess and increments scan count when valid food is detected', () async {
      fakeRepo.scanCount = 0;
      fakeRepo.dtoToReturn = const ScanResultDto(
        isFood: true,
        totalCalories: 550,
        macros: MacroDto(proteinG: 30, carbsG: 70, fatG: 15),
        dishes: [
          DishDto(
            dishName: 'Phở bò tái',
            confidenceScore: 0.95,
            estimatedWeightG: 400,
            calories: 550,
          ),
        ],
      );

      final result = await useCase.execute(
        userId: 'user-1',
        imageBytes: sampleImageBytes,
      );

      expect(result, isA<ScanSuccess>());
      final success = result as ScanSuccess;
      expect(success.result.isFood, true);
      expect(success.result.totalCalories, 550);
      expect(success.result.carbsG, 70);
      expect(success.result.proteinG, 30);
      expect(success.result.fatG, 15);
      expect(success.result.dishes.length, 1);
      expect(success.result.dishes.first.dishName, 'Phở bò tái');
      expect(fakeRepo.incrementCountCalls, 1);
    });

    test('returns ScanError when repository throws an exception', () async {
      fakeRepo.scanCount = 0;
      fakeRepo.shouldThrow = true;
      fakeRepo.errorMessage = 'Network connection failed';

      final result = await useCase.execute(
        userId: 'user-1',
        imageBytes: sampleImageBytes,
      );

      expect(result, isA<ScanError>());
      final error = result as ScanError;
      expect(error.message, contains('Network connection failed'));
      expect(fakeRepo.incrementCountCalls, 0);
    });

    test('returns ScanError when dto is null', () async {
      fakeRepo.scanCount = 0;
      fakeRepo.dtoToReturn = null;

      final result = await useCase.execute(
        userId: 'user-1',
        imageBytes: sampleImageBytes,
      );

      expect(result, isA<ScanError>());
      expect(fakeRepo.incrementCountCalls, 0);
    });
  });
}
