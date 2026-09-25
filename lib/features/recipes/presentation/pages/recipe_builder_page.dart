import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../../recipes_providers.dart';
import '../controllers/recipe_builder_controller.dart';

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

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Tạo Công Thức Món Ăn'),
        actions: [
          _SaveButton(formKey: _formKey, nameCtrl: _nameCtrl),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          children: [
            // ── Recipe name ──────────────────────────────────────────────
            _SectionLabel('Tên Công Thức'),
            const SizedBox(height: AppValues.spacing8),
            TextFormField(
              controller: _nameCtrl,
              maxLength: 60,
              style: const TextStyle(color: AppColors.onSurface),
              decoration: _inputDecoration('VD: Salad Ức Gà Quinoa'),
              onChanged: ref.read(recipeBuilderProvider.notifier).setName,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên công thức' : null,
            ),
            const SizedBox(height: AppValues.spacing16),

            // ── Description ──────────────────────────────────────────────
            _SectionLabel('Ghi Chú Chế Biến (tuỳ chọn)'),
            const SizedBox(height: AppValues.spacing8),
            TextFormField(
              controller: _descCtrl,
              maxLength: 250,
              maxLines: 2,
              style: const TextStyle(color: AppColors.onSurface),
              decoration: _inputDecoration('Mô tả cách nấu, lưu ý...'),
              onChanged: ref.read(recipeBuilderProvider.notifier).setDescription,
            ),
            const SizedBox(height: AppValues.spacing24),

            // ── Macro summary card ───────────────────────────────────────
            _MacroSummaryCard(state: state),
            const SizedBox(height: AppValues.spacing24),

            // ── Ingredients list ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel('Nguyên Liệu (${state.ingredients.length})'),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Thêm'),
                  onPressed: () => _showAddIngredientSheet(context),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing8),

            if (state.ingredients.isEmpty)
              _EmptyIngredients()
            else
              ...state.ingredients.asMap().entries.map(
                    (e) => _IngredientTile(
                      ingredient: e.value,
                      index: e.key,
                    ),
                  ),

            // ── Validation error ─────────────────────────────────────────
            if (state.error != null) ...[
              const SizedBox(height: AppValues.spacing16),
              _ErrorBanner(message: state.error!),
            ],

            const SizedBox(height: 100), // bottom safe area
          ],
        ),
      ),
    );
  }

  void _showAddIngredientSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.cardRadius)),
      ),
      builder: (_) => _AddIngredientSheet(),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      filled: true,
      fillColor: AppColors.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.radius8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.radius8),
        borderSide: const BorderSide(color: AppColors.outline, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.radius8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.radius8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      counterStyle: const TextStyle(color: AppColors.onSurfaceVariant),
    );
  }
}

// ── Save Button ───────────────────────────────────────────────────────────────

class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.formKey, required this.nameCtrl});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recipeBuilderProvider);

    if (state.isSaving) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppValues.spacing16),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return TextButton(
      onPressed: () => _save(context, ref),
      child: const Text(
        'Lưu',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final controller = ref.read(recipeBuilderProvider.notifier);
    final repo = ref.read(recipeRepositoryProvider);
    // ponytail: userId hardcoded '' — upgrade path: ref.read(authStateProvider).valueOrNull?.uid ?? ''
    const userId = '';

    final saved = await controller.save(userId: userId, repo: repo);
    if (!context.mounted) return;

    if (saved != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Đã lưu công thức ${saved.name}'),
          backgroundColor: AppColors.success,
        ),
      );
      context.router.maybePop();
    }
  }
}


// ── Macro Summary Card ────────────────────────────────────────────────────────

class _MacroSummaryCard extends StatelessWidget {
  const _MacroSummaryCard({required this.state});

  final RecipeBuilderState state;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Text(
            '${state.totalCalories.toStringAsFixed(0)} kcal',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppValues.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroChip(
                label: 'Carbs',
                value: state.totalCarbs,
                color: AppColors.carbs,
              ),
              _MacroChip(
                label: 'Protein',
                value: state.totalProtein,
                color: AppColors.protein,
              ),
              _MacroChip(
                label: 'Fat',
                value: state.totalFat,
                color: AppColors.fat,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${value.toStringAsFixed(1)}g',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

// ── Ingredient Tile ───────────────────────────────────────────────────────────

class _IngredientTile extends ConsumerWidget {
  const _IngredientTile({required this.ingredient, required this.index});

  final RecipeIngredient ingredient;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('${ingredient.foodId}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppValues.spacing16),
        color: AppColors.error.withValues(alpha: 0.2),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) =>
          ref.read(recipeBuilderProvider.notifier).removeIngredient(index),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing12,
          vertical: AppValues.spacing8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${ingredient.amountGrams.toStringAsFixed(0)}g • '
                    '${ingredient.calories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _MacroDot(AppColors.carbs, ingredient.carbs),
                const SizedBox(width: AppValues.spacing4),
                _MacroDot(AppColors.protein, ingredient.protein),
                const SizedBox(width: AppValues.spacing4),
                _MacroDot(AppColors.fat, ingredient.fat),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroDot extends StatelessWidget {
  const _MacroDot(this.color, this.value);

  final Color color;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(
          '${value.toStringAsFixed(0)}g',
          style: TextStyle(color: color, fontSize: 10),
        ),
      ],
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          const Icon(Icons.blender_outlined, color: AppColors.onSurfaceVariant, size: 40),
          const SizedBox(height: AppValues.spacing8),
          Text(
            'Chưa có nguyên liệu nào.\nNhấn "Thêm" để bắt đầu.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ── Error Banner ──────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.spacing12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppValues.radius8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: AppValues.spacing8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add Ingredient Bottom Sheet ───────────────────────────────────────────────

class _AddIngredientSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddIngredientSheet> createState() =>
      _AddIngredientSheetState();
}

class _AddIngredientSheetState extends ConsumerState<_AddIngredientSheet> {
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppValues.screenPadding,
        right: AppValues.screenPadding,
        top: AppValues.spacing24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Thêm Nguyên Liệu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppValues.spacing16),
              _Field(ctrl: _nameCtrl, hint: 'Tên nguyên liệu', label: 'Tên'),
              const SizedBox(height: AppValues.spacing12),
              Row(
                children: [
                  Expanded(child: _NumberField(ctrl: _gramsCtrl, label: 'Gram (g)')),
                  const SizedBox(width: AppValues.spacing8),
                  Expanded(child: _NumberField(ctrl: _calCtrl, label: 'Calo (kcal)')),
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
                  const SizedBox(width: AppValues.spacing8),
                  Expanded(
                    child: _NumberField(
                      ctrl: _proteinCtrl,
                      label: 'Protein (g)',
                      color: AppColors.protein,
                    ),
                  ),
                  const SizedBox(width: AppValues.spacing8),
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
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(AppValues.minTouchTarget),
                ),
                child: const Text('Thêm Nguyên Liệu'),
              ),
              const SizedBox(height: AppValues.spacing24),
            ],
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
      style: const TextStyle(color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radius8),
          borderSide: const BorderSide(color: AppColors.outline),
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
      style: TextStyle(color: color ?? AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color ?? AppColors.onSurfaceVariant, fontSize: 12),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radius8),
          borderSide: BorderSide(color: color ?? AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radius8),
          borderSide: BorderSide(color: color ?? AppColors.primary),
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

// ── Section label helper ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
    );
  }
}
