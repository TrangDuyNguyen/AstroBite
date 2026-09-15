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
    }
  }

  ScanResult? _resolveFromProvider() {
    final scanState = ref.read(scannerControllerProvider);
    if (scanState.value is ScanSuccess) {
      return (scanState.value as ScanSuccess).result;
    }
    return null;
  }

  Future<void> _saveFoodLog(ScanResult scaled) async {
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
      final log = FoodLogDto(
        id: '',
        date: ref.read(todayDateProvider),
        mealType: _selectedMeal,
        dishName: scaled.primaryDishName,
        estimatedWeightG: _currentWeightG,
        calories: scaled.totalCalories,
        proteinG: scaled.proteinG,
        carbsG: scaled.carbsG,
        fatG: scaled.fatG,
        source: 'ai_scan',
        confidenceScore: scaled.primaryConfidenceScore,
        imageUrl: null,
      );

      await ref.read(foodLogRepositoryProvider).addFoodLog(
            userId: user.uid,
            log: log,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã lưu ${scaled.primaryDishName} vào ${_mealLabel(_selectedMeal)}!',
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

    // Dynamic scaled calculation
    final effectiveWeight = _currentWeightG > 0
        ? _currentWeightG
        : (baseResult.totalWeightG > 0 ? baseResult.totalWeightG : 350);
    final scaled = baseResult.scaleToWeight(effectiveWeight);

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
                      '${scaled.totalCalories} kcal',
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
                          value: '${scaled.carbsG}g',
                          color: AppColors.primary, // #1A73E8
                        ),
                        _MacroIndicator(
                          label: 'Chất đạm',
                          value: '${scaled.proteinG}g',
                          color: AppColors.tertiary, // #FFD700
                        ),
                        _MacroIndicator(
                          label: 'Chất béo',
                          value: '${scaled.fatG}g',
                          color: AppColors.secondary, // #FF69B4
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppValues.spacing24),

              // COMP-03: Portion Adjustment Slider
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

              // Dishes segment detail if multiple dishes identified
              if (scaled.dishes.length > 1) ...[
                Text(
                  'Thành phần nhận diện (${scaled.dishes.length} món)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppValues.spacing8),
                ...scaled.dishes.map(
                  (dish) => Card(
                    margin: const EdgeInsets.only(bottom: AppValues.spacing8),
                    color: AppColors.surfaceContainer,
                    child: ListTile(
                      title: Text(dish.dishName),
                      subtitle: Text('${dish.estimatedWeightG}g'),
                      trailing: Text(
                        '${dish.calories} kcal',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
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
                            : 'Lưu vào ${_mealLabel(_selectedMeal)} (${scaled.totalCalories} kcal)',
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
