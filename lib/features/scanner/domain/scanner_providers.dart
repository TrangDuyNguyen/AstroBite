import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/food_scan_repository.dart';
import 'scan_food_usecase.dart';

final foodScanRepositoryProvider = Provider<FoodScanRepository>((ref) {
  return FoodScanRepository();
});

final scanFoodUseCaseProvider = Provider<ScanFoodUseCase>((ref) {
  return ScanFoodUseCase(repository: ref.watch(foodScanRepositoryProvider));
});
