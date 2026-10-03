import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import '../../domain/analytics_providers.dart';
import '../widgets/calorie_trend_chart.dart';
import '../widgets/weight_trend_chart.dart';
import '../../../health/presentation/widgets/health_cards.dart';
import 'package:astrobite/core/services/share_image_service.dart';

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
        title: AppStrings.analytics,
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
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEE8),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFDDD8CE),
                    offset: Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: 7,
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('7 ngày'),
                    ),
                  ),
                  ButtonSegment(
                    value: 30,
                    label: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('30 ngày'),
                    ),
                  ),
                ],
                selected: {_days},
                onSelectionChanged: (set) => setState(() => _days = set.first),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary;
                    }
                    return Colors.transparent;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return AppColors.onSurfaceVariant;
                  }),
                  textStyle: WidgetStateProperty.resolveWith((states) {
                    return TextStyle(
                      fontSize: 14,
                      fontWeight: states.contains(WidgetState.selected)
                          ? FontWeight.w700
                          : FontWeight.w600,
                    );
                  }),
                  elevation: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.selected) ? 2.0 : 0.0;
                  }),
                  side: const WidgetStatePropertyAll(BorderSide.none),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppValues.spacing16),

            // 2. High-Density KPI Insight Row
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    icon: '🔥',
                    title: 'Calo TB',
                    value: '$avgCal',
                    unit: 'kcal',
                    status: (avgCal <= targetCalories) ? 'Đạt chuẩn' : 'Vượt nhẹ',
                    statusColor: (avgCal <= targetCalories)
                        ? AppColors.brandGreen
                        : AppColors.tertiary,
                  ),
                ),
                const SizedBox(width: AppValues.spacing12),
                Expanded(
                  child: _buildKpiCard(
                    icon: '⚖️',
                    title: 'Cân nặng',
                    value: currentWeight.toStringAsFixed(1),
                    unit: 'kg',
                    status: '-1.2 kg',
                    statusColor: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: AppValues.spacing12),
                Expanded(
                  child: _buildKpiCard(
                    icon: '🥑',
                    title: 'Kỷ luật',
                    value: '$onTrackDays/$totalLoggedDays',
                    unit: 'ngày',
                    status: '$adherenceRate%',
                    statusColor: adherenceRate >= 70
                        ? AppColors.brandGreen
                        : AppColors.tertiary,
                  ),
                ),
              ],
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
                              'Xu hướng Calo nạp vào ($_days ngày)',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Mục tiêu hằng ngày: $targetCalories kcal',
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
                          'Lỗi: $e',
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
                              'Xu hướng Cân nặng (kg)',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondary,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Mục tiêu: ${targetWeight.toStringAsFixed(1)} kg • Giảm đều đặn',
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phân bổ Dinh dưỡng Trung bình',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tỷ lệ năng lượng hấp thu từ các nhóm chất',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.clayMint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Cân đối',
                          style: TextStyle(
                            color: AppColors.brandGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppValues.spacing16),
                  ChunkyMacroBar(
                    label: AppStrings.carbs,
                    currentG: 215,
                    targetG: 250,
                    color: AppColors.carbs,
                  ),
                  const SizedBox(height: AppValues.spacing12),
                  ChunkyMacroBar(
                    label: AppStrings.protein,
                    currentG: 120,
                    targetG: 140,
                    color: AppColors.protein,
                  ),
                  const SizedBox(height: AppValues.spacing12),
                  ChunkyMacroBar(
                    label: AppStrings.fat,
                    currentG: 50,
                    targetG: 65,
                    color: AppColors.fat,
                  ),
                ],
              ),
            ),

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

  Widget _buildKpiCard({
    required String icon,
    required String title,
    required String value,
    required String unit,
    required String status,
    required Color statusColor,
  }) {
    return ClayCard(
      borderRadius: 18,
      elevation: 3,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
