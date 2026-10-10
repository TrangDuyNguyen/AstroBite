import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/format_utils.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/surfaces/clay_card.dart';
import '../../domain/health_activity.dart';
import '../health_controller.dart';

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
            context.l10n.todayActivityTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                context.l10n.stepsCount(FormatUtils.formatCompactNumber(activity.steps)),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (activity.workouts.isEmpty)
            Text(
              context.l10n.startMovingPrompt,
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
                      context.l10n.minutesUnit(w.durationMinutes),
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
}
