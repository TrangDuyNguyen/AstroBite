import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/ui_kit/surfaces/clay_card.dart';
import 'package:astrobite/shared/ui_kit/buttons/clay_button.dart';
import '../../domain/health_activity.dart';
import '../health_controller.dart';

/// Energy Balance Card — tích hợp vào Analytics tab
/// Hiển thị Calo In vs Calo Out, Net Calories, và ngân sách còn lại
class EnergyBalanceCard extends ConsumerWidget {
  const EnergyBalanceCard({
    super.key,
    required this.caloriesIn,
    required this.calorieTarget,
  });

  final double caloriesIn;
  final int calorieTarget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(healthActivityControllerProvider);
    final connectionAsync = ref.watch(healthConnectionControllerProvider);

    return connectionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (connected) {
        if (!connected) return _buildConnectPrompt(context, ref);
        return activityAsync.when(
          loading: () => const ClayCard(
            borderRadius: 20,
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
          error: (_, __) => _buildErrorState(context),
          data: (activity) => _buildCard(context, activity),
        );
      },
    );
  }

  Widget _buildConnectPrompt(BuildContext context, WidgetRef ref) {
    final serviceName = Theme.of(context).platform == TargetPlatform.iOS
        ? 'Apple Health'
        : 'Health Connect';

    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.clayMint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.brandGreen.withValues(alpha: 0.3),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: const Text('🏃', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Kết nối $serviceName để xem calo đốt cháy',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          ClayButton(
            text: 'Kết nối',
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            borderRadius: 14,
            variant: ClayButtonVariant.primary,
            onPressed: () {
              ref.read(healthConnectionControllerProvider.notifier).connect();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: AppColors.tertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Không thể đọc dữ liệu Health — kiểm tra quyền truy cập',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, HealthActivity? activity) {
    final caloriesOut = activity?.activeEnergyBurned ?? 0.0;
    final netCalories = caloriesIn - caloriesOut;
    final remaining = calorieTarget - netCalories;
    final progress = calorieTarget > 0 ? (netCalories / calorieTarget).clamp(0.0, 1.0) : 0.0;

    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              'Cân bằng Năng lượng',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 16),

            // Progress arc using simple CircularProgressIndicator
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: AppColors.surfaceContainer,
                      color: AppColors.primary,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${netCalories.round()}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Net kcal',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Calo In vs Calo Out
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetric(
                  context,
                  '🔵',
                  'Calo nạp',
                  '${caloriesIn.round()} kcal',
                  AppColors.primary,
                ),
                _buildMetric(
                  context,
                  '🩷',
                  'Calo đốt',
                  '${caloriesOut.round()} kcal',
                  AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Ngân sách còn lại: ${remaining.round()} kcal',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    String icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

/// Steps & Activity Card for Analytics tab
class StepsActivityCard extends ConsumerWidget {
  const StepsActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(healthActivityControllerProvider);
    final connectionAsync = ref.watch(healthConnectionControllerProvider);

    return connectionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (connected) {
        if (!connected) return const SizedBox.shrink();
        return activityAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (activity) {
            if (activity == null) return const SizedBox.shrink();
            return _buildCard(context, activity);
          },
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, HealthActivity activity) {
    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vận Động Hôm Nay',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
            const SizedBox(height: 12),

            // Steps and distance
            Row(
              children: [
                Text(
                  '🚶 ${_formatNumber(activity.steps)} bước',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Workouts
            if (activity.workouts.isEmpty)
              Text(
                'Hãy bắt đầu di chuyển nào! 🚶',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              )
            else
              ...activity.workouts.map(
                (w) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(w.icon, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          w.name,
                          style: const TextStyle(color: AppColors.onSurface),
                        ),
                      ),
                      Text(
                        '${w.durationMinutes} phút',
                        style: const TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${w.caloriesBurned.round()} kcal',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
    );
  }

  String _formatNumber(int number) {
    if (number < 1000) return '$number';
    return '${(number / 1000).toStringAsFixed(1)}k';
  }
}
