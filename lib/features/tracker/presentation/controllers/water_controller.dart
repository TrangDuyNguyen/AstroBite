import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/tracker_providers.dart';

final waterControllerProvider =
    StateNotifierProvider.autoDispose<WaterController, AsyncValue<WaterDayLog?>>((ref) {
  return WaterController(ref);
});

class WaterController extends StateNotifier<AsyncValue<WaterDayLog?>> {
  WaterController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  String _resolveUserId() {
    try {
      final user = _ref.read(authStateProvider).value;
      return user?.uid ?? 'guest_user';
    } catch (_) {
      return 'guest_user';
    }
  }

  Future<void> addWater(int amountMl, {String? note}) async {
    final userId = _resolveUserId();
    final date = _ref.read(todayDateProvider);
    final repo = _ref.read(waterRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await repo.logWater(
        userId: userId,
        date: date,
        amountMl: amountMl,
        note: note,
      );
    });
  }

  Future<void> setDailyTarget(int targetMl) async {
    final userId = _resolveUserId();
    final date = _ref.read(todayDateProvider);
    final repo = _ref.read(waterRepositoryProvider);

    await repo.updateDailyTarget(
      userId: userId,
      date: date,
      targetMl: targetMl,
    );
  }
}
