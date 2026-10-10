import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'custom_food_sheet_components/custom_food_basic_inputs.dart';
import 'custom_food_sheet_components/custom_food_macro_pedestals.dart';
import 'custom_food_sheet_components/custom_food_sheet_header.dart';

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

  @override
  Widget build(BuildContext context) {
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
            // Chunky Drag Handle
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
            // Scrollable Body
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
                      CustomFoodSheetHeader(
                        selectedMeal: widget.selectedMeal,
                        onClose: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: AppValues.spacing16),
                      CustomFoodBasicInputs(
                        nameController: _nameController,
                        weightController: _weightController,
                        caloriesController: _caloriesController,
                      ),
                      const SizedBox(height: AppValues.spacing16),
                      CustomFoodMacroPedestals(
                        carbsController: _carbsController,
                        proteinController: _proteinController,
                        fatController: _fatController,
                      ),
                      const SizedBox(height: AppValues.spacing24),
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
