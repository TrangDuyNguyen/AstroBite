import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/food_icon_utils.dart';
import 'package:astrobite/features/tracker/data/datasources/common_foods_dataset.dart';

/// Tactile Food List Item Tile for manual search and quick selection.
class FoodListItemTile extends StatelessWidget {

  const FoodListItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final CommonFoodItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: AppValues.spacing8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFAFDFF) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E0D8),
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0x351CB0F6) : const Color(0xFFD4CEBF),
              offset: const Offset(0, 2.5),
              blurRadius: 0,
            ),
            BoxShadow(
              color: isSelected ? const Color(0x181CB0F6) : const Color(0x081E2337),
              offset: const Offset(0, 3),
              blurRadius: isSelected ? 8 : 4,
            ),
          ],
        ),
        child: Row(
          children: [
            // Food Avatar Circle
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFFE0F2FE) : const Color(0xFFF4F1EA),
                border: Border.all(
                  color: isSelected ? const Color(0xFFBAE6FD) : const Color(0xFFE5E0D8),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                FoodIconUtils.getFoodIcon(item.name),
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,

                size: 22,
              ),
            ),
            const SizedBox(width: AppValues.spacing12),

            // Food Title & Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.baseWeightG}g • ${item.baseCalories} kcal (P:${item.baseProteinG}g C:${item.baseCarbsG}g F:${item.baseFatG}g)',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Status Action
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
