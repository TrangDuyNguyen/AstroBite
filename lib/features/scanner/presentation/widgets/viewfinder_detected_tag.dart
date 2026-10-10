import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Floating Holographic Card Tag displaying recognized dish name and calories.
class ViewfinderDetectedTag extends StatelessWidget {
  const ViewfinderDetectedTag({
    super.key,
    required this.detectedDishName,
    this.detectedCalories,
  });

  final String detectedDishName;
  final int? detectedCalories;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Vertical connector line
        Container(
          width: 1.5,
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.2),
              ],
            ),
          ),
        ),
        // Clay White Card Tag
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.spacing12,
            vertical: AppValues.spacing8,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppValues.cardRadius),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.5),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x181E2337),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
              BoxShadow(
                color: Color(0x261CB0F6),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    Flexible(
                      child: Text(
                        detectedDishName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F9D8),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.brandGreen.withValues(alpha: 0.5),
                          width: 0.8,
                        ),
                      ),
                      child: const Text(
                        'AI VERIFIED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (detectedCalories != null) ...[
                const SizedBox(width: AppValues.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$detectedCalories kcal',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
