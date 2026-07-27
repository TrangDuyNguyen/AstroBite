import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';

import '../data/food_log_repository.dart';
import 'daily_summary.dart';
import 'entities/food_log.dart';

final foodLogRepositoryProvider = Provider<FoodLogRepository>((ref) {
  return FoodLogRepository();
});

final todayDateProvider = Provider<String>((ref) {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
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
          ))
      .toList());
});

final todaySummaryProvider = Provider.autoDispose<DailySummary>((ref) {
  final logs = ref.watch(dailyLogsStreamProvider).value ?? [];
  final date = ref.watch(todayDateProvider);
  return DailySummary.fromLogs(date: date, logs: logs);
});
