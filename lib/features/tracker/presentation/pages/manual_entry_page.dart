import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/tracker/data/datasources/common_foods_dataset.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
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
      backgroundColor: Colors.transparent,
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClayIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            size: 38,
            borderRadius: 12,
            onPressed: () => context.router.popForced(),
          ),
        ),
        title: Text(
          AppStrings.manualEntry,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: ClayIconButton(
              tooltip: 'Công thức của tôi',
              icon: Icons.menu_book_rounded,
              size: 38,
              borderRadius: 12,
              iconColor: AppColors.primary,
              onPressed: () => context.router.push(const RecipesRoute()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ClayIconButton(
              tooltip: 'Thêm món tùy chỉnh',
              icon: Icons.add_rounded,
              size: 38,
              borderRadius: 12,
              iconColor: AppColors.brandGreen,
              onPressed: _openCustomFoodSheet,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppValues.screenPadding,
            AppValues.spacing8,
            AppValues.screenPadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Search Bar
              FoodSearchBar(onChanged: (q) => setState(() => _query = q)),
              const SizedBox(height: AppValues.spacing12),

              // 2. Recent & Favorite Foods Tray (US-01 / 1-Tap populate)
              Row(
                children: [
                  const Icon(Icons.history_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: AppValues.spacing4),
                  Text(
                    'Món gần đây:',
                    style: GoogleFonts.outfit(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: _defaultRecentFoods.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppValues.spacing8),
                  itemBuilder: (context, index) {
                    final item = _defaultRecentFoods[index];
                    final isSelected = _selectedItem?.name == item.name;
                    return _RecentFoodChip(
                      item: item,
                      isSelected: isSelected,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _selectFood(item);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppValues.spacing12),

              // 3. Selected Food Scaling Card (if item selected)
              if (_selectedItem != null) ...[
                ClayCard(
                  padding: const EdgeInsets.all(AppValues.spacing16),
                  borderRadius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header: Food Name & 3D Calorie Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedItem!.name,
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF0369A1),
                                  offset: Offset(0, 2.5),
                                  blurRadius: 0,
                                ),
                                BoxShadow(
                                  color: Color(0x300284C7),
                                  offset: Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              '${_selectedItem!.calculateCalories(_currentWeightG)} kcal',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.5,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing12),

                      // Celestial Macro Pillars
                      Row(
                        children: [
                          Expanded(
                            child: _MacroStat(
                              label: 'Tinh bột',
                              value: '${_selectedItem!.calculateCarbs(_currentWeightG)}g',
                              color: AppColors.primary,
                              bgColor: const Color(0xFFF0F9FF),
                              borderColor: const Color(0xFFBAE6FD),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MacroStat(
                              label: 'Chất đạm',
                              value: '${_selectedItem!.calculateProtein(_currentWeightG)}g',
                              color: AppColors.tertiary,
                              bgColor: const Color(0xFFFFF8ED),
                              borderColor: const Color(0xFFFFE2B3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MacroStat(
                              label: 'Chất béo',
                              value: '${_selectedItem!.calculateFat(_currentWeightG)}g',
                              color: AppColors.secondary,
                              bgColor: const Color(0xFFFFF1F5),
                              borderColor: const Color(0xFFFECDD3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing12),

                      // Quick Weight Steppers (US-02)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                      const SizedBox(height: AppValues.spacing8),

                      // Weight Slider
                      Row(
                        children: [
                          Text(
                            '50g',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 6,
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor: const Color(0xFFE5E0D8),
                                thumbColor: Colors.white,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10,
                                  elevation: 3,
                                  pressedElevation: 5,
                                ),
                                overlayColor: AppColors.primary.withValues(alpha: 0.15),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                            ),
                            child: Text(
                              '${_currentWeightG}g',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.spacing12),
              ],

              // 4. Header for list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Món ăn phổ biến (${filtered.length})',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openCustomFoodSheet,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    icon: const Icon(Icons.edit_note_rounded, size: 20),
                    label: Text(
                      'Tự nhập món',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing4),

              // 5. Food List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.onSurfaceVariant),
                            const SizedBox(height: AppValues.spacing8),
                            Text(
                              'Không tìm thấy món "$_query"',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppValues.spacing12),
                            ClayButton(
                              text: 'Nhập món này thủ công',
                              width: 220,
                              height: 44,
                              onPressed: _openCustomFoodSheet,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final item = filtered[i];
                          final isSelected = _selectedItem?.name == item.name;

                          return _FoodListItemTile(
                            item: item,
                            isSelected: isSelected,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              _selectFood(item);
                            },
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
          AppValues.spacing12,
          AppValues.screenPadding,
          AppValues.spacing16,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x121E2337),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
          border: const Border(
            top: BorderSide(
              color: AppColors.outline,
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

              // Sticky Save CTA Button (52pt)
              ClayButton(
                width: double.infinity,
                height: 52,
                isLoading: _isSaving,
                onPressed: (_isSaving || _selectedItem == null) ? null : _saveSelectedItem,
                icon: const Icon(Icons.bookmark_add_rounded, color: Colors.white, size: 20),
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

  static IconData getFoodIcon(String name) {
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

/// Tactile Food List Item Tile
class _FoodListItemTile extends StatelessWidget {
  const _FoodListItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final CommonFoodItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: AppValues.spacing8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFAFDFF) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E0D8),
            width: isSelected ? 1.8 : 1.2,
          ),
          boxShadow: [
            // 3D bottom bevel
            BoxShadow(
              color: isSelected ? const Color(0x351CB0F6) : const Color(0xFFD4CEBF),
              offset: const Offset(0, 2.5),
              blurRadius: 0,
            ),
            // Ambient shadow
            BoxShadow(
              color: isSelected ? const Color(0x181CB0F6) : const Color(0x081E2337),
              offset: const Offset(0, 3),
              blurRadius: isSelected ? 8 : 4,
            ),
          ],
        ),
        child: Row(
          children: [
            // Food Avatar Circle
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFFE0F2FE) : const Color(0xFFF4F1EA),
                border: Border.all(
                  color: isSelected ? const Color(0xFFBAE6FD) : const Color(0xFFE5E0D8),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                _ManualEntryPageState.getFoodIcon(item.name),
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                size: 22,
              ),
            ),
            const SizedBox(width: AppValues.spacing12),

            // Food Title & Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.baseWeightG}g • ${item.baseCalories} kcal (P:${item.baseProteinG}g C:${item.baseCarbsG}g F:${item.baseFatG}g)',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Status Action
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tactile Macro Stat Capsule
class _MacroStat extends StatelessWidget {
  const _MacroStat({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            offset: Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 16.5,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tactile Quick Weight Chip
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        constraints: const BoxConstraints(minWidth: 44, minHeight: 34),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing12,
          vertical: AppValues.spacing4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2FE) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E0D8),
            width: isSelected ? 1.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0x351CB0F6) : const Color(0xFFD4CEBF),
              offset: const Offset(0, 2.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.primary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Tactile Recent Food Chip
class _RecentFoodChip extends StatelessWidget {
  const _RecentFoodChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final CommonFoodItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE5E0D8),
              width: isSelected ? 1.5 : 1.2,
            ),
            boxShadow: [
              // 3D bottom bevel
              BoxShadow(
                color: isSelected ? const Color(0xFF0369A1) : const Color(0xFFD4CEBF),
                offset: const Offset(0, 2.5),
                blurRadius: 0,
              ),
              if (isSelected)
                const BoxShadow(
                  color: Color(0x301CB0F6),
                  offset: Offset(0, 3),
                  blurRadius: 8,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🍽️', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 5),
              Text(
                '${item.name} (${item.baseCalories}k)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.onSurface,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
