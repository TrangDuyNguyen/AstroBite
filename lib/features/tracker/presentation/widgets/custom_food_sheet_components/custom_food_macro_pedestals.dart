import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// 3-Column Macro Pedestals (Carbs, Protein, Fat) for CustomFoodSheet.
class CustomFoodMacroPedestals extends StatelessWidget {
  final TextEditingController carbsController;
  final TextEditingController proteinController;
  final TextEditingController fatController;

  const CustomFoodMacroPedestals({
    super.key,
    required this.carbsController,
    required this.proteinController,
    required this.fatController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.pie_chart_outline_rounded,
              size: 15,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppValues.spacing4),
            Expanded(
              child: Text(
                'Thành phần đa lượng (Tùy chọn)',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing8),
        Row(
          children: [
            Expanded(
              child: _MacroPedestalTile(
                controller: carbsController,
                label: 'Carbs (g)',
                color: AppColors.primary,
                bgColor: const Color(0xFFF0F9FF),
                borderColor: const Color(0xFFBAE6FD),
                bevelColor: const Color(0xFF7DD3FC),
              ),
            ),
            const SizedBox(width: AppValues.spacing8),
            Expanded(
              child: _MacroPedestalTile(
                controller: proteinController,
                label: 'Đạm (g)',
                color: AppColors.tertiary,
                bgColor: const Color(0xFFFFF8ED),
                borderColor: const Color(0xFFFFE2B3),
                bevelColor: const Color(0xFFFDBA74),
              ),
            ),
            const SizedBox(width: AppValues.spacing8),
            Expanded(
              child: _MacroPedestalTile(
                controller: fatController,
                label: 'Béo (g)',
                color: AppColors.secondary,
                bgColor: const Color(0xFFFFF1F5),
                borderColor: const Color(0xFFFECDD3),
                bevelColor: const Color(0xFFFDA4AF),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MacroPedestalTile extends StatelessWidget {
  const _MacroPedestalTile({
    required this.controller,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.bevelColor,
  });

  final TextEditingController controller;
  final String label;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final Color bevelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: bevelColor,
            offset: const Offset(0, 2.5),
            blurRadius: 0,
          ),
          const BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixText: 'g',
              suffixStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
