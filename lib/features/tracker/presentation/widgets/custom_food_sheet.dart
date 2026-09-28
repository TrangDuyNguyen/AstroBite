import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Claymorphic × Duolingo 2D/3D Custom Food Entry Bottom Sheet
class CustomFoodSheet extends StatefulWidget {
  const CustomFoodSheet({
    super.key,
    required this.selectedMeal,
    required this.onSave,
  });

  final String selectedMeal;
  final ValueChanged<FoodLogDto> onSave;

  @override
  State<CustomFoodSheet> createState() => _CustomFoodSheetState();
}

class _CustomFoodSheetState extends State<CustomFoodSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController(text: '100');
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController(text: '0');
  final _carbsController = TextEditingController(text: '0');
  final _fatController = TextEditingController(text: '0');

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    HapticFeedback.mediumImpact();
    final log = FoodLogDto(
      id: '',
      date: '',
      mealType: widget.selectedMeal,
      dishName: _nameController.text.trim(),
      estimatedWeightG: int.tryParse(_weightController.text.trim()) ?? 100,
      calories: int.tryParse(_caloriesController.text.trim()) ?? 0,
      proteinG: int.tryParse(_proteinController.text.trim()) ?? 0,
      carbsG: int.tryParse(_carbsController.text.trim()) ?? 0,
      fatG: int.tryParse(_fatController.text.trim()) ?? 0,
      source: 'manual_entry',
      confidenceScore: 1.0,
    );

    widget.onSave(log);
    Navigator.of(context).pop();
  }

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
    final mealLabel = _mealLabel(widget.selectedMeal);
    final mealIcon = _mealIcon(widget.selectedMeal);
    final mealColor = _mealColor(widget.selectedMeal);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface, // Warm milk canvas (#FAF8F5)
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AppColors.outline, width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F1E2337),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Chunky Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  top: AppValues.spacing12,
                  bottom: AppValues.spacing8,
                ),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),

            // 2. Scrollable Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppValues.screenPadding,
                  AppValues.spacing8,
                  AppValues.screenPadding,
                  AppValues.spacing24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header: Meal & Source badges + Title + Close Button
                      Row(
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainer,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.outline,
                                          width: 1.2,
                                        ),
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
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing16),

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
                          controller: _nameController,
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
                              borderSide: const BorderSide(
                                color: Color(0xFFE2DDD5),
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2.0,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.error,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.error,
                                width: 2.0,
                              ),
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
                                controller: _weightController,
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
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE2DDD5),
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.error,
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.error,
                                      width: 2.0,
                                    ),
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
                                controller: _caloriesController,
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
                                    borderSide: const BorderSide(
                                      color: Color(0xFFBAE6FD),
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.error,
                                      width: 1.2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: AppColors.error,
                                      width: 2.0,
                                    ),
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
                      const SizedBox(height: AppValues.spacing16),

                      // Macro Triad Section
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

                      // 3-Column Macro Pedestals
                      Row(
                        children: [
                          Expanded(
                            child: _MacroInputField(
                              controller: _carbsController,
                              label: 'Carbs (g)',
                              color: AppColors.primary,
                              bgColor: const Color(0xFFF0F9FF),
                              borderColor: const Color(0xFFBAE6FD),
                              bevelColor: const Color(0xFF7DD3FC),
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Expanded(
                            child: _MacroInputField(
                              controller: _proteinController,
                              label: 'Đạm (g)',
                              color: AppColors.tertiary,
                              bgColor: const Color(0xFFFFF8ED),
                              borderColor: const Color(0xFFFFE2B3),
                              bevelColor: const Color(0xFFFDBA74),
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Expanded(
                            child: _MacroInputField(
                              controller: _fatController,
                              label: 'Béo (g)',
                              color: AppColors.secondary,
                              bgColor: const Color(0xFFFFF1F5),
                              borderColor: const Color(0xFFFECDD3),
                              bevelColor: const Color(0xFFFDA4AF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing24),

                      // Duolingo 3D Submit Button
                      ClayButton(
                        text: 'Thêm vào bữa ăn',
                        icon: const Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        variant: ClayButtonVariant.primary,
                        height: 52,
                        borderRadius: 24,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tactile Macro Pedestal Input Tile
class _MacroInputField extends StatelessWidget {
  const _MacroInputField({
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
