import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/meal_plan_item.dart';

/// Nutrition cockpit card showing aggregated daily calorie & macro targets.
class MealPlanSummaryCard extends StatelessWidget {
  const MealPlanSummaryCard({
    super.key,
    required this.items,
  });

  final List<MealPlanItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
        child: ClayCard(
          padding: const EdgeInsets.all(AppValues.spacing16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.clayLunch,
                  borderRadius: BorderRadius.circular(AppValues.radius12),
                  border: Border.all(color: const Color(0xFF90D5F7), width: 1.0),
                ),
                child: const Icon(
                  Icons.event_note_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppValues.spacing12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chưa có kế hoạch',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Bấm biểu tượng dấu cộng để lên thực đơn trong ngày.',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final totalCal = items.fold(0.0, (sum, i) => sum + i.calories);
    final totalCarbs = items.fold(0.0, (sum, i) => sum + i.carbs);
    final totalProtein = items.fold(0.0, (sum, i) => sum + i.protein);
    final totalFat = items.fold(0.0, (sum, i) => sum + i.fat);
    final loggedCount = items.where((i) => i.isLogged).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
      child: ClayCard(
        padding: const EdgeInsets.all(AppValues.spacing16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.clayBreakfast,
                        borderRadius: BorderRadius.circular(AppValues.radius12),
                        border: Border.all(color: const Color(0xFFFFD54F), width: 1.0),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.tertiary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppValues.spacing12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng calo dự kiến',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${totalCal.round()} kcal',
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.spacing12,
                    vertical: AppValues.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.clayMint,
                    borderRadius: BorderRadius.circular(AppValues.spacing24),
                    border: Border.all(color: const Color(0xFFBCE99A), width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.brandGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$loggedCount/${items.length} đã ăn',
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing12),
            const Divider(color: Color(0xFFEDE9E1), height: 1),
            const SizedBox(height: AppValues.spacing12),
            Row(
              children: [
                Expanded(
                  child: _MacroPill(
                    label: 'Carbs',
                    value: '${totalCarbs.round()}g',
                    color: AppColors.carbs,
                    bgColor: AppColors.clayLunch,
                    icon: Icons.grain_rounded,
                  ),
                ),
                const SizedBox(width: AppValues.spacing8),
                Expanded(
                  child: _MacroPill(
                    label: 'Protein',
                    value: '${totalProtein.round()}g',
                    color: AppColors.protein,
                    bgColor: AppColors.clayBreakfast,
                    icon: Icons.fitness_center_rounded,
                  ),
                ),
                const SizedBox(width: AppValues.spacing8),
                Expanded(
                  child: _MacroPill(
                    label: 'Fat',
                    value: '${totalFat.round()}g',
                    color: AppColors.fat,
                    bgColor: AppColors.claySnack,
                    icon: Icons.opacity_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing8,
        vertical: AppValues.spacing8,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
