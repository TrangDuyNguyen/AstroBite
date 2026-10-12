import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/meal_slot.dart';

/// BottomSheet allowing users to quickly pick a preset snack or create a custom one.
class AddMealSlotBottomSheet extends StatefulWidget {
  const AddMealSlotBottomSheet({
    super.key,
    required this.onAddSlot,
  });

  final void Function(MealSlot slot) onAddSlot;

  static Future<void> show(
    BuildContext context, {
    required void Function(MealSlot slot) onAddSlot,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddMealSlotBottomSheet(onAddSlot: onAddSlot),
    );
  }

  @override
  State<AddMealSlotBottomSheet> createState() => _AddMealSlotBottomSheetState();
}

class _AddMealSlotBottomSheetState extends State<AddMealSlotBottomSheet> {
  MealSlotPreset? _selectedPreset = MealSlot.presets[1]; // Default: Bữa xế chiều
  final _customNameController = TextEditingController();
  bool _isCustom = false;

  @override
  void dispose() {
    _customNameController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_isCustom) {
      final name = _customNameController.text.trim();
      if (name.isEmpty) return;

      final newSlot = MealSlot(
        id: 'snack_custom_${DateTime.now().millisecondsSinceEpoch}',
        label: name,
        baseMealType: 'snack',
        icon: Icons.restaurant_menu_rounded,
        clayBgColor: AppColors.claySnack,
        calorieRatio: 0.10,
        isRemovable: true,
      );
      widget.onAddSlot(newSlot);
    } else if (_selectedPreset != null) {
      final preset = _selectedPreset!;
      final newSlot = MealSlot(
        id: preset.presetId,
        label: preset.label,
        baseMealType: 'snack',
        icon: preset.icon,
        clayBgColor: preset.clayBgColor,
        calorieRatio: preset.defaultRatio,
        isRemovable: true,
      );
      widget.onAddSlot(newSlot);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x201E2337),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: AppValues.spacing12,
        left: AppValues.screenPadding,
        right: AppValues.screenPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppValues.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.outline.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('➕', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'Thêm Bữa Phụ Mới',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                color: AppColors.onSurfaceVariant,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing4),
          const Text(
            'Chọn mẫu bữa phụ phù hợp với thói quen ăn uống của bạn:',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Presets Grid / List
          ...MealSlot.presets.map((preset) {
            final isSelected = !_isCustom && _selectedPreset?.presetId == preset.presetId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isCustom = false;
                    _selectedPreset = preset;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFE5F6FD)
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : const Color(0xFFEDE9E1),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Color(0x201CB0F6),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: preset.clayBgColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(preset.emoji, style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          preset.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? AppColors.primary : AppColors.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Custom Option
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isCustom = true;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _isCustom
                      ? const Color(0xFFE5F6FD)
                      : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isCustom ? AppColors.primary : const Color(0xFFEDE9E1),
                    width: _isCustom ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.claySnack,
                      ),
                      alignment: Alignment.center,
                      child: const Text('✏️', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tự đặt tên riêng cho bữa phụ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _isCustom ? FontWeight.w800 : FontWeight.w600,
                          color: _isCustom ? AppColors.primary : AppColors.onSurface,
                        ),
                      ),
                    ),
                    if (_isCustom)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),

          if (_isCustom) ...[
            const SizedBox(height: 8),
            ClayTextField(
              controller: _customNameController,
              hintText: 'Nhập tên bữa phụ (vd: Ăn nhẹ trước ngủ)...',
            ),
          ],

          const SizedBox(height: AppValues.spacing16),

          // Confirm CTA Button
          SizedBox(
            width: double.infinity,
            child: ClayButton(
              text: 'Thêm Bữa Phụ',
              onPressed: _handleConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
