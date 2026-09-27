import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/tracker/data/datasources/common_foods_dataset.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../widgets/custom_food_sheet.dart';
import '../widgets/food_search_bar.dart';

@RoutePage()
class ManualEntryPage extends ConsumerStatefulWidget {
  const ManualEntryPage({
    super.key,
    this.initialMealType,
  });

  final String? initialMealType;

  @override
  ConsumerState<ManualEntryPage> createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends ConsumerState<ManualEntryPage> {
  late String _selectedMeal;
  String _query = '';
  CommonFoodItem? _selectedItem;
  int _currentWeightG = 100;
  bool _isSaving = false;

  static String _defaultMealType() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'breakfast';
    if (hour >= 11 && hour < 16) return 'lunch';
    if (hour >= 16 && hour < 21) return 'dinner';
    return 'snack';
  }

  static final List<CommonFoodItem> _defaultRecentFoods = [
    if (commonVietnameseFoods.isNotEmpty) commonVietnameseFoods[0], // Phở bò
    if (commonVietnameseFoods.length > 2) commonVietnameseFoods[2], // Cơm tấm sườn
    if (commonVietnameseFoods.length > 4) commonVietnameseFoods[4], // Bún chả Hà Nội
    if (commonVietnameseFoods.length > 9) commonVietnameseFoods[9], // Ức gà áp chảo
  ];

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
    _selectedMeal = widget.initialMealType ?? _defaultMealType();
    if (commonVietnameseFoods.isNotEmpty) {
      _selectedItem = commonVietnameseFoods.first;
      _currentWeightG = commonVietnameseFoods.first.baseWeightG;
    }
  }

  void _selectFood(CommonFoodItem item) {
    setState(() {
      _selectedItem = item;
      _currentWeightG = item.baseWeightG;
    });
  }

  Future<void> _saveFoodLog(FoodLogDto log) async {
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
      final logWithDate = log.copyWith(
        date: ref.read(todayDateProvider),
        mealType: _selectedMeal,
      );

      await ref.read(foodLogRepositoryProvider).addFoodLog(
            userId: user.uid,
            log: logWithDate,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã lưu ${log.dishName} vào ${_mealLabel(_selectedMeal)}!',
            ),
          ),
        );
        if (context.router.canPop()) {
          context.router.popForced();
        }
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

  void _saveSelectedItem() {
    if (_selectedItem == null) return;
    final item = _selectedItem!;
    final log = FoodLogDto(
      id: '',
      date: ref.read(todayDateProvider),
      mealType: _selectedMeal,
      dishName: item.name,
      estimatedWeightG: _currentWeightG,
      calories: item.calculateCalories(_currentWeightG),
      proteinG: item.calculateProtein(_currentWeightG),
      carbsG: item.calculateCarbs(_currentWeightG),
      fatG: item.calculateFat(_currentWeightG),
      source: 'manual_entry',
      confidenceScore: 1.0,
    );
    _saveFoodLog(log);
  }

  void _openCustomFoodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.cardRadius)),
      ),
      builder: (_) => CustomFoodSheet(
        selectedMeal: _selectedMeal,
        onSave: _saveFoodLog,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? commonVietnameseFoods
        : commonVietnameseFoods
            .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.manualEntry),
        actions: [
          IconButton(
            tooltip: 'Công thức của tôi',
            icon: const Icon(Icons.menu_book_rounded),
            onPressed: () => context.router.push(const RecipesRoute()),
          ),
          IconButton(
            tooltip: 'Thêm món tùy chỉnh',
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _openCustomFoodSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              FoodSearchBar(onChanged: (q) => setState(() => _query = q)),
              const SizedBox(height: AppValues.spacing8),

              // Recent & Favorite Foods Tray (US-01 / 1-Tap populate)
              Row(
                children: [
                  const Icon(Icons.history, size: 16, color: AppColors.primary),
                  const SizedBox(width: AppValues.spacing4),
                  Text(
                    'Món gần đây:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing4),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _defaultRecentFoods.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppValues.spacing8),
                  itemBuilder: (context, index) {
                    final item = _defaultRecentFoods[index];
                    final isSelected = _selectedItem?.name == item.name;
                    return ActionChip(
                      avatar: const Text('🍽️', style: TextStyle(fontSize: 12)),
                      label: Text(
                        '${item.name} (${item.baseCalories}k)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : AppColors.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.outline.withValues(alpha: 0.3),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        _selectFood(item);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppValues.spacing12),

              // Selected Food Scaling Card (if item selected)
              if (_selectedItem != null) ...[
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedItem!.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppValues.radius8),
                            ),
                            child: Text(
                              '${_selectedItem!.calculateCalories(_currentWeightG)} kcal',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing8),

                      // Celestial Dark Nutrient Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MacroStat(
                            label: 'Tinh bột',
                            value: '${_selectedItem!.calculateCarbs(_currentWeightG)}g',
                            color: AppColors.primary, // #1A73E8
                          ),
                          _MacroStat(
                            label: 'Chất đạm',
                            value: '${_selectedItem!.calculateProtein(_currentWeightG)}g',
                            color: AppColors.tertiary, // #FFD700
                          ),
                          _MacroStat(
                            label: 'Chất béo',
                            value: '${_selectedItem!.calculateFat(_currentWeightG)}g',
                            color: AppColors.secondary, // #FF69B4
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing8),

                      // Quick Weight Steppers (US-02)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _QuickWeightChip(
                              label: '-50g',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _currentWeightG = (_currentWeightG - 50).clamp(50, 1000);
                                });
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickWeightChip(
                              label: '+50g',
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _currentWeightG = (_currentWeightG + 50).clamp(50, 1000);
                                });
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickWeightChip(
                              label: '1 Bát (~150g)',
                              isSelected: _currentWeightG == 150,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _currentWeightG = 150);
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickWeightChip(
                              label: '1 Đĩa (~300g)',
                              isSelected: _currentWeightG == 300,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _currentWeightG = 300);
                              },
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            _QuickWeightChip(
                              label: 'Chuẩn (~100g)',
                              isSelected: _currentWeightG == 100,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _currentWeightG = 100);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppValues.spacing4),

                      // Slider
                      Row(
                        children: [
                          const Text('50g', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor: AppColors.outline.withValues(alpha: 0.3),
                                thumbColor: AppColors.primary,
                              ),
                              child: Slider(
                                value: _currentWeightG.toDouble().clamp(50.0, 1000.0),
                                min: 50.0,
                                max: 1000.0,
                                divisions: 95,
                                label: '$_currentWeightG g',
                                onChanged: (val) {
                                  HapticFeedback.selectionClick();
                                  setState(() => _currentWeightG = val.round());
                                },
                              ),
                            ),
                          ),
                          Text('${_currentWeightG}g',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.spacing12),
              ],

              // Header for list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Món ăn phổ biến (${filtered.length})',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: _openCustomFoodSheet,
                    icon: const Icon(Icons.edit_note, size: 18),
                    label: const Text('Tự nhập món'),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing4),

              // Food List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 48, color: AppColors.onSurfaceVariant),
                            const SizedBox(height: AppValues.spacing8),
                            Text('Không tìm thấy món "$_query"'),
                            const SizedBox(height: AppValues.spacing8),
                            FilledButton.tonal(
                              onPressed: _openCustomFoodSheet,
                              child: const Text('Nhập món này thủ công'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final item = filtered[i];
                          final isSelected = _selectedItem?.name == item.name;

                          return Card(
                            color: isSelected
                                ? AppColors.surfaceContainer.withValues(alpha: 0.9)
                                : AppColors.surfaceContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppValues.radius8),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.outline.withValues(alpha: 0.15),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            margin: const EdgeInsets.only(bottom: AppValues.spacing8),
                            child: ListTile(
                              onTap: () => _selectFood(item),
                              leading: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(AppValues.radius8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary.withValues(alpha: 0.5)
                                        : AppColors.outline.withValues(alpha: 0.2),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  _getFoodIcon(item.name),
                                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                '${item.baseWeightG}g • ${item.baseCalories} kcal (P:${item.baseProteinG}g C:${item.baseCarbsG}g F:${item.baseFatG}g)',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                  color: isSelected ? AppColors.primary : null,
                                ),
                                onPressed: () => _selectFood(item),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppValues.screenPadding,
          AppValues.spacing8,
          AppValues.screenPadding,
          AppValues.spacing12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: AppColors.outline.withValues(alpha: 0.2),
              width: 1,
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
              const SizedBox(height: AppValues.spacing8),
              // Sticky Save CTA Button (52pt)
              ClayButton(
                width: double.infinity,
                height: 50,
                isLoading: _isSaving,
                onPressed: (_isSaving || _selectedItem == null) ? null : _saveSelectedItem,
                icon: const Icon(Icons.bookmark_add_outlined, color: Colors.white, size: 20),
                text: _isSaving
                    ? 'Đang lưu...'
                    : 'Lưu vào ${_mealLabel(_selectedMeal)} (${_selectedItem != null ? _selectedItem!.calculateCalories(_currentWeightG) : 0} kcal)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _getFoodIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('phở') ||
        lower.contains('bún') ||
        lower.contains('hủ tiếu') ||
        lower.contains('miến') ||
        lower.contains('mì')) {
      return Icons.ramen_dining_rounded;
    }
    if (lower.contains('cơm') || lower.contains('xôi')) {
      return Icons.rice_bowl_rounded;
    }
    if (lower.contains('bánh')) {
      return Icons.bakery_dining_rounded;
    }
    if (lower.contains('bò') ||
        lower.contains('gà') ||
        lower.contains('thịt') ||
        lower.contains('heo') ||
        lower.contains('sườn')) {
      return Icons.kebab_dining_rounded;
    }
    if (lower.contains('cá') || lower.contains('tôm') || lower.contains('hải sản')) {
      return Icons.set_meal_rounded;
    }
    if (lower.contains('trứng')) {
      return Icons.egg_alt_outlined;
    }
    if (lower.contains('salad') || lower.contains('rau') || lower.contains('canh')) {
      return Icons.eco_rounded;
    }
    if (lower.contains('sữa') || lower.contains('cà phê') || lower.contains('trà')) {
      return Icons.local_cafe_rounded;
    }
    return Icons.restaurant_rounded;
  }
}

class _MacroStat extends StatelessWidget {
  const _MacroStat({
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
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}

class _QuickWeightChip extends StatelessWidget {
  const _QuickWeightChip({
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
          ? AppColors.primary.withValues(alpha: 0.25)
          : AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.radius8),
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : AppColors.outline.withValues(alpha: 0.25),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppValues.radius8),
        child: Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 36),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.spacing12,
            vertical: AppValues.spacing4,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

