import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:astrobite/core/constants/app_values.dart';
import '../data/food_scan_repository.dart';
import 'entities/scan_result.dart';

sealed class ScanFoodResult {}

class ScanSuccess extends ScanFoodResult {
  ScanSuccess(this.result);
  final ScanResult result;
}

class QuotaExceeded extends ScanFoodResult {}

class NotFoodResult extends ScanFoodResult {}

class ScanError extends ScanFoodResult {
  ScanError(this.message);
  final String message;
}

class ScanFoodUseCase {
  ScanFoodUseCase({required FoodScanRepository repository})
      : _repository = repository;

  final FoodScanRepository _repository;

  Future<ScanFoodResult> execute({
    required String userId,
    required Uint8List imageBytes,
  }) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. Check rate limit
    final scanCount = await _repository.getTodayScanCount(userId, today);
    if (scanCount >= AppValues.maxDailyScans) {
      return QuotaExceeded();
    }

    // 2. Perform AI scan
    try {
      final dto = await _repository.scanFoodImage(imageBytes);
      if (dto == null) {
        return ScanError('Không thể phân tích phản hồi từ AI.');
      }

      if (!dto.isFood) {
        return NotFoodResult();
      }

      // 3. Increment scan count on success
      await _repository.incrementScanCount(userId, today);

      final domainResult = ScanResult(
        isFood: dto.isFood,
        totalCalories: dto.totalCalories,
        proteinG: dto.macros.proteinG,
        carbsG: dto.macros.carbsG,
        fatG: dto.macros.fatG,
        dishes: dto.dishes
            .map((d) => DishItem(
                  dishName: d.dishName,
                  confidenceScore: d.confidenceScore,
                  estimatedWeightG: d.estimatedWeightG,
                  calories: d.calories,
                ))
            .toList(),
      );

      return ScanSuccess(domainResult);
    } catch (e) {
      return ScanError(e.toString());
    }
  }
}
