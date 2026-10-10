import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../../domain/entities/scan_result.dart';

/// Interactive Topping Checklist Wrap (Sprint 19 - EPIC-GLOBAL)
/// Renders a dynamic list of chips for composite dishes (Cơm tấm, Bánh mì, Xôi mặn...).
/// Tapping a chip toggles selection and updates effective calorie/macro count in real-time.
class ToppingChecklistWrap extends StatelessWidget {
  const ToppingChecklistWrap({
    super.key,
    required this.subItems,
    required this.onToggleSubItem,
  });

  final List<SubDishItem> subItems;
  final void Function(int index, bool isSelected) onToggleSubItem;

  @override
  Widget build(BuildContext context) {
    if (subItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppValues.spacing12, bottom: AppValues.spacing8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist_rounded,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppValues.spacing4),
              Text(
                context.l10n.toppingsAndSidesHeader,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.onSurfaceVariant,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing8),
          Wrap(
            spacing: AppValues.spacing8,
            runSpacing: AppValues.spacing8,
            children: List.generate(subItems.length, (index) {
              final item = subItems[index];
              return _ToppingChip(
                key: Key('topping_chip_$index'),
                item: item,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onToggleSubItem(index, !item.isSelected);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ToppingChip extends StatelessWidget {
  const _ToppingChip({
    super.key,
    required this.item,
    required this.onTap,
  });

  final SubDishItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = item.isSelected;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.spacing12,
            vertical: AppValues.spacing4,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFFF0EFEA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.outline.withValues(alpha: 0.8)
                  : const Color(0xFFD5D1C8),
              width: 1.1,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0xFFD4CEBF),
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x061E2337),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.brandGreen : const Color(0xFFA0A4B0),
                ),
                child: Center(
                  child: Icon(
                    isSelected ? Icons.check : Icons.remove,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${item.name} (${item.calories} kcal)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.onSurface : const Color(0xFFA0A4B0),
                      decoration: isSelected ? TextDecoration.none : TextDecoration.lineThrough,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
