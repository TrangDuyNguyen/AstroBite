import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Tactile portion stepper bar for adjusting grams in [MealQuickLogCard].
class MealQuickLogPortionStepper extends StatelessWidget {
  const MealQuickLogPortionStepper({
    super.key,
    required this.currentWeightG,
    required this.isLogged,
    required this.onAdjustWeight,
  });

  final int currentWeightG;
  final bool isLogged;
  final ValueChanged<int> onAdjustWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Khẩu phần:',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              _StepperBtn(
                icon: Icons.remove,
                onTap: isLogged ? null : () => onAdjustWeight(-20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '${currentWeightG}g',
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              _StepperBtn(
                icon: Icons.add,
                onTap: isLogged ? null : () => onAdjustWeight(20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  const _StepperBtn({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      shadowColor: const Color(0x20000000),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2DDD5), width: 1),
          ),
          child: Icon(icon, size: 16, color: AppColors.onSurface),
        ),
      ),
    );
  }
}
