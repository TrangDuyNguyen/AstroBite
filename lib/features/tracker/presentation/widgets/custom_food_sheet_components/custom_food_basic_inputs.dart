import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Basic inputs for CustomFoodSheet: Dish name, Weight (g), and Calories (kcal).
class CustomFoodBasicInputs extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController weightController;
  final TextEditingController caloriesController;

  const CustomFoodBasicInputs({
    super.key,
    required this.nameController,
    required this.weightController,
    required this.caloriesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dish Name Input Card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0E1E2337),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: TextFormField(
            controller: nameController,
            autofocus: true,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              labelText: 'Tên món ăn *',
              hintText: 'VD: Salad cá hồi quả bơ',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
              prefixIcon: const Icon(
                Icons.restaurant_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppValues.spacing16,
                vertical: AppValues.spacing12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE2DDD5), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.error, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.error, width: 2.0),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Vui lòng nhập tên món ăn';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: AppValues.spacing12),

        // Weight & Calories Row
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0E1E2337),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Khẩu phần (g) *',
                    labelStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                    prefixIcon: const Icon(
                      Icons.scale_rounded,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppValues.spacing12,
                      vertical: AppValues.spacing12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2DDD5), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.error, width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.error, width: 2.0),
                    ),
                  ),
                  validator: (val) {
                    final parsed = int.tryParse(val ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Gram > 0';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(width: AppValues.spacing12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0E1E2337),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Calo (kcal) *',
                    labelStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    prefixIcon: const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppValues.spacing12,
                      vertical: AppValues.spacing12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFBAE6FD), width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.error, width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.error, width: 2.0),
                    ),
                  ),
                  validator: (val) {
                    final parsed = int.tryParse(val ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Calo >= 0';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
