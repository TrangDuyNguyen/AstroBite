import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Tactile Macro Pill for display in FoodDetailSheet and nutrition dialogs.
class MacroPill extends StatelessWidget {
  const MacroPill({
    super.key,
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.bevelColor,
  });

  final String label;
  final String value;
  final String percentage;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final Color bevelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing8,
        vertical: AppValues.spacing8,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(color: bevelColor, offset: const Offset(0, 2.5), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.4), offset: const Offset(0, 1), blurRadius: 2),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            percentage,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
