import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/meal_plan_item.dart';

class MealPlanCustomEntryForm extends StatefulWidget {
  const MealPlanCustomEntryForm({
    super.key,
    required this.userId,
    required this.date,
    required this.mealType,
    required this.mealLabel,
    required this.onSubmit,
  });

  final String userId;
  final String date;
  final String mealType;
  final String mealLabel;
  final ValueChanged<MealPlanItem> onSubmit;

  @override
  State<MealPlanCustomEntryForm> createState() => _MealPlanCustomEntryFormState();
}

class _MealPlanCustomEntryFormState extends State<MealPlanCustomEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _calCtrl.dispose();
    _carbsCtrl.dispose();
    _proteinCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final item = MealPlanItem(
      id: '',
      userId: widget.userId,
      date: widget.date,
      mealType: widget.mealType,
      foodName: _nameCtrl.text.trim(),
      calories: double.tryParse(_calCtrl.text) ?? 0,
      carbs: double.tryParse(_carbsCtrl.text) ?? 0,
      protein: double.tryParse(_proteinCtrl.text) ?? 0,
      fat: double.tryParse(_fatCtrl.text) ?? 0,
    );

    widget.onSubmit(item);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InputField(
            ctrl: _nameCtrl,
            hint: 'VD: Bánh mì ốp la',
            label: 'Tên món ăn',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên món' : null,
          ),
          const SizedBox(height: AppValues.spacing12),
          _InputField(
            ctrl: _calCtrl,
            hint: 'VD: 350',
            label: 'Năng lượng (kcal)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập calo' : null,
          ),
          const SizedBox(height: AppValues.spacing12),
          Row(
            children: [
              Expanded(
                child: _InputField(
                  ctrl: _carbsCtrl,
                  hint: '0',
                  label: 'Carbs (g)',
                  color: AppColors.carbs,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Expanded(
                child: _InputField(
                  ctrl: _proteinCtrl,
                  hint: '0',
                  label: 'Protein (g)',
                  color: AppColors.protein,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Expanded(
                child: _InputField(
                  ctrl: _fatCtrl,
                  hint: '0',
                  label: 'Fat (g)',
                  color: AppColors.fat,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing20),
          ClayButton(
            text: 'Thêm Vào Kế Hoạch',
            icon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            onPressed: _submit,
          ),
          const SizedBox(height: AppValues.spacing12),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.ctrl,
    required this.hint,
    required this.label,
    this.color,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController ctrl;
  final String hint;
  final String label;
  final Color? color;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: color ?? AppColors.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: color ?? AppColors.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: color?.withValues(alpha: 0.5) ?? const Color(0xFFE8E5DF),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: color?.withValues(alpha: 0.5) ?? const Color(0xFFE8E5DF),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color ?? AppColors.primary, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}

