import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Section displaying individual dish components and nutritional breakdown for multi-dish logs.
class DishesBreakdownSection extends StatelessWidget {
  const DishesBreakdownSection({
    super.key,
    required this.dishes,
  });

  final List<Map<String, dynamic>> dishes;

  @override
  Widget build(BuildContext context) {
    if (dishes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppValues.spacing20),
        Row(
          children: [
            const Icon(Icons.restaurant_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: AppValues.spacing4),
            Text(
              'Thành phần trong bữa (${dishes.length} món)',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing8),
        ...dishes.map((dish) {
          final name = dish['dish_name'] as String? ?? 'Món ăn';
          final weight = dish['estimated_weight_g'] as num? ?? 0;
          final cal = dish['calories'] as num? ?? 0;
          final c = dish['carbs_g'] as num? ?? 0;
          final p = dish['protein_g'] as num? ?? 0;
          final f = dish['fat_g'] as num? ?? 0;

          return Container(
            margin: const EdgeInsets.only(bottom: AppValues.spacing8),
            padding: const EdgeInsets.symmetric(horizontal: AppValues.spacing12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E0D8), width: 1.2),
              boxShadow: const [
                BoxShadow(color: Color(0xFFD4CEBF), offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Khối lượng: ${weight}g • C: ${c}g • P: ${p}g • F: ${f}g',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
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
                    '$cal cal',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
