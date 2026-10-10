import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/features/tracker/data/datasources/common_foods_dataset.dart';

import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Card showing selected food macro stats and interactive portion size adjusters.
class FoodPortionCard extends StatelessWidget {
  const FoodPortionCard({
    super.key,
    required this.item,
    required this.currentWeightG,
    required this.onWeightChanged,
  });

  final CommonFoodItem item;
  final int currentWeightG;
  final ValueChanged<int> onWeightChanged;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(AppValues.spacing16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Food Name & 3D Calorie Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF0369A1),
                      offset: Offset(0, 2.5),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x300284C7),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  '${item.calculateCalories(currentWeightG)} kcal',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),

          // Celestial Macro Pillars
          Row(
            children: [
              Expanded(
                child: _MacroStat(
                  label: context.l10n.macroCarbs,
                  value: '${item.calculateCarbs(currentWeightG)}g',
                  color: AppColors.primary,
                  bgColor: const Color(0xFFF0F9FF),
                  borderColor: const Color(0xFFBAE6FD),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroStat(
                  label: context.l10n.macroProtein,
                  value: '${item.calculateProtein(currentWeightG)}g',
                  color: AppColors.tertiary,
                  bgColor: const Color(0xFFFFF8ED),
                  borderColor: const Color(0xFFFFE2B3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroStat(
                  label: context.l10n.macroFat,
                  value: '${item.calculateFat(currentWeightG)}g',
                  color: AppColors.secondary,
                  bgColor: const Color(0xFFFFF1F5),
                  borderColor: const Color(0xFFFECDD3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),

          // Quick Weight Steppers
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                _QuickWeightChip(
                  label: '-50g',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onWeightChanged((currentWeightG - 50).clamp(50, 1000));
                  },
                ),
                const SizedBox(width: AppValues.spacing8),
                _QuickWeightChip(
                  label: '+50g',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onWeightChanged((currentWeightG + 50).clamp(50, 1000));
                  },
                ),
                const SizedBox(width: AppValues.spacing8),
                _QuickWeightChip(
                  label: context.l10n.portionBowl,
                  isSelected: currentWeightG == 150,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onWeightChanged(150);
                  },
                ),
                const SizedBox(width: AppValues.spacing8),
                _QuickWeightChip(
                  label: context.l10n.portionPlate,
                  isSelected: currentWeightG == 300,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onWeightChanged(300);
                  },
                ),
                const SizedBox(width: AppValues.spacing8),
                _QuickWeightChip(
                  label: context.l10n.portion100g,
                  isSelected: currentWeightG == 100,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onWeightChanged(100);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.spacing8),

          // Weight Slider
          Row(
            children: [
              Text(
                '50g',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFE5E0D8),
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                      elevation: 3,
                      pressedElevation: 5,
                    ),
                    overlayColor: AppColors.primary.withValues(alpha: 0.15),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                  ),
                  child: Slider(
                    value: currentWeightG.toDouble().clamp(50.0, 1000.0),
                    min: 50.0,
                    max: 1000.0,
                    divisions: 95,
                    label: '$currentWeightG g',
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      onWeightChanged(val.round());
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                ),
                child: Text(
                  '${currentWeightG}g',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroStat extends StatelessWidget {
  const _MacroStat({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 16.5,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickWeightChip extends StatelessWidget {
  const _QuickWeightChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        constraints: const BoxConstraints(minWidth: 44, minHeight: 34),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing12,
          vertical: AppValues.spacing4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2FE) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E0D8),
            width: isSelected ? 1.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0x351CB0F6) : const Color(0xFFD4CEBF),
              offset: const Offset(0, 2.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
