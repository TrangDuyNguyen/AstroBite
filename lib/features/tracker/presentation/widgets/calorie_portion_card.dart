import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';


/// Card showing total calories, portion weight, and daily budget percentage.
class CaloriePortionCard extends StatelessWidget {
  const CaloriePortionCard({
    super.key,
    required this.calories,
    required this.weightG,
    required this.targetCalories,
  });

  final int calories;
  final int weightG;
  final int targetCalories;

  @override
  Widget build(BuildContext context) {
    final safeTarget = targetCalories > 0 ? targetCalories : 2000;
    final dailyPct = ((calories / safeTarget) * 100).round();

    return ClayCard(
      padding: const EdgeInsets.all(AppValues.spacing16),
      borderRadius: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$calories kcal',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: AppValues.calorieLetterSpacing,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Khẩu phần ước lượng: ${weightG}g',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.spacing12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Color(0xFF0369A1), offset: Offset(0, 2.5)),
                BoxShadow(color: Color(0x300284C7), offset: Offset(0, 4), blurRadius: 8),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '$dailyPct% Ngày',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
