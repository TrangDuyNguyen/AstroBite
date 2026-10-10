import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/recipe_builder_controller.dart';

/// Claymorphic summary card displaying total calories and carbs/protein/fat breakdown.
class RecipeMacroSummaryCard extends StatelessWidget {
  const RecipeMacroSummaryCard({
    super.key,
    required this.state,
  });

  final RecipeBuilderState state;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      elevation: 4.0,
      borderRadius: 22.0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng Dinh Dưỡng Công Thức',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${state.totalCalories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2D6),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFFCD34D),
                      offset: Offset(0, 1.8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFFF9600),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEDE8DD)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MacroPill(
                  label: 'Carbs',
                  value: state.totalCarbs,
                  bg: const Color(0xFFE5F6FD),
                  border: const Color(0xFF90D5F7),
                  bevel: const Color(0xFFBCE3F7),
                  color: AppColors.carbs,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroPill(
                  label: 'Protein',
                  value: state.totalProtein,
                  bg: const Color(0xFFFFF2D6),
                  border: const Color(0xFFFDE68A),
                  bevel: const Color(0xFFFCD34D),
                  color: AppColors.protein,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroPill(
                  label: 'Fat',
                  value: state.totalFat,
                  bg: const Color(0xFFFFE8EE),
                  border: const Color(0xFFFAC4D2),
                  bevel: const Color(0xFFF7A8BE),
                  color: AppColors.fat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.value,
    required this.bg,
    required this.border,
    required this.bevel,
    required this.color,
  });

  final String label;
  final double value;
  final Color bg;
  final Color border;
  final Color bevel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: bevel,
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${value.toStringAsFixed(1)}g',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
