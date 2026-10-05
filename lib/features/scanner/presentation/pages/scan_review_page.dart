import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/scanner/domain/entities/scan_result.dart';
import 'package:astrobite/features/scanner/domain/usecases/scan_food_usecase.dart';
import 'package:astrobite/features/scanner/presentation/controllers/scanner_controller.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../widgets/micronutrient_chips_row.dart';
import '../widgets/broth_toggle_chip.dart';
import '../widgets/topping_checklist_wrap.dart';

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
      final scaled = base.scaleToWeight(effectiveWeight);
      if (_dishes.isNotEmpty && scaled.dishes.isNotEmpty) {
        final d = _dishes.first;
        scaled.dishes.first.hasBroth = d.hasBroth;
        scaled.dishes.first.brothCalories = d.brothCalories;
        scaled.dishes.first.brothSodiumMg = d.brothSodiumMg;
        scaled.dishes.first.includeBroth = d.includeBroth;
        scaled.dishes.first.subItems = d.subItems;
      }
      return scaled;
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
                  'calories': d.effectiveCalories,
                  'carbs_g': d.effectiveCarbsG,
                  'protein_g': d.effectiveProteinG,
                  'fat_g': d.effectiveFatG,
                  'sodium_mg': d.effectiveSodiumMg,
                  'fiber_g': d.fiberG,
                  'sugar_g': d.sugarG,
                  'confidence_score': d.confidenceScore,
                  'is_selected': d.isSelected,
                  'has_broth': d.hasBroth,
                  'broth_calories': d.brothCalories,
                  'broth_sodium_mg': d.brothSodiumMg,
                  'include_broth': d.includeBroth,
                  'sub_items': d.subItems
                      .map((s) => {
                            'name': s.name,
                            'calories': s.calories,
                            'carbs_g': s.carbsG,
                            'protein_g': s.proteinG,
                            'fat_g': s.fatG,
                            'is_selected': s.isSelected,
                          })
                      .toList(),
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Kết quả phân tích AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.onSurface,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: ClayIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              size: 40,
              borderRadius: 14,
              tooltip: 'Quay lại',
              onPressed: () => context.router.popForced(),
            ),
          ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_dishes.length > 1) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppValues.spacing8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppValues.radius8),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '🍱 Mâm cơm (${_dishes.length} món)',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: AppValues.spacing4),
                        ],
                        Text(
                          _dishes.length > 2
                              ? '${_dishes.first.dishName} & ${_dishes.length - 1} món khác'
                              : scaled.primaryDishName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                        ),
                        if (_dishes.length > 1) ...[
                          const SizedBox(height: 2),
                          Text(
                            _dishes.map((d) => d.dishName).join(' • '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppValues.spacing8),
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

              // Hero Calorie Card (Pure White Clay Bento Card with 3D Bevel)
              Container(
                padding: const EdgeInsets.all(AppValues.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppValues.spacing24),
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFD4CEBF),
                      offset: Offset(0, 3.5),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x0C1E2337),
                      offset: Offset(0, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${scaled.activeCalories} kcal',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    letterSpacing: AppValues.calorieLetterSpacing,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Khẩu phần tiêu chuẩn • ${effectiveWeight}g',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                        _CalorieTargetRadialGauge(
                          calories: scaled.activeCalories,
                          targetCalories: 2100,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    // Strict Nutrient Color Semantics - Macro Triad (Carbs, Protein, Fat)
                    Row(
                      children: [
                        Expanded(
                          child: _MacroIndicator(
                            label: 'Tinh bột',
                            value: '${scaled.activeCarbsG}g',
                            color: AppColors.primary, // #1CB0F6
                            ratio: (scaled.activeCalories > 0
                                ? (scaled.activeCarbsG * 4) / scaled.activeCalories
                                : 0.48).clamp(0.0, 1.0),
                          ),
                        ),
                        const SizedBox(width: AppValues.spacing8),
                        Expanded(
                          child: _MacroIndicator(
                            label: 'Chất đạm',
                            value: '${scaled.activeProteinG}g',
                            color: AppColors.tertiary, // #FF9600
                            ratio: (scaled.activeCalories > 0
                                ? (scaled.activeProteinG * 4) / scaled.activeCalories
                                : 0.24).clamp(0.0, 1.0),
                          ),
                        ),
                        const SizedBox(width: AppValues.spacing8),
                        Expanded(
                          child: _MacroIndicator(
                            label: 'Chất béo',
                            value: '${scaled.activeFatG}g',
                            color: AppColors.secondary, // #FF5C8D
                            ratio: (scaled.activeCalories > 0
                                ? (scaled.activeFatG * 9) / scaled.activeCalories
                                : 0.28).clamp(0.0, 1.0),
                          ),
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
              const SizedBox(height: AppValues.spacing20),

              // Single item portion slider (if only 1 dish)
              if (_dishes.length <= 1) ...[
                Container(
                  padding: const EdgeInsets.all(AppValues.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppValues.spacing20),
                    border: Border.all(
                      color: AppColors.outline.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFD4CEBF),
                        offset: Offset(0, 3.0),
                        blurRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x0A1E2337),
                        offset: Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
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
                                  color: AppColors.onSurface,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppValues.spacing12,
                              vertical: AppValues.spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(AppValues.radius8),
                              border: Border.all(
                                color: const Color(0xFFBAE6FD),
                                width: 1,
                              ),
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
                      const SizedBox(height: AppValues.spacing12),

                      // Quick Weight Steppers (US-02 / BVA Presets)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _QuickReviewWeightChip(
                              label: '-50g',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _currentWeightG = (effectiveWeight - 50).clamp(50, 1000);
                                });
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickReviewWeightChip(
                              label: '+50g',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _currentWeightG = (effectiveWeight + 50).clamp(50, 1000);
                                });
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickReviewWeightChip(
                              label: '1 Bát (~150g)',
                              isSelected: effectiveWeight == 150,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _currentWeightG = 150);
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickReviewWeightChip(
                              label: '1 Đĩa (~300g)',
                              isSelected: effectiveWeight == 300,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _currentWeightG = 300);
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickReviewWeightChip(
                              label: 'Phần Chuẩn (~350g)',
                              isSelected: effectiveWeight == 350,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _currentWeightG = 350);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppValues.spacing8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.outline.withValues(alpha: 0.35),
                          thumbColor: AppColors.primary,
                          overlayColor: AppColors.primary.withValues(alpha: 0.15),
                          trackHeight: 5,
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
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '1000g',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_dishes.isNotEmpty && (_dishes.first.hasBroth || _dishes.first.subItems.isNotEmpty)) ...[
                  const SizedBox(height: AppValues.spacing12),
                  BrothToggleChip(
                    hasBroth: _dishes.first.hasBroth,
                    includeBroth: _dishes.first.includeBroth,
                    brothCalories: _dishes.first.brothCalories,
                    brothSodiumMg: _dishes.first.brothSodiumMg,
                    onToggle: (val) {
                      setState(() {
                        _dishes.first.includeBroth = val;
                      });
                    },
                  ),
                  ToppingChecklistWrap(
                    subItems: _dishes.first.subItems,
                    onToggleSubItem: (idx, isSel) {
                      setState(() {
                        _dishes.first.subItems[idx].isSelected = isSel;
                      });
                    },
                  ),
                ],
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
                    onBrothToggle: (val) {
                      setState(() {
                        dish.includeBroth = val;
                      });
                    },
                    onSubItemToggle: (subIdx, isSel) {
                      setState(() {
                        dish.subItems[subIdx].isSelected = isSel;
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppValues.screenPadding,
          AppValues.spacing12,
          AppValues.screenPadding,
          AppValues.spacing16,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C1E2337),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: AppColors.outline.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // One-Thumb Meal Type Selector (US-03)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: AppValues.spacing12),
              // Sticky Save CTA Button Row with Re-scan
              Row(
                children: [
                  // Tactile Re-scan button
                  _TactileActionButton(
                    icon: Icons.refresh_rounded,
                    iconSize: 24,
                    tooltip: 'Quét lại',
                    onPressed: () => context.router.popForced(),
                  ),
                  const SizedBox(width: AppValues.spacing12),
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF388002),
                            offset: Offset(0, 4),
                            blurRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x18000000),
                            offset: Offset(0, 6),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: FilledButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                                HapticFeedback.lightImpact();
                                _saveFoodLog(scaled);
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isSaving)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else
                              const Icon(Icons.check_circle_outline, size: 20),
                            const SizedBox(width: AppValues.spacing8),
                            Text(
                              _isSaving
                                  ? 'Đang lưu...'
                                  : 'Lưu vào ${_mealLabel(_selectedMeal)} (${scaled.activeCalories} kcal)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
    this.onBrothToggle,
    this.onSubItemToggle,
  });

  final DishItem dish;
  final ValueChanged<bool?> onToggle;
  final ValueChanged<int> onWeightChanged;
  final VoidCallback onRemove;
  final ValueChanged<bool>? onBrothToggle;
  final void Function(int index, bool isSelected)? onSubItemToggle;

  @override
  Widget build(BuildContext context) {
    final isSelected = dish.isSelected;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isSelected ? 1.0 : 0.45,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppValues.spacing12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppValues.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.35)
                : AppColors.outline.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4CEBF).withValues(alpha: 0.7),
              offset: const Offset(0, 2.5),
              blurRadius: 0,
            ),
            const BoxShadow(
              color: Color(0x081E2337),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
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
                if (dish.hasBroth) ...[
                  BrothToggleChip(
                    hasBroth: dish.hasBroth,
                    includeBroth: dish.includeBroth,
                    brothCalories: dish.brothCalories,
                    brothSodiumMg: dish.brothSodiumMg,
                    onToggle: onBrothToggle ?? (_) {},
                  ),
                ],
                if (dish.subItems.isNotEmpty) ...[
                  ToppingChecklistWrap(
                    subItems: dish.subItems,
                    onToggleSubItem: onSubItemToggle ?? (_, __) {},
                  ),
                ],
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
    this.ratio = 0.0,
  });

  final String label;
  final String value;
  final Color color;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final percent = (ratio * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing8,
        vertical: AppValues.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              if (percent > 0) ...[
                const SizedBox(width: AppValues.spacing4),
                Text(
                  '($percent%)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppValues.spacing8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppValues.spacing48),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: AppColors.outline.withValues(alpha: 0.35),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalorieTargetRadialGauge extends StatelessWidget {
  const _CalorieTargetRadialGauge({required this.calories, required this.targetCalories});

  final int calories;
  final int targetCalories;

  @override
  Widget build(BuildContext context) {
    final percent = targetCalories > 0
        ? ((calories / targetCalories) * 100).clamp(0, 100).toInt()
        : 0;
    final progressRatio = (percent / 100.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing12,
        vertical: AppValues.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progressRatio,
                  backgroundColor: AppColors.outline.withValues(alpha: 0.35),
                  color: AppColors.primary,
                  strokeWidth: 3.5,
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppValues.spacing8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mục tiêu',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '${targetCalories.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} kcal',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickReviewWeightChip extends StatelessWidget {
  const _QuickReviewWeightChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? const Color(0xFFE0F2FE)
          : AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radius12),
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : AppColors.outline.withValues(alpha: 0.5),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        child: Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 36),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.spacing12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.radius12),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: Color(0xFFBAE6FD),
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tactile Ceramic Clay Button for Re-scan and secondary actions.
class _TactileActionButton extends StatefulWidget {
  const _TactileActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 24.0,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;

  @override
  State<_TactileActionButton> createState() => _TactileActionButtonState();
}

class _TactileActionButtonState extends State<_TactileActionButton> {
  bool _isPressed = false;
  static const double _buttonSize = 48.0;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.0;
    final downShift = _isPressed ? 2.0 : 0.0;

    Widget btn = GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, downShift, 0),
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.onPressed != null ? Colors.white : const Color(0xFFF3F0EA),
          border: Border.all(
            color: const Color(0xFFE2DDD5),
            width: 1.2,
          ),
          boxShadow: widget.onPressed != null
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4CEBF),
                    offset: Offset(0, _isPressed ? 1.0 : bevelDepth),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0x101E2337),
                    offset: Offset(0, _isPressed ? 2.0 : 5.0),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.onPressed != null
                ? AppColors.onSurface
                : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      btn = Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}

