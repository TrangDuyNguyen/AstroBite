import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/calorie_progress_arc.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';

/// Celestial Energy Ring representing the biological universe's energy balance.
class CosmicEnergyRing extends StatelessWidget {
  const CosmicEnergyRing({
    super.key,
    required this.summary,
    this.size = 200,
  });

  final DailySummary summary;
  final double size;

  bool get isPerfectDay {
    if (summary.targetCalories <= 0 || summary.totalCalories == 0) return false;
    final ratio = summary.totalCalories / summary.targetCalories;
    return ratio >= 0.85 && ratio <= 1.10;
  }

  bool get isOverBudget => summary.totalCalories > summary.targetCalories;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Celestial Glow Halo
            Container(
              width: size + 24,
              height: size + 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isPerfectDay
                        ? AppColors.tertiary.withValues(alpha: 0.20)
                        : AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 36,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),

            // Base Arc Painter
            CalorieProgressArc(
              consumed: summary.totalCalories,
              target: summary.targetCalories,
              size: size,
              strokeWidth: 12,
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing12),

        // Cosmic Energy Status Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPerfectDay
                ? AppColors.tertiary.withValues(alpha: 0.15)
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppValues.radius8),
            border: Border.all(
              color: isPerfectDay
                  ? AppColors.tertiary.withValues(alpha: 0.5)
                  : AppColors.outline.withValues(alpha: 0.2),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isPerfectDay
                    ? '🪐'
                    : isOverBudget
                        ? '⚡'
                        : '🌌',
                style: const TextStyle(fontSize: 11),
              ),
              const SizedBox(width: 4),
              Text(
                isPerfectDay
                    ? 'NĂNG LƯỢNG CÂN BẰNG HOÀN HẢO'
                    : isOverBudget
                        ? 'VƯỢT NGÂN SÁCH NĂNG LƯỢNG'
                        : summary.totalCalories == 0
                            ? 'THẮP SÁNG TIỂU VŨ TRỤ HÔM NAY'
                            : 'TIỂU VŨ TRỤ ĐANG HẤP THU',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isPerfectDay
                      ? AppColors.tertiary
                      : isOverBudget
                          ? AppColors.secondary
                          : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
