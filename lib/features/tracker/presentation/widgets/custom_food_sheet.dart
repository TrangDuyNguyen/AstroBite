import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppValues.screenPadding,
        right: AppValues.screenPadding,
        top: AppValues.screenPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppValues.screenPadding,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thêm món ăn tùy chỉnh',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing16),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Tên món ăn *',
                  hintText: 'VD: Salad cá hồi quả bơ',
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập tên món ăn';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppValues.spacing12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Khẩu phần (g) *',
                        prefixIcon: Icon(Icons.scale),
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
                  const SizedBox(width: AppValues.spacing12),
                  Expanded(
                    child: TextFormField(
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Calo (kcal) *',
                        prefixIcon: Icon(Icons.local_fire_department, color: AppColors.primary),
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
                ],
              ),
              const SizedBox(height: AppValues.spacing12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Carbs (g)',
                        labelStyle: const TextStyle(color: AppColors.primary),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          borderRadius: BorderRadius.circular(AppValues.radius8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Đạm (g)',
                        labelStyle: const TextStyle(color: AppColors.tertiary),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.tertiary, width: 2),
                          borderRadius: BorderRadius.circular(AppValues.radius8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Béo (g)',
                        labelStyle: const TextStyle(color: AppColors.secondary),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
                          borderRadius: BorderRadius.circular(AppValues.radius8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing24),
              SizedBox(
                height: AppValues.minTouchTarget + 4,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Thêm vào bữa ăn',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
