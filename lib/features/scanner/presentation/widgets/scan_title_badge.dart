import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../../domain/entities/scan_result.dart';

/// Top Header row displaying food name, multi-dish badge, and AI confidence badge.
class ScanTitleBadge extends StatelessWidget {
  const ScanTitleBadge({
    super.key,
    required this.dishes,
    required this.scaled,
  });

  final List<DishItem> dishes;
  final ScanResult scaled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (dishes.length > 1) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.spacing8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppValues.radius8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '🍱 Mâm cơm (${dishes.length} món)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: AppValues.spacing4),
              ],
              Text(
                dishes.length > 2
                    ? '${dishes.first.dishName} & ${dishes.length - 1} món khác'
                    : scaled.primaryDishName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
              ),
              if (dishes.length > 1) ...[
                const SizedBox(height: 2),
                Text(
                  dishes.map((d) => d.dishName).join(' • '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppValues.spacing8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.spacing12,
            vertical: AppValues.spacing4,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppValues.spacing16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 16, color: AppColors.primary),
              const SizedBox(width: AppValues.spacing4),
              Text(
                '${(scaled.primaryConfidenceScore * 100).toInt()}% tin cậy',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
