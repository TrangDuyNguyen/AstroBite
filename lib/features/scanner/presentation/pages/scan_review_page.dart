import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/scanner/domain/entities/scan_result.dart';
import 'package:astrobite/features/scanner/domain/usecases/scan_food_usecase.dart';
import 'package:astrobite/features/scanner/presentation/controllers/scanner_controller.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import 'package:astrobite/shared/widgets/meal_type_chip.dart';
import '../widgets/micronutrient_chips_row.dart';

@RoutePage()
class ScanReviewPage extends ConsumerStatefulWidget {
  const ScanReviewPage({
    super.key,
    this.scanResult,
    this.imageBytes,
  });

  final ScanResult? scanResult;
  final Uint8List? imageBytes;

  @override
  ConsumerState<ScanReviewPage> createState() => _ScanReviewPageState();
}

class _ScanReviewPageState extends ConsumerState<ScanReviewPage> {
  late String _selectedMeal;
  int _currentWeightG = 0;
  bool _isSaving = false;
  List<DishItem> _dishes = [];

  static String _defaultMealType() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'breakfast';
    if (hour >= 11 && hour < 16) return 'lunch';
    if (hour >= 16 && hour < 21) return 'dinner';
    return 'snack';
  }

  String _mealLabel(String mealType) => switch (mealType) {
        'breakfast' => AppStrings.breakfast,
        'lunch' => AppStrings.lunch,
        'dinner' => AppStrings.dinner,
        'snack' => AppStrings.snack,
        _ => mealType,
      };

  @override
  void initState() {
    super.initState();
    _selectedMeal = _defaultMealType();
    final initial = widget.scanResult ?? _resolveFromProvider();
    if (initial != null) {
      _currentWeightG = initial.totalWeightG > 0
          ? initial.totalWeightG
          : (initial.dishes.isNotEmpty
              ? initial.dishes.first.estimatedWeightG
              : 350);
      _dishes = initial.dishes.map((d) => d.copyWith()).toList();
    }
  }

  ScanResult? _resolveFromProvider() {
    final scanState = ref.read(scannerControllerProvider);
    if (scanState.value is ScanSuccess) {
      return (scanState.value as ScanSuccess).result;
    }
    return null;
  }

  ScanResult _computeEffectiveResult(ScanResult base) {
    if (_dishes.length <= 1) {
      final effectiveWeight = _currentWeightG > 0
          ? _currentWeightG
          : (base.totalWeightG > 0 ? base.totalWeightG : 350);
      return base.scaleToWeight(effectiveWeight);
    }

    return ScanResult(
      isFood: true,
      totalCalories: base.totalCalories,
      proteinG: base.proteinG,
      carbsG: base.carbsG,
      fatG: base.fatG,
      sodiumMg: base.sodiumMg,
      fiberG: base.fiberG,
      sugarG: base.sugarG,
      dishes: _dishes,
    );
  }

  Future<void> _saveFoodLog(ScanResult effective) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để lưu nhật ký')),
        );
        setState(() => _isSaving = false);
      }
      return;
    }

    try {
      final activeDishes = _dishes.where((d) => d.isSelected).toList();
      final isMulti = activeDishes.length > 1;

      final log = FoodLogDto(
        id: '',
        date: ref.read(todayDateProvider),
        mealType: _selectedMeal,
        dishName: effective.primaryDishName,
        estimatedWeightG: _dishes.length > 1 ? effective.activeWeightG : _currentWeightG,
        calories: effective.activeCalories,
        proteinG: effective.activeProteinG,
        carbsG: effective.activeCarbsG,
        fatG: effective.activeFatG,
        source: isMulti ? 'multi_scan' : 'ai_scan',
        confidenceScore: effective.primaryConfidenceScore,
        imageUrl: null,
        sodiumMg: effective.activeSodiumMg,
        fiberG: effective.activeFiberG,
        sugarG: effective.activeSugarG,
        syncStatus: 'pending_sync',
        dishes: activeDishes
            .map((d) => {
                  'dish_name': d.dishName,
                  'estimated_weight_g': d.estimatedWeightG,
                  'calories': d.calories,
                  'carbs_g': d.carbsG,
                  'protein_g': d.proteinG,
                  'fat_g': d.fatG,
                  'sodium_mg': d.sodiumMg,
                  'fiber_g': d.fiberG,
                  'sugar_g': d.sugarG,
                  'confidence_score': d.confidenceScore,
                  'is_selected': d.isSelected,
                })
            .toList(),
      );

      await ref.read(foodLogRepositoryProvider).addFoodLog(
            userId: user.uid,
            log: log,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã lưu ${effective.primaryDishName} vào ${_mealLabel(_selectedMeal)}!',
            ),
          ),
        );
        context.router.popUntilRoot();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu nhật ký: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showQuickAddSheet(BuildContext context) {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final weightController = TextEditingController(text: '150');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.cardRadius)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppValues.screenPadding,
          right: AppValues.screenPadding,
          top: AppValues.screenPadding,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppValues.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thêm món ăn thủ công',
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên món ăn',
                hintText: 'VD: Canh khổ qua, Trứng ốp la...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppValues.spacing12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: calController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Calo (kcal)',
                      hintText: 'VD: 120',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppValues.spacing12),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Khẩu phần (g)',
                      hintText: 'VD: 150',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing16),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final cal = int.tryParse(calController.text.trim()) ?? 0;
                final weight = int.tryParse(weightController.text.trim()) ?? 150;
                if (name.isNotEmpty && cal > 0) {
                  setState(() {
                    _dishes.add(DishItem(
                      dishName: name,
                      confidenceScore: 1.0,
                      estimatedWeightG: weight,
                      calories: cal,
                      carbsG: (cal * 0.5 / 4).round(),
                      proteinG: (cal * 0.3 / 4).round(),
                      fatG: (cal * 0.2 / 9).round(),
                      isSelected: true,
                    ));
                  });
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Thêm vào mâm cơm'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseResult = widget.scanResult ?? _resolveFromProvider();

    if (baseResult == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kết quả phân tích AI')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 64, color: AppColors.onSurfaceVariant),
              const SizedBox(height: AppValues.spacing16),
              const Text('Chưa có dữ liệu phân tích món ăn.'),
              const SizedBox(height: AppValues.spacing24),
              FilledButton(
                onPressed: () => context.router.popForced(),
                child: const Text('Quay lại Camera'),
              ),
            ],
          ),
        ),
      );
    }

    final scaled = _computeEffectiveResult(baseResult);
    final effectiveWeight = _currentWeightG > 0
        ? _currentWeightG
        : (baseResult.totalWeightG > 0 ? baseResult.totalWeightG : 350);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả phân tích AI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.popForced(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Food name & confidence score badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      scaled.primaryDishName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.spacing12,
                      vertical: AppValues.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppValues.spacing16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 16, color: AppColors.primary),
                        const SizedBox(width: AppValues.spacing4),
                        Text(
                          '${(scaled.primaryConfidenceScore * 100).toInt()}% tin cậy',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing16),

              // Hero Calorie GlassCard
              GlassCard(
                child: Column(
                  children: [
                    Text(
                      '${scaled.activeCalories} kcal',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: AppValues.calorieLetterSpacing,
                          ),
                    ),
                    const SizedBox(height: AppValues.spacing12),
                    // Strict Celestial Dark Nutrient Colors
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MacroIndicator(
                          label: 'Tinh bột',
                          value: '${scaled.activeCarbsG}g',
                          color: AppColors.primary, // #1A73E8
                        ),
                        _MacroIndicator(
                          label: 'Chất đạm',
                          value: '${scaled.activeProteinG}g',
                          color: AppColors.tertiary, // #FFD700
                        ),
                        _MacroIndicator(
                          label: 'Chất béo',
                          value: '${scaled.activeFatG}g',
                          color: AppColors.secondary, // #FF69B4
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    // CMP-MIC-01: Micronutrient Chips Row
                    MicronutrientChipsRow(
                      sodiumMg: scaled.activeSodiumMg,
                      fiberG: scaled.activeFiberG,
                      sugarG: scaled.activeSugarG,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppValues.spacing24),

              // Single item portion slider (if only 1 dish)
              if (_dishes.length <= 1) ...[
                Card(
                  color: AppColors.surfaceContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppValues.cardRadius),
                    side: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppValues.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Khẩu phần ước lượng',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppValues.spacing12,
                                vertical: AppValues.spacing4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppValues.radius8),
                              ),
                              child: Text(
                                '${effectiveWeight}g',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppValues.spacing8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.outline.withValues(alpha: 0.3),
                            thumbColor: AppColors.primary,
                            overlayColor: AppColors.primary.withValues(alpha: 0.2),
                          ),
                          child: Slider(
                            value: effectiveWeight.toDouble().clamp(50.0, 1000.0),
                            min: 50.0,
                            max: 1000.0,
                            divisions: 95,
                            onChanged: (val) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _currentWeightG = val.round();
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '50g',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                            Text(
                              '1000g',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.spacing16),
              ],

              // Multi-Item dishes segment detail
              if (_dishes.length > 1) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thành phần nhận diện (${_dishes.length} món)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Thêm món'),
                      onPressed: () => _showQuickAddSheet(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppValues.spacing8),
                ...List.generate(_dishes.length, (idx) {
                  final dish = _dishes[idx];
                  return _DishItemCard(
                    dish: dish,
                    onToggle: (val) {
                      setState(() {
                        dish.isSelected = val ?? true;
                      });
                    },
                    onWeightChanged: (newWeight) {
                      setState(() {
                        final baseWeight = dish.estimatedWeightG > 0 ? dish.estimatedWeightG : 100;
                        final ratio = newWeight / baseWeight;
                        dish.estimatedWeightG = newWeight;
                        dish.calories = (dish.calories * ratio).round();
                        dish.carbsG = (dish.carbsG * ratio).round();
                        dish.proteinG = (dish.proteinG * ratio).round();
                        dish.fatG = (dish.fatG * ratio).round();
                        dish.sodiumMg = dish.sodiumMg * ratio;
                        dish.fiberG = dish.fiberG * ratio;
                        dish.sugarG = dish.sugarG * ratio;
                      });
                    },
                    onRemove: () {
                      setState(() {
                        _dishes.removeAt(idx);
                      });
                    },
                  );
                }),
                const SizedBox(height: AppValues.spacing16),
              ],

              // Meal Type Selector
              Text(
                'Bữa ăn áp dụng',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppValues.spacing8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MealTypeChip(
                      mealType: 'breakfast',
                      isSelected: _selectedMeal == 'breakfast',
                      onTap: () => setState(() => _selectedMeal = 'breakfast'),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    MealTypeChip(
                      mealType: 'lunch',
                      isSelected: _selectedMeal == 'lunch',
                      onTap: () => setState(() => _selectedMeal = 'lunch'),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    MealTypeChip(
                      mealType: 'dinner',
                      isSelected: _selectedMeal == 'dinner',
                      onTap: () => setState(() => _selectedMeal = 'dinner'),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    MealTypeChip(
                      mealType: 'snack',
                      isSelected: _selectedMeal == 'snack',
                      onTap: () => setState(() => _selectedMeal = 'snack'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppValues.spacing32),

              // Save to Diary Button
              SizedBox(
                height: AppValues.minTouchTarget + 4,
                child: FilledButton(
                  onPressed: _isSaving ? null : () => _saveFoodLog(scaled),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isSaving)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        const Icon(Icons.bookmark_add_outlined),
                      const SizedBox(width: AppValues.spacing8),
                      Text(
                        _isSaving
                            ? 'Đang lưu...'
                            : 'Lưu vào ${_mealLabel(_selectedMeal)} (${scaled.activeCalories} kcal)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
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

class _DishItemCard extends StatelessWidget {
  const _DishItemCard({
    required this.dish,
    required this.onToggle,
    required this.onWeightChanged,
    required this.onRemove,
  });

  final DishItem dish;
  final ValueChanged<bool?> onToggle;
  final ValueChanged<int> onWeightChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isSelected = dish.isSelected;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isSelected ? 1.0 : 0.4,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppValues.spacing12),
        color: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radius12),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppValues.spacing12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: onToggle,
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      dish.dishName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: isSelected
                                ? TextDecoration.none
                                : TextDecoration.lineThrough,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.spacing8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppValues.radius8),
                    ),
                    child: Text(
                      '${(dish.confidenceScore * 100).toInt()}% tin cậy',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: 'Xóa món',
                    onPressed: onRemove,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.spacing8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${dish.estimatedWeightG}g • ${dish.calories} kcal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                    ),
                    Row(
                      children: [
                        _MiniMacro(label: 'C', value: '${dish.carbsG}g', color: AppColors.primary),
                        const SizedBox(width: AppValues.spacing8),
                        _MiniMacro(label: 'P', value: '${dish.proteinG}g', color: AppColors.tertiary),
                        const SizedBox(width: AppValues.spacing8),
                        _MiniMacro(label: 'F', value: '${dish.fatG}g', color: AppColors.secondary),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: AppValues.spacing4),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.outline.withValues(alpha: 0.3),
                    thumbColor: AppColors.primary,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: dish.estimatedWeightG.toDouble().clamp(20.0, 800.0),
                    min: 20.0,
                    max: 800.0,
                    divisions: 156,
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      onWeightChanged(val.round());
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMacro extends StatelessWidget {
  const _MiniMacro({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _MacroIndicator extends StatelessWidget {
  const _MacroIndicator({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: AppValues.spacing4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
