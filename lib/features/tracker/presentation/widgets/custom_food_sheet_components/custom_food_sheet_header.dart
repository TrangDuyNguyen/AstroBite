import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Header section for CustomFoodSheet: Meal & Source badges + Title + Close button.
class CustomFoodSheetHeader extends StatelessWidget {
  final String selectedMeal;
  final VoidCallback onClose;

  const CustomFoodSheetHeader({
    super.key,
    required this.selectedMeal,
    required this.onClose,
  });

  String _mealLabel(String meal) => switch (meal) {
        'breakfast' => 'Bữa sáng',
        'lunch' => 'Bữa trưa',
        'dinner' => 'Bữa tối',
        'snack' => 'Bữa phụ',
        _ => 'Bữa ăn',
      };

  IconData _mealIcon(String meal) => switch (meal) {
        'breakfast' => Icons.wb_twilight_rounded,
        'lunch' => Icons.wb_sunny_rounded,
        'dinner' => Icons.nightlight_round,
        'snack' => Icons.cookie_outlined,
        _ => Icons.restaurant_rounded,
      };

  Color _mealColor(String meal) => switch (meal) {
        'breakfast' => const Color(0xFFF59E0B),
        'lunch' => const Color(0xFF38BDF8),
        'dinner' => const Color(0xFFA855F7),
        'snack' => const Color(0xFFEC4899),
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    final mealLabel = _mealLabel(selectedMeal);
    final mealIcon = _mealIcon(selectedMeal);
    final mealColor = _mealColor(selectedMeal);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppValues.spacing8,
                runSpacing: AppValues.spacing4,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: mealColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: mealColor.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(mealIcon, size: 13, color: mealColor),
                        const SizedBox(width: AppValues.spacing4),
                        Text(
                          mealLabel,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: mealColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outline, width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          offset: Offset(0, 1.5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      '✍ Nhập thủ công',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing8),
              Text(
                'Thêm món ăn tùy chỉnh',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        ClayIconButton(
          icon: Icons.close_rounded,
          size: 36,
          borderRadius: 12,
          iconColor: AppColors.onSurfaceVariant,
          onPressed: onClose,
        ),
      ],
    );
  }
}
