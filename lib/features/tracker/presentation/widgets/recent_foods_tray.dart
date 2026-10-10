import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/tracker/data/datasources/common_foods_dataset.dart';

/// Horizontal tray showing recently logged foods for 1-tap selection.
class RecentFoodsTray extends StatelessWidget {
  const RecentFoodsTray({
    super.key,
    required this.recentFoods,
    required this.selectedItem,
    required this.onSelectFood,
  });

  final List<CommonFoodItem> recentFoods;
  final CommonFoodItem? selectedItem;
  final ValueChanged<CommonFoodItem> onSelectFood;

  @override
  Widget build(BuildContext context) {
    if (recentFoods.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: AppValues.spacing4),
            Text(
              'Món gần đây:',
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: recentFoods.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppValues.spacing8),
            itemBuilder: (context, index) {
              final item = recentFoods[index];
              final isSelected = selectedItem?.name == item.name;
              return _RecentFoodChip(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelectFood(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentFoodChip extends StatelessWidget {
  const _RecentFoodChip({
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
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE5E0D8),
              width: 1.5,
              ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? const Color(0xFF0369A1) : const Color(0xFFD4CEBF),
                offset: const Offset(0, 2.5),
                blurRadius: 0,
              ),
              if (isSelected)
                const BoxShadow(
                  color: Color(0x301CB0F6),
                  offset: Offset(0, 3),
                  blurRadius: 8,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🍽️', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 5),
              Text(
                '${item.name} (${item.baseCalories}k)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.onSurface,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
