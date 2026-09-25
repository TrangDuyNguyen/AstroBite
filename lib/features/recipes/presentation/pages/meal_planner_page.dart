import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import 'package:astrobite/shared/widgets/meal_type_chip.dart';
import 'package:astrobite/shared/widgets/skeleton_loader.dart';
import '../../domain/entities/meal_plan_item.dart';
import '../controllers/meal_plan_controller.dart';

@RoutePage()
class MealPlannerPage extends ConsumerWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Kế Hoạch Bữa Ăn'),
      ),
      body: Column(
        children: [
          // ── Day strip (7 days) ───────────────────────────────────────
          const _DayStrip(),
          const SizedBox(height: AppValues.spacing8),
          // ── Meal slots ───────────────────────────────────────────────
          const Expanded(child: _MealSlots()),
        ],
      ),
    );
  }
}

// ── Day Strip ─────────────────────────────────────────────────────────────────

class _DayStrip extends ConsumerWidget {
  const _DayStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedPlanDateProvider);
    final today = DateTime.now();

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: AppValues.spacing8),
        itemBuilder: (context, i) {
          final day = today.add(Duration(days: i));
          final iso = _toIso(day);
          final isSelected = iso == selectedDate;

          return GestureDetector(
            onTap: () =>
                ref.read(selectedPlanDateProvider.notifier).state = iso,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppValues.radius12),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekday(day),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppValues.spacing4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _toIso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _weekday(DateTime d) => const [
        'CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'
      ][d.weekday % 7];
}

// ── Meal Slots ────────────────────────────────────────────────────────────────

const _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

class _MealSlots extends ConsumerWidget {
  const _MealSlots();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedPlanDateProvider);
    // ponytail: userId bridge — upgrade with real auth provider
    const userId = '';
    final key = (userId: userId, date: date);
    final itemsAsync = ref.watch(mealPlanItemsProvider(key));

    return itemsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        children: List.generate(4, (_) => const SkeletonLoader(height: 80)),
      ),
      error: (e, _) => Center(
        child: Text('Lỗi: $e', style: const TextStyle(color: AppColors.error)),
      ),
      data: (items) => ListView(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        children: _mealTypes
            .map(
              (type) => _MealSection(
                mealType: type,
                items: items.where((i) => i.mealType == type).toList(),
                date: date,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  const _MealSection({
    required this.mealType,
    required this.items,
    required this.date,
  });

  final String mealType;
  final List<MealPlanItem> items;
  final String date;

  String get _label => switch (mealType) {
        'breakfast' => 'Bữa Sáng',
        'lunch' => 'Bữa Trưa',
        'dinner' => 'Bữa Tối',
        'snack' => 'Bữa Phụ',
        _ => mealType,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MealTypeChip(
                mealType: mealType,
                isSelected: false,
                onTap: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                tooltip: 'Thêm vào $_label',
                onPressed: () {
                  // ponytail: recipe picker bottom sheet — ceiling for next iteration
                  // upgrade path: showModalBottomSheet with RecipePickerSheet
                },
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing8),
          if (items.isEmpty)
            _EmptySlot(label: _label)
          else
            ...items.map((item) => _MealItemCard(item: item)),
        ],
      ),
    );
  }
}

class _MealItemCard extends ConsumerWidget {
  const _MealItemCard({required this.item});

  final MealPlanItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      borderColor: item.isLogged ? AppColors.success.withValues(alpha: 0.5) : null,
      padding: const EdgeInsets.all(AppValues.spacing12),
      child: Row(
        children: [
          // Name + macros
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodName,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppValues.spacing4),
                Text(
                  '${item.calories.round()} kcal  •  '
                  'C ${item.carbs.round()}g  '
                  'P ${item.protein.round()}g  '
                  'F ${item.fat.round()}g',
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // 1-Tap Log button
          if (!item.isLogged)
            InkWell(
              borderRadius: BorderRadius.circular(AppValues.radius8),
              onTap: () => _log(context, ref),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.spacing12,
                  vertical: AppValues.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppValues.radius8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
                child: const Text(
                  '✓ Ghi Nhật Ký',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.spacing8,
                vertical: AppValues.spacing4,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppValues.radius8),
              ),
              child: const Text(
                '✓ Đã Ăn',
                style: TextStyle(color: AppColors.success, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _log(BuildContext context, WidgetRef ref) async {
    const userId = ''; // ponytail: upgrade with real auth provider
    await ref.read(mealPlanControllerProvider.notifier).logMealToDiary(
          userId: userId,
          item: item,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ ${item.foodName} đã được ghi vào nhật ký!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppValues.spacing12),
      child: Text(
        'Chưa có món nào cho $label. Nhấn + để thêm.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
      ),
    );
  }
}
