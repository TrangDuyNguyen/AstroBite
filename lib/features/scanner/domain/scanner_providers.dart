import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../data/repositories/food_scan_repository_impl.dart';
import 'repositories/food_scan_repository.dart';
import 'usecases/scan_food_usecase.dart';

final foodScanRepositoryProvider = Provider<FoodScanRepository>((ref) {
  return FoodScanRepositoryImpl();
});

final scanFoodUseCaseProvider = Provider<ScanFoodUseCase>((ref) {
  return ScanFoodUseCase(repository: ref.watch(foodScanRepositoryProvider));
});

final todayScanCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return 0;
  final repository = ref.watch(foodScanRepositoryProvider);
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return repository.getTodayScanCount(user.uid, today);
});
