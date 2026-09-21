import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../data/streak_repository.dart';
import '../../domain/streak_record.dart';

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  return StreakRepository();
});

final streakNotifierProvider =
    AsyncNotifierProvider<StreakNotifier, StreakRecord>(() {
  return StreakNotifier();
});

class StreakNotifier extends AsyncNotifier<StreakRecord> {
  StreakRepository get _repo => ref.read(streakRepositoryProvider);

  @override
  Future<StreakRecord> build() async {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return StreakRecord.initial();
    }
    return _repo.getStreak(user.uid);
  }

  /// Records a meal event on [date] (defaults to DateTime.now()) and updates the streak.
  Future<StreakRecord> recordMeal({DateTime? date}) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    final current = state.valueOrNull ?? StreakRecord.initial();
    final targetDate = date ?? DateTime.now();
    final dateStr = StreakRecord.formatDate(targetDate);

    final updated = current.recordMeal(dateStr);
    state = AsyncData(updated);

    if (user != null) {
      await _repo.saveStreak(user.uid, updated);
    }
    return updated;
  }

  /// Refreshes streak record from repository.
  Future<void> refresh() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncData(StreakRecord.initial());
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.getStreak(user.uid));
  }
}
