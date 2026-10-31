import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/meal_plan_item.dart';
import '../../domain/entities/recipe.dart';
import '../controllers/meal_plan_controller.dart';
import '../controllers/recipe_builder_controller.dart';

/// Modal bottom sheet allowing users to add a food to their daily meal plan,
/// either by picking from saved recipes or by entering custom dish macros.
class AddMealPlanItemSheet extends ConsumerStatefulWidget {
  const AddMealPlanItemSheet({
    super.key,
    required this.userId,
    required this.date,
    required this.mealType,
    required this.mealLabel,
  });

  final String userId;
  final String date;
  final String mealType;
  final String mealLabel;

  static void show(
    BuildContext context, {
    required String userId,
    required String date,
    required String mealType,
    required String mealLabel,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddMealPlanItemSheet(
        userId: userId,
        date: date,
        mealType: mealType,
        mealLabel: mealLabel,
      ),
    );
  }

  @override
  ConsumerState<AddMealPlanItemSheet> createState() =>
      _AddMealPlanItemSheetState();
}

class _AddMealPlanItemSheetState extends ConsumerState<AddMealPlanItemSheet> {
  int _selectedTab = 0; // 0: Từ Công Thức, 1: Tự Nhập Món

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

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ClaySheet(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thêm Vào ${widget.mealLabel}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing12),

              // Tab Switcher
              _TabSwitcher(
                selectedIndex: _selectedTab,
                onChanged: (idx) => setState(() => _selectedTab = idx),
              ),
              const SizedBox(height: AppValues.spacing16),

              // Tab Content
              Flexible(
                child: SingleChildScrollView(
                  child: _selectedTab == 0
                      ? _buildRecipePicker()
                      : _buildCustomEntryForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipePicker() {
    final recipesAsync = ref.watch(recipesProvider(widget.userId));

    return recipesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppValues.spacing32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(AppValues.spacing16),
        child: Center(
          child: Text(
            'Lỗi tải công thức: $e',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
      data: (recipes) {
        if (recipes.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppValues.spacing24,
              horizontal: AppValues.spacing16,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 48,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: AppValues.spacing12),
                const Text(
                  'Bạn chưa có công thức nào được lưu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppValues.spacing16),
                ClayButton(
                  text: 'Tạo Công Thức Mới',
                  icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.router.push(const RecipeBuilderRoute());
                  },
                ),
                const SizedBox(height: AppValues.spacing8),
                TextButton(
                  onPressed: () => setState(() => _selectedTab = 1),
                  child: const Text('Hoặc tự nhập món ăn trực tiếp'),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recipes.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppValues.spacing8),
          itemBuilder: (context, i) {
            final r = recipes[i];
            return InkWell(
              borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
              onTap: () => _addRecipe(r),
              child: Container(
                padding: const EdgeInsets.all(AppValues.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppValues.radius12),
                      ),
                      child: const Icon(Icons.restaurant_menu, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: AppValues.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${r.totalCalories.round()} kcal  •  '
                            'C ${r.totalCarbs.round()}g  '
                            'P ${r.totalProtein.round()}g  '
                            'F ${r.totalFat.round()}g',
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.add_circle, color: AppColors.primary, size: 28),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCustomEntryForm() {
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
            onPressed: _submitCustom,
          ),
          const SizedBox(height: AppValues.spacing12),
        ],
      ),
    );
  }

  Future<void> _addRecipe(Recipe r) async {
    final item = MealPlanItem(
      id: '',
      userId: widget.userId,
      date: widget.date,
      mealType: widget.mealType,
      recipeId: r.id,
      foodName: r.name,
      calories: r.totalCalories,
      carbs: r.totalCarbs,
      protein: r.totalProtein,
      fat: r.totalFat,
    );

    Navigator.of(context).pop();
    await ref.read(mealPlanControllerProvider.notifier).addItem(
          userId: widget.userId,
          item: item,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm "${r.name}" vào ${widget.mealLabel}!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _submitCustom() async {
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

    Navigator.of(context).pop();
    await ref.read(mealPlanControllerProvider.notifier).addItem(
          userId: widget.userId,
          item: item,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm "${item.foodName}" vào ${widget.mealLabel}!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'Từ Công Thức',
              icon: Icons.menu_book_rounded,
              isSelected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _TabButton(
              title: 'Tự Nhập Món',
              icon: Icons.edit_note_rounded,
              isSelected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppValues.radius8),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
