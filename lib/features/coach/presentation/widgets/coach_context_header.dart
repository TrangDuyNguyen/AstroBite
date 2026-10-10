import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';

/// Context Header Strip displaying real-time calories, 3 macros, and sodium warning
class CoachContextHeader extends StatelessWidget {
  const CoachContextHeader({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final remainingCalories = summary.targetCalories - summary.totalCalories;
    final isSodiumWarning = summary.totalSodiumMg >= 1500;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E0D8),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD4CEBF),
            offset: Offset(0, 2),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng quan dinh dưỡng hôm nay',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Còn lại: ${remainingCalories.clamp(0, 9999)} kcal',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: remainingCalories >= 0 ? AppColors.primary : AppColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 3 Compact Macro Progress Bars
          Row(
            children: [
              Expanded(
                child: _buildMacroMiniBar(
                  label: 'Carbs',
                  current: summary.totalCarbsG,
                  target: summary.targetCarbsG,
                  color: AppColors.carbs,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroMiniBar(
                  label: 'Protein',
                  current: summary.totalProteinG,
                  target: summary.targetProteinG,
                  color: AppColors.protein,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroMiniBar(
                  label: 'Fat',
                  current: summary.totalFatG,
                  target: summary.targetFatG,
                  color: AppColors.fat,
                ),
              ),
            ],
          ),
          if (isSodiumWarning) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFE2B3), width: 1.2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Cảnh báo Natri: ${summary.totalSodiumMg.toInt()}mg / ${summary.targetSodiumMg.toInt()}mg (sắp chạm ngưỡng khuyến nghị)',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMacroMiniBar({
    required String label,
    required int current,
    required int target,
    required Color color,
  }) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$current/${target}g',
              style: GoogleFonts.inter(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: const Color(0xFFF1EFEA),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
