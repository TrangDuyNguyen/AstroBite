import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/food_log_dto.dart';
import '../../domain/tracker_providers.dart';

final trackerControllerProvider =
    StateNotifierProvider.autoDispose<TrackerController, AsyncValue<void>>((ref) {
  return TrackerController(ref);
});

class TrackerController extends StateNotifier<AsyncValue<void>> {
  TrackerController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> addFoodLog({
    required String userId,
    required FoodLogDto log,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _ref.read(foodLogRepositoryProvider).addFoodLog(
            userId: userId,
            log: log,
          );
    });
  }

  Future<void> deleteFoodLog({
    required String userId,
    required String logId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _ref.read(foodLogRepositoryProvider).deleteFoodLog(
            userId: userId,
            logId: logId,
          );
    });
  }
}
