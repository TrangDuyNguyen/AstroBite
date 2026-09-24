import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';

import '../data/repositories/food_log_repository_impl.dart';
import 'daily_summary.dart';
import 'entities/food_log.dart';
import 'repositories/food_log_repository.dart';

final foodLogRepositoryProvider = Provider<FoodLogRepository>((ref) {
  return FoodLogRepositoryImpl();
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final todayDateProvider = Provider<String>((ref) {
  final selected = ref.watch(selectedDateProvider);
  return DateFormat('yyyy-MM-dd').format(selected);
});

final dailyLogsStreamProvider = StreamProvider.autoDispose<List<FoodLog>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  final date = ref.watch(todayDateProvider);
  final repo = ref.watch(foodLogRepositoryProvider);

  return repo.watchDailyLogs(userId: user.uid, date: date).map((dtos) => dtos
      .map((dto) => FoodLog(
            id: dto.id,
            date: dto.date,
            mealType: dto.mealType,
            dishName: dto.dishName,
            estimatedWeightG: dto.estimatedWeightG,
            calories: dto.calories,
            proteinG: dto.proteinG,
            carbsG: dto.carbsG,
            fatG: dto.fatG,
            source: dto.source,
            confidenceScore: dto.confidenceScore,
            imageUrl: dto.imageUrl,
            sodiumMg: dto.sodiumMg ?? 0.0,
            fiberG: dto.fiberG ?? 0.0,
            sugarG: dto.sugarG ?? 0.0,
            syncStatus: dto.syncStatus ?? 'synced',
            dishes: dto.dishes,
          ))
      .toList());
});

final todaySummaryProvider = Provider.autoDispose<DailySummary>((ref) {
  final logs = ref.watch(dailyLogsStreamProvider).value ?? [];
  final date = ref.watch(todayDateProvider);
  final profile = ref.watch(userProfileStreamProvider).value;
  final targetCalories = profile?.dailyTargetCalories ?? 2000;
  return DailySummary.fromLogs(
    date: date,
    logs: logs,
    targetCalories: targetCalories,
  );
});

final isOfflineProvider = StateProvider<bool>((ref) => false);

