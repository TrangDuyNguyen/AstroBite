import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../controllers/recipe_builder_controller.dart';

/// Modal bottom sheet allowing users to enter ingredient details and macros.
class RecipeAddIngredientSheet extends ConsumerStatefulWidget {
  const RecipeAddIngredientSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RecipeAddIngredientSheet(),
    );
  }

  @override
  ConsumerState<RecipeAddIngredientSheet> createState() =>
      _RecipeAddIngredientSheetState();
}

class _RecipeAddIngredientSheetState
    extends ConsumerState<RecipeAddIngredientSheet> {
  final _nameCtrl = TextEditingController();
  final _gramsCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _gramsCtrl.dispose();
    _calCtrl.dispose();
    _carbsCtrl.dispose();
    _proteinCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ClaySheet(
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.82,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Thêm Nguyên Liệu',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: AppValues.spacing16),
                  _Field(ctrl: _nameCtrl, hint: 'VD: Ức gà phi lê', label: 'Tên nguyên liệu'),
                  const SizedBox(height: AppValues.spacing12),
                  Row(
                    children: [
                      Expanded(child: _NumberField(ctrl: _gramsCtrl, label: 'Định lượng (g)')),
                      const SizedBox(width: AppValues.spacing12),
                      Expanded(child: _NumberField(ctrl: _calCtrl, label: 'Năng lượng (kcal)')),
                    ],
                  ),
                  const SizedBox(height: AppValues.spacing12),
                  Row(
                    children: [
                      Expanded(
                        child: _NumberField(
                          ctrl: _carbsCtrl,
                          label: 'Carbs (g)',
                          color: AppColors.carbs,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _NumberField(
                          ctrl: _proteinCtrl,
                          label: 'Protein (g)',
                          color: AppColors.protein,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _NumberField(
                          ctrl: _fatCtrl,
                          label: 'Fat (g)',
                          color: AppColors.fat,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppValues.spacing24),
                  ClayButton(
                    text: 'Thêm Nguyên Liệu',
                    icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    onPressed: _submit,
                  ),
                  const SizedBox(height: AppValues.spacing16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ingredient = RecipeIngredient(
      foodId: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      amountGrams: double.tryParse(_gramsCtrl.text) ?? 0,
      calories: double.tryParse(_calCtrl.text) ?? 0,
      carbs: double.tryParse(_carbsCtrl.text) ?? 0,
      protein: double.tryParse(_proteinCtrl.text) ?? 0,
      fat: double.tryParse(_fatCtrl.text) ?? 0,
    );

    ref.read(recipeBuilderProvider.notifier).addIngredient(ingredient);
    Navigator.of(context).pop();
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.ctrl, required this.hint, required this.label});

  final TextEditingController ctrl;
  final String hint;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E5DF), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E5DF), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Bắt buộc' : null,
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.ctrl, required this.label, this.color});

  final TextEditingController ctrl;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: TextStyle(
        color: color ?? AppColors.onSurface,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: color ?? AppColors.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      validator: (v) {
        if (v == null || v.isEmpty) return 'Bắt buộc';
        if ((double.tryParse(v) ?? -1) < 0) return '≥0';
        return null;
      },
    );
  }
}
