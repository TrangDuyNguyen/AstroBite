import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/core/services/share_image_service.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/analytics_providers.dart';
import '../widgets/analytics_components/analytics_kpi_overview_row.dart';
import '../widgets/analytics_components/analytics_macro_breakdown_card.dart';
import '../widgets/analytics_components/analytics_period_selector.dart';
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
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final trendsAsync = ref.watch(calorieTrendsProvider(_days));
    final profile = ref.watch(userProfileStreamProvider).valueOrNull;
    final targetCalories = profile?.dailyTargetCalories ?? 2000;
    final currentWeight = profile?.weightKg ?? 65.0;
    final targetWeight = profile?.targetWeightKg ?? 64.0;

    // Derive overview metrics from trends
    final totals = trendsAsync.valueOrNull ?? {};
    final totalValues = totals.values.toList();
    final avgCal = totalValues.isNotEmpty
        ? (totalValues.reduce((a, b) => a + b) / totalValues.length).round()
        : 1850;

    final onTrackDays = totalValues.isNotEmpty
        ? totalValues.where((cal) => cal <= targetCalories + 150 && cal >= 500).length
        : (_days == 7 ? 6 : 24);
    final totalLoggedDays = totalValues.isNotEmpty ? totalValues.length : _days;
    final adherenceRate = ((onTrackDays / totalLoggedDays) * 100).round();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ClayAppBar(
        title: context.l10n.analytics,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: AppColors.primary),
            onPressed: () => ShareImageService.captureAndShare(_globalKey),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            color: AppColors.surface,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
              children: [
                const SizedBox(height: AppValues.spacing8),

                // 1. Tactile Clay Period Selector
                AnalyticsPeriodSelector(
                  selectedDays: _days,
                  onPeriodChanged: (days) => setState(() => _days = days),
                ),

                const SizedBox(height: AppValues.spacing16),

                // 2. High-Density KPI Insight Row
                AnalyticsKpiOverviewRow(
                  avgCal: avgCal,
                  targetCalories: targetCalories,
                  currentWeight: currentWeight,
                  onTrackDays: onTrackDays,
                  totalLoggedDays: totalLoggedDays,
                  adherenceRate: adherenceRate,
                ),

                const SizedBox(height: AppValues.spacing20),

                // 3. Calorie Trend Line Chart Card
                ClayCard(
                  borderRadius: 20,
                  elevation: 4,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.calorieTrendDays(_days),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  context.l10n.dailyTargetKcal(targetCalories),
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.clayLunch,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'TB: $avgCal kcal',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing16),
                      trendsAsync.when(
                        data: (totals) => CalorieTrendChart(
                          dailyTotals: totals,
                          targetCalories: targetCalories,
                          days: _days,
                        ),
                        loading: () => const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        ),
                        error: (e, s) => SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              context.l10n.errorWithDetails(e.toString()),
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppValues.spacing20),

                // 4. Weight Trend Line Chart Card
                ClayCard(
                  borderRadius: 20,
                  elevation: 4,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.weightTrendTitle,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.secondary,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  context.l10n.weightGoalSubtitle(targetWeight.toStringAsFixed(1)),
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.claySnack,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              '📉 -1.2 kg',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing16),
                      WeightTrendChart(
                        days: _days,
                        targetWeight: targetWeight,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppValues.spacing20),

                // 5. Average Macro Distribution Breakdown
                const AnalyticsMacroBreakdownCard(),

                const SizedBox(height: AppValues.spacing20),

                // 6. Energy Balance & Health Integration Card
                EnergyBalanceCard(
                  caloriesIn: avgCal.toDouble(),
                  calorieTarget: targetCalories,
                ),

                // Generous spacing to clear floating dock navigation bar
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
