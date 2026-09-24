import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import '../../domain/analytics_providers.dart';
import '../widgets/calorie_trend_chart.dart';
import '../widgets/weight_trend_chart.dart';
import '../../../health/presentation/widgets/health_cards.dart';

@RoutePage()
class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final trendsAsync = ref.watch(calorieTrendsProvider(_days));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.analytics)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7 ngày')),
                ButtonSegment(value: 30, label: Text('30 ngày')),
              ],
              selected: {_days},
              onSelectionChanged: (set) => setState(() => _days = set.first),
            ),
            const SizedBox(height: AppValues.spacing24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xu hướng Calo nạp vào ($_days ngày)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppValues.spacing16),
                  trendsAsync.when(
                    data: (totals) => CalorieTrendChart(dailyTotals: totals),
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, s) => SizedBox(
                      height: 200,
                      child: Center(child: Text('Lỗi: $e')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.spacing24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xu hướng Cân nặng (kg)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: AppValues.spacing16),
                  const WeightTrendChart(),
                ],
              ),
            ),
            const SizedBox(height: AppValues.spacing24),
            const EnergyBalanceCard(
              caloriesIn: 1850,
              calorieTarget: 2000,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
