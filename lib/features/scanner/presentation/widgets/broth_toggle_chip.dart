import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Interactive Claymorphic Broth Toggle Chip (Sprint 19 - EPIC-GLOBAL)
/// Allows 1-tap toggling between [Ăn cả nước] and [Chỉ ăn cái]
/// Automatically deducts broth calories and sodium from dish calculations.
class BrothToggleChip extends StatelessWidget {
  const BrothToggleChip({
    super.key,
    required this.hasBroth,
    required this.includeBroth,
    required this.brothCalories,
    this.brothSodiumMg = 0.0,
    required this.onToggle,
  });

  final bool hasBroth;
  final bool includeBroth;
  final int brothCalories;
  final double brothSodiumMg;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    if (!hasBroth) return const SizedBox.shrink();

    final isIncluded = includeBroth;
    final backgroundColor = isIncluded ? AppColors.clayLunch : AppColors.clayMint;
    final borderColor = isIncluded ? AppColors.primary : AppColors.brandGreen;
    final accentColor = isIncluded ? AppColors.primary : AppColors.brandGreen;
    final emoji = isIncluded ? '🍜' : '🥢';
    final title = isIncluded
        ? 'Ăn cả nước (+$brothCalories kcal)'
        : 'Chỉ ăn cái (-$brothCalories kcal)';
    final subtitle = isIncluded
        ? (brothSodiumMg > 0
            ? 'Bao gồm ~${brothSodiumMg.toInt()}mg Muối nước lèo'
            : 'Tính trọn vẹn nước dùng & gia vị ninh')
        : 'Tiết kiệm $brothCalories kcal & giảm mỡ béo ✨';

    return Padding(
      padding: const EdgeInsets.only(top: AppValues.spacing8, bottom: AppValues.spacing8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const Key('broth_toggle_chip_inkwell'),
          borderRadius: BorderRadius.circular(AppValues.cardRadiusLarge),
          onTap: () {
            HapticFeedback.lightImpact();
            onToggle(!isIncluded);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.spacing12,
              vertical: AppValues.spacing8,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppValues.cardRadiusLarge),
              border: Border.all(
                color: borderColor,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: AppValues.spacing8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppValues.spacing4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  child: Icon(
                    isIncluded ? Icons.check : Icons.swap_horiz,
                    size: 14,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
