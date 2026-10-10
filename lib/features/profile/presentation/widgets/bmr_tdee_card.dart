import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/surfaces/clay_card.dart';
import '../../domain/entities/user_profile.dart';

/// Claymorphic BMR & TDEE Indicator Card.
class BmrTdeeCard extends StatelessWidget {
  const BmrTdeeCard({
    super.key,
    required this.profile,
  });

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.energyMetricsTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.clayLunch,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '⚡ ${l10n.standardized}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: '🔥',
                  label: 'BMR',
                  value: '${profile.bmr.round()}',
                  unit: 'kcal',
                  subtitle: l10n.bmrSubtitle,
                  accentColor: AppColors.primary,
                  bgColor: AppColors.clayLunch,
                ),
              ),
              const SizedBox(width: AppValues.spacing12),
              Expanded(
                child: _buildMetricTile(
                  icon: '⚡',
                  label: 'TDEE',
                  value: '${profile.tdee.round()}',
                  unit: 'kcal',
                  subtitle: l10n.tdeeSubtitle,
                  accentColor: AppColors.tertiary,
                  bgColor: AppColors.clayBreakfast,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E5DF)),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Để duy trì cân nặng: nạp ~${profile.tdee.round()} kcal. Để giảm mỡ: nạp ~${(profile.tdee - 400).round()} kcal.',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String icon,
    required String label,
    required String value,
    required String unit,
    required String subtitle,
    required Color accentColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
              Text(icon, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$value $unit',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: AppValues.calorieLetterSpacing,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
