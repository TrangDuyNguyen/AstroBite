import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/scanner/domain/entities/scan_result.dart';
import 'package:astrobite/features/scanner/domain/usecases/scan_food_usecase.dart';
import 'package:astrobite/features/scanner/presentation/controllers/scanner_controller.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../widgets/scan_dish_item_card.dart';
import '../widgets/scan_portion_card.dart';
import '../widgets/scan_quick_add_sheet.dart';
import '../widgets/scan_review_action_bar.dart';
import '../widgets/scan_review_hero_card.dart';
import '../widgets/scan_title_badge.dart';

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
              ScanTitleBadge(dishes: _dishes, scaled: scaled),
              const SizedBox(height: AppValues.spacing16),
              ScanReviewHeroCard(scaled: scaled, effectiveWeight: effectiveWeight),
              const SizedBox(height: AppValues.spacing20),

              if (_dishes.length <= 1)
                ScanPortionCard(
                  effectiveWeight: effectiveWeight,
                  onWeightChanged: (w) => setState(() => _currentWeightG = w),
                  dishes: _dishes,
                  onBrothToggle: (val) => setState(() => _dishes.first.includeBroth = val),
                  onSubItemToggle: (idx, isSel) => setState(() => _dishes.first.subItems[idx].isSelected = isSel),
                ),

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
                      onPressed: () => ScanQuickAddSheet.show(
                        context,
                        onAdd: (DishItem d) => setState(() => _dishes.add(d)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppValues.spacing8),
                ...List.generate(_dishes.length, (idx) {
                  final dish = _dishes[idx];
                  return ScanDishItemCard(
                    dish: dish,
                    onToggle: (val) => setState(() => dish.isSelected = val ?? true),
                    onBrothToggle: (val) => setState(() => dish.includeBroth = val),
                    onSubItemToggle: (subIdx, isSel) => setState(() => dish.subItems[subIdx].isSelected = isSel),
                    onWeightChanged: (newWeight) => setState(() {
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
                    }),
                    onRemove: () => setState(() => _dishes.removeAt(idx)),
                  );
                }),
                const SizedBox(height: AppValues.spacing16),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: ScanReviewActionBar(
        selectedMeal: _selectedMeal,
        onMealSelected: (m) => setState(() => _selectedMeal = m),
        onRescan: () => context.router.popForced(),
        onSave: () => _saveFoodLog(scaled),
        isSaving: _isSaving,
        scaled: scaled,
        mealLabel: _mealLabel,
      ),
    );
  }
}
