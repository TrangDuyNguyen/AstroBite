import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/recipe_builder_controller.dart';
import '../widgets/recipe_add_ingredient_sheet.dart';
import '../widgets/recipe_builder_empty_state.dart';
import '../widgets/recipe_ingredient_tile.dart';
import '../widgets/recipe_macro_summary_card.dart';
import '../widgets/recipe_save_button.dart';

@RoutePage()
class RecipeBuilderPage extends ConsumerStatefulWidget {
  const RecipeBuilderPage({super.key});

  @override
  ConsumerState<RecipeBuilderPage> createState() => _RecipeBuilderPageState();
}

class _RecipeBuilderPageState extends ConsumerState<RecipeBuilderPage> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeBuilderProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Row(
            children: [
              const Clay3DCookbook(size: 26),
              const SizedBox(width: 10),
              Text(
                'Tạo Công Thức Món Ăn',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: -0.3,
                    ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppValues.screenPadding),
              child: RecipeSaveButton(formKey: _formKey, nameCtrl: _nameCtrl),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppValues.screenPadding,
              AppValues.spacing12,
              AppValues.screenPadding,
              MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            children: [
              // ── Recipe name ──────────────────────────────────────────────
              const RecipeSectionLabel('Tên Công Thức'),
              const SizedBox(height: AppValues.spacing8),
              TextFormField(
                controller: _nameCtrl,
                maxLength: 60,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                decoration: _inputDecoration('VD: Salad Ức Gà Quinoa'),
                onChanged: ref.read(recipeBuilderProvider.notifier).setName,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên công thức' : null,
              ),
              const SizedBox(height: AppValues.spacing16),

              // ── Description ──────────────────────────────────────────────
              const RecipeSectionLabel('Ghi Chú Chế Biến (tuỳ chọn)'),
              const SizedBox(height: AppValues.spacing8),
              TextFormField(
                controller: _descCtrl,
                maxLength: 250,
                maxLines: 2,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 14,
                ),
                decoration: _inputDecoration('Mô tả cách nấu, lưu ý nhiệt độ...'),
                onChanged: ref.read(recipeBuilderProvider.notifier).setDescription,
              ),
              const SizedBox(height: AppValues.spacing20),

              // ── Macro summary card ───────────────────────────────────────
              RecipeMacroSummaryCard(state: state),
              const SizedBox(height: AppValues.spacing24),

              // ── Ingredients list ─────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const RecipeSectionLabel('Nguyên Liệu'),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F6FD),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF90D5F7),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          '${state.ingredients.length}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => RecipeAddIngredientSheet.show(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F6FD),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF90D5F7),
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFBCE3F7),
                            offset: Offset(0, 1.8),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Thêm',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing12),

              if (state.ingredients.isEmpty)
                const RecipeBuilderEmptyState()
              else
                ...state.ingredients.asMap().entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: AppValues.spacing8),
                        child: RecipeIngredientTile(
                          ingredient: e.value,
                          index: e.key,
                        ),
                      ),
                    ),

              // ── Validation error ─────────────────────────────────────────
              if (state.error != null) ...[
                const SizedBox(height: AppValues.spacing16),
                RecipeBuilderErrorBanner(message: state.error!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8E5DF), width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE8E5DF), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      counterStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11),
    );
  }
}
