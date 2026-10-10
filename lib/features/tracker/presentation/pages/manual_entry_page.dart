import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/tracker/data/datasources/common_foods_dataset.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/widgets/food_list_item_tile.dart';
import 'package:astrobite/features/tracker/presentation/widgets/food_portion_card.dart';
import 'package:astrobite/features/tracker/presentation/widgets/manual_entry_bottom_bar.dart';
import 'package:astrobite/features/tracker/presentation/widgets/recent_foods_tray.dart';

import 'package:astrobite/features/voice/presentation/widgets/astro_voice_sheet.dart';
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
  late MealType _selectedMeal;
  String _query = '';
  CommonFoodItem? _selectedItem;
  int _currentWeightG = 100;
  bool _isSaving = false;

  static final List<CommonFoodItem> _defaultRecentFoods = [
    if (commonVietnameseFoods.isNotEmpty) commonVietnameseFoods[0], // Phở bò
    if (commonVietnameseFoods.length > 2) commonVietnameseFoods[2], // Cơm tấm sườn
    if (commonVietnameseFoods.length > 4) commonVietnameseFoods[4], // Bún chả Hà Nội
    if (commonVietnameseFoods.length > 9) commonVietnameseFoods[9], // Ức gà áp chảo
  ];

  @override
  void initState() {
    super.initState();
    _selectedMeal = widget.initialMealType != null
        ? MealType.fromValue(widget.initialMealType)
        : MealType.fromCurrentHour();
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
          SnackBar(content: Text(context.l10n.loginToSaveLog)),
        );
        setState(() => _isSaving = false);
      }
      return;
    }

    try {
      final logWithDate = log.copyWith(
        date: ref.read(todayDateProvider),
        mealType: _selectedMeal.value,
      );

      await ref.read(foodLogRepositoryProvider).addFoodLog(
            userId: user.uid,
            log: logWithDate,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.savedFoodToMeal(
                log.dishName,
                _selectedMeal.localizedLabel(context),
              ),
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
          SnackBar(content: Text(context.l10n.errorSavingLog(e.toString()))),
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
      mealType: _selectedMeal.value,
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
        selectedMeal: _selectedMeal.value,
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
          context.l10n.manualEntry,
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
              tooltip: context.l10n.myRecipes,
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
              tooltip: context.l10n.addCustomDish,
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
              // 1. Search Bar with AstroVoice
              Row(
                children: [
                  Expanded(
                    child: FoodSearchBar(onChanged: (q) => setState(() => _query = q)),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  ClayIconButton(
                    icon: Icons.mic_rounded,
                    iconColor: AppColors.primary,
                    onPressed: () => AstroVoiceSheet.show(context),
                  ),
                ],
              ),
              const SizedBox(height: AppValues.spacing12),

              // 2. Recent Foods Tray
              RecentFoodsTray(
                recentFoods: _defaultRecentFoods,
                selectedItem: _selectedItem,
                onSelectFood: _selectFood,
              ),
              const SizedBox(height: AppValues.spacing12),

              // 3. Portion Card
              if (_selectedItem != null) ...[
                FoodPortionCard(
                  item: _selectedItem!,
                  currentWeightG: _currentWeightG,
                  onWeightChanged: (w) => setState(() => _currentWeightG = w),
                ),
                const SizedBox(height: AppValues.spacing12),
              ],

              // 4. Header for list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.popularFoods(filtered.length),
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
                      context.l10n.customFoodEntry,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
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
                              context.l10n.noFoodFound(_query),
                              style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: AppValues.spacing12),
                            ClayButton(
                              text: context.l10n.enterThisFoodManually,
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

                          return FoodListItemTile(
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
      bottomNavigationBar: ManualEntryBottomBar(
        selectedMeal: _selectedMeal,
        onMealChanged: (m) => setState(() => _selectedMeal = m),
        isSaving: _isSaving,
        canSave: _selectedItem != null,
        onSave: _saveSelectedItem,
        totalCalories: _selectedItem != null ? _selectedItem!.calculateCalories(_currentWeightG) : 0,
      ),
    );
  }
}

