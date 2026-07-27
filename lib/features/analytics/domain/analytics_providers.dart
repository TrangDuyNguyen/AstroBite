import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../data/repositories/analytics_repository_impl.dart';
import 'repositories/analytics_repository.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl();
});

final calorieTrendsProvider = FutureProvider.family<Map<String, int>, int>((ref, days) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return {};

  final repo = ref.watch(analyticsRepositoryProvider);
  final now = DateTime.now();
  final startDate = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: days - 1)));
  final endDate = DateFormat('yyyy-MM-dd').format(now);

  return repo.getDailyCalorieTotals(
    userId: user.uid,
    startDate: startDate,
    endDate: endDate,
  );
});
