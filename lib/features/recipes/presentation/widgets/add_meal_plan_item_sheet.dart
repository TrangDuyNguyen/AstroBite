import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/meal_plan_item.dart';
import '../../domain/entities/recipe.dart';
import '../controllers/meal_plan_controller.dart';
import '../controllers/recipe_builder_controller.dart';
import 'meal_plan_custom_entry_form.dart';
import 'meal_plan_tab_switcher.dart';

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
              MealPlanTabSwitcher(
                selectedIndex: _selectedTab,
                onChanged: (idx) => setState(() => _selectedTab = idx),
              ),
              const SizedBox(height: AppValues.spacing16),

              // Tab Content
              Flexible(
                child: SingleChildScrollView(
                  child: _selectedTab == 0
                      ? _buildRecipePicker()
                      : MealPlanCustomEntryForm(
                          userId: widget.userId,
                          date: widget.date,
                          mealType: widget.mealType,
                          mealLabel: widget.mealLabel,
                          onSubmit: _saveCustomItem,
                        ),
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

  Future<void> _saveCustomItem(MealPlanItem item) async {
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
