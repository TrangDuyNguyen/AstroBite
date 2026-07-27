import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/food_scan_repository_impl.dart';
import 'repositories/food_scan_repository.dart';
import 'usecases/scan_food_usecase.dart';

final foodScanRepositoryProvider = Provider<FoodScanRepository>((ref) {
  return FoodScanRepositoryImpl();
});

final scanFoodUseCaseProvider = Provider<ScanFoodUseCase>((ref) {
  return ScanFoodUseCase(repository: ref.watch(foodScanRepositoryProvider));
});
