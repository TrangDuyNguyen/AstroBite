import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
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
              child: _SaveButton(formKey: _formKey, nameCtrl: _nameCtrl),
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
              MediaQuery.of(context).viewInsets.bottom + 120, // bottom safe area with keyboard
            ),
          children: [
            // ── Recipe name ──────────────────────────────────────────────
            const _SectionLabel('Tên Công Thức'),
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
            const _SectionLabel('Ghi Chú Chế Biến (tuỳ chọn)'),
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
            _MacroSummaryCard(state: state),
            const SizedBox(height: AppValues.spacing24),

            // ── Ingredients list ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const _SectionLabel('Nguyên Liệu'),
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
                  onTap: () => _showAddIngredientSheet(context),
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
              const _EmptyIngredients()
            else
              ...state.ingredients.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: AppValues.spacing8),
                      child: _IngredientTile(
                        ingredient: e.value,
                        index: e.key,
                      ),
                    ),
                  ),

            // ── Validation error ─────────────────────────────────────────
            if (state.error != null) ...[
              const SizedBox(height: AppValues.spacing16),
              _ErrorBanner(message: state.error!),
            ],
          ],
        ),
      ),
    ),
  );
}

  void _showAddIngredientSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddIngredientSheet(),
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

// ── 3D Duolingo Save Button ───────────────────────────────────────────────────

class _SaveButton extends ConsumerStatefulWidget {
  const _SaveButton({required this.formKey, required this.nameCtrl});

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;

  @override
  ConsumerState<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<_SaveButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeBuilderProvider);

    if (state.isSaving) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _save(context, ref);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 1.8 : 0.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF38BDF8), Color(0xFF1CB0F6)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF1488C2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F74A8),
              offset: Offset(0, _isPressed ? 1.0 : 2.8),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Text(
          'Lưu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    if (!(widget.formKey.currentState?.validate() ?? false)) return;

    final controller = ref.read(recipeBuilderProvider.notifier);
    final repo = ref.read(recipeRepositoryProvider);
    final user = ref.read(authStateProvider).valueOrNull;
    final userId = (user?.uid.isNotEmpty == true) ? user!.uid : 'guest_user';

    final saved = await controller.save(userId: userId, repo: repo);
    if (!context.mounted) return;

    if (saved != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Đã lưu công thức "${saved.name}"'),
          backgroundColor: AppColors.brandGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    return ClayCard(
      elevation: 4.0,
      borderRadius: 22.0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng Dinh Dưỡng Công Thức',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${state.totalCalories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2D6),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFFCD34D),
                      offset: Offset(0, 1.8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFFFF9600),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEDE8DD)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MacroPill(
                  label: 'Carbs',
                  value: state.totalCarbs,
                  bg: const Color(0xFFE5F6FD),
                  border: const Color(0xFF90D5F7),
                  bevel: const Color(0xFFBCE3F7),
                  color: AppColors.carbs,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroPill(
                  label: 'Protein',
                  value: state.totalProtein,
                  bg: const Color(0xFFFFF2D6),
                  border: const Color(0xFFFDE68A),
                  bevel: const Color(0xFFFCD34D),
                  color: AppColors.protein,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroPill(
                  label: 'Fat',
                  value: state.totalFat,
                  bg: const Color(0xFFFFE8EE),
                  border: const Color(0xFFFAC4D2),
                  bevel: const Color(0xFFF7A8BE),
                  color: AppColors.fat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.value,
    required this.bg,
    required this.border,
    required this.bevel,
    required this.color,
  });

  final String label;
  final double value;
  final Color bg;
  final Color border;
  final Color bevel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: bevel,
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${value.toStringAsFixed(1)}g',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
        padding: const EdgeInsets.only(right: AppValues.screenPadding),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE8EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFAC4D2)),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      onDismissed: (_) =>
          ref.read(recipeBuilderProvider.notifier).removeIngredient(index),
      child: ClayCard(
        elevation: 2.5,
        borderRadius: 16.0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Left Dish Badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F6F2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEDE8DD), width: 1.0),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.restaurant_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),

            // Name & grams/calories
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ingredient.amountGrams.toStringAsFixed(0)}g • '
                    '${ingredient.calories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Mini Macro Dots
            Row(
              children: [
                _MiniDot(AppColors.carbs, ingredient.carbs, 'C'),
                const SizedBox(width: 6),
                _MiniDot(AppColors.protein, ingredient.protein, 'P'),
                const SizedBox(width: 6),
                _MiniDot(AppColors.fat, ingredient.fat, 'F'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniDot extends StatelessWidget {
  const _MiniDot(this.color, this.value, this.unit);

  final Color color;
  final double value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${value.toStringAsFixed(0)}g',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyIngredients extends StatelessWidget {
  const _EmptyIngredients();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      elevation: 2.0,
      borderRadius: 18.0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F6F2),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEDE8DD), width: 1.2),
            ),
            child: const Icon(
              Icons.soup_kitchen_rounded,
              color: AppColors.onSurfaceVariant,
              size: 26,
            ),
          ),
          const SizedBox(height: AppValues.spacing12),
          const Text(
            'Chưa có nguyên liệu nào',
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Nhấn nút "+ Thêm" ở trên để đưa nguyên liệu vào công thức.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12.5,
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFAC4D2), width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add Ingredient Bottom Sheet ───────────────────────────────────────────────

class _AddIngredientSheet extends ConsumerStatefulWidget {
  const _AddIngredientSheet();

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
          borderSide: BorderSide(color: color?.withValues(alpha: 0.5) ?? const Color(0xFFE8E5DF), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color?.withValues(alpha: 0.5) ?? const Color(0xFFE8E5DF), width: 1.2),
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

// ── Section label helper ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.1,
      ),
    );
  }
}
