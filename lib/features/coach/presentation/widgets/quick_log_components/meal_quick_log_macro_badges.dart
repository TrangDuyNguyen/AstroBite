import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Row of 3 Immutable Invariant Macro Indicators (Carbs, Protein, Fat) for [MealQuickLogCard].
class MealQuickLogMacroBadges extends StatelessWidget {
  const MealQuickLogMacroBadges({
    super.key,
    required this.carbsG,
    required this.proteinG,
    required this.fatG,
  });

  final double carbsG;
  final double proteinG;
  final double fatG;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MacroBadge(
            label: 'Carbs',
            valG: carbsG,
            color: AppColors.primary,
            bgColor: const Color(0xFFF0F9FF),
            borderColor: const Color(0xFFBAE6FD),
            bevelColor: const Color(0xFF7DD3FC),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MacroBadge(
            label: 'Protein',
            valG: proteinG,
            color: AppColors.tertiary,
            bgColor: const Color(0xFFFFF8ED),
            borderColor: const Color(0xFFFFE2B3),
            bevelColor: const Color(0xFFFDBA74),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MacroBadge(
            label: 'Fat',
            valG: fatG,
            color: AppColors.secondary,
            bgColor: const Color(0xFFFFF1F5),
            borderColor: const Color(0xFFFECDD3),
            bevelColor: const Color(0xFFFDA4AF),
          ),
        ),
      ],
    );
  }
}

class _MacroBadge extends StatelessWidget {
  const _MacroBadge({
    required this.label,
    required this.valG,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.bevelColor,
  });

  final String label;
  final double valG;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final Color bevelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: bevelColor,
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${valG.toStringAsFixed(1)}g',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
