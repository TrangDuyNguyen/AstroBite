import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import '../../domain/entities/user_profile.dart';

class BmrTdeeCard extends StatelessWidget {
  const BmrTdeeCard({
    super.key,
    required this.profile,
  });

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chỉ số năng lượng (BMR & TDEE)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppValues.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricItem(
                label: 'BMR',
                value: '${profile.bmr.round()} kcal',
                subtitle: 'Năng lượng nghỉ ngơi',
                color: colorScheme.primary,
              ),
              Container(width: 1, height: 40, color: colorScheme.outline.withValues(alpha: 0.3)),
              _MetricItem(
                label: 'TDEE',
                value: '${profile.tdee.round()} kcal',
                subtitle: 'Năng lượng tiêu thụ/ngày',
                color: colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            color: color,
            letterSpacing: AppValues.calorieLetterSpacing,
          ),
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 10)),
      ],
    );
  }
}
