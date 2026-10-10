import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// High-Density KPI Insight Row displaying 3 claymorphic cards (Calories, Weight, Adherence).
class AnalyticsKpiOverviewRow extends StatelessWidget {
  const AnalyticsKpiOverviewRow({
    super.key,
    required this.avgCal,
    required this.targetCalories,
    required this.currentWeight,
    required this.onTrackDays,
    required this.totalLoggedDays,
    required this.adherenceRate,
  });

  final int avgCal;
  final int targetCalories;
  final double currentWeight;
  final int onTrackDays;
  final int totalLoggedDays;
  final int adherenceRate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            icon: '🔥',
            title: 'Calo TB',
            value: '$avgCal',
            unit: 'kcal',
            status: (avgCal <= targetCalories) ? context.l10n.kpiOnTrack : context.l10n.kpiSlightlyOver,
            statusColor: (avgCal <= targetCalories)
                ? AppColors.brandGreen
                : AppColors.tertiary,
          ),
        ),
        const SizedBox(width: AppValues.spacing12),
        Expanded(
          child: _KpiCard(
            icon: '⚖️',
            title: context.l10n.weight,
            value: currentWeight.toStringAsFixed(1),
            unit: 'kg',
            status: '-1.2 kg',
            statusColor: AppColors.secondary,
          ),
        ),
        const SizedBox(width: AppValues.spacing12),
        Expanded(
          child: _KpiCard(
            icon: '🥑',
            title: context.l10n.discipline,
            value: '$onTrackDays/$totalLoggedDays',
            unit: context.l10n.daysUnit,
            status: '$adherenceRate%',
            statusColor: adherenceRate >= 70
                ? AppColors.brandGreen
                : AppColors.tertiary,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.statusColor,
  });

  final String icon;
  final String title;
  final String value;
  final String unit;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
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
