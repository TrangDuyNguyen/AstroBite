import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/controllers/tracker_controller.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

@RoutePage()
class MealDetailPage extends ConsumerWidget {
  const MealDetailPage({
    super.key,
    this.mealType = 'lunch',
  });

  final String mealType;

  String get _mealTitle => switch (mealType) {
        'breakfast' => AppStrings.breakfast,
        'lunch' => AppStrings.lunch,
        'dinner' => AppStrings.dinner,
        'snack' => AppStrings.snack,
        _ => mealType,
      };

  Color get _mealTint => switch (mealType) {
        'breakfast' => AppColors.clayBreakfast,
        'lunch' => AppColors.clayLunch,
        'dinner' => AppColors.clayDinner,
        'snack' => AppColors.claySnack,
        _ => AppColors.surfaceContainer,
      };

  IconData get _mealIcon => switch (mealType) {
        'breakfast' => Icons.wb_twilight_rounded,
        'lunch' => Icons.wb_sunny_rounded,
        'dinner' => Icons.nightlight_round,
        'snack' => Icons.apple_rounded,
        _ => Icons.restaurant_rounded,
      };

  Future<bool?> _showDeleteConfirmation(BuildContext context, String dishName) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.outline, width: 1.2),
        ),
        title: const Text(
          AppStrings.confirmDelete,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa món "$dishName" khỏi bữa ăn này không?',
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);
    final logs = summary.getMealLogs(mealType);
    final totalCalories = summary.getMealCalories(mealType);
    final totalCarbs = summary.getMealCarbs(mealType);
    final totalProtein = summary.getMealProtein(mealType);
    final totalFat = summary.getMealFat(mealType);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ClayIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () => context.router.maybePop(),
          ),
        ),
        title: Text(
          _mealTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ClayIconButton(
              icon: Icons.add_rounded,
              iconColor: AppColors.primary,
              onPressed: () => context.router.push(
                ManualEntryRoute(initialMealType: mealType),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          children: [
            // 1. Header Overview Card
            ClayCard(
              backgroundColor: _mealTint,
              padding: const EdgeInsets.all(AppValues.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(_mealIcon, color: AppColors.primary, size: 24),
                          const SizedBox(width: AppValues.spacing8),
                          Text(
                            'Tổng quan dinh dưỡng',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '$totalCalories kcal',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppValues.spacing12),
                  // 3 Macro distribution
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MacroPill(
                        label: AppStrings.carbs,
                        grams: totalCarbs,
                        color: AppColors.primary,
                      ),
                      _MacroPill(
                        label: AppStrings.fat,
                        grams: totalFat,
                        color: AppColors.secondary,
                      ),
                      _MacroPill(
                        label: AppStrings.protein,
                        grams: totalProtein,
                        color: AppColors.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.spacing16),

            // 2. Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách món ăn (${logs.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                ),
                Text(
                  'Gạt sang để quản lý',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing8),

            // 3. Food items or Empty State
            if (logs.isEmpty)
              ClayCard(
                padding: const EdgeInsets.all(AppValues.spacing24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lunch_dining_outlined,
                      size: 48,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppValues.spacing12),
                    Text(
                      'Chưa có món ăn nào trong $_mealTitle',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppValues.spacing4),
                    const Text(
                      'Hãy thêm món để theo dõi calo và macro nhé!',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    ClayButton(
                      text: 'Thêm món ngay',
                      icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                      onPressed: () => context.router.push(
                        ManualEntryRoute(initialMealType: mealType),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...logs.map((log) => _MealFoodCard(
                    log: log,
                    onDelete: () async {
                      final confirmed = await _showDeleteConfirmation(
                        context,
                        log.dishName,
                      );
                      if (confirmed == true) {
                        final user = ref.read(authRepositoryProvider).currentUser;
                        if (user != null) {
                          await ref
                              .read(trackerControllerProvider.notifier)
                              .deleteFoodLog(
                                userId: user.uid,
                                logId: log.id,
                              );
                        }
                      }
                    },
                  )),

            const SizedBox(height: AppValues.spacing24),
            // Bottom Action
            ClayButton(
              text: 'Thêm món vào $_mealTitle',
              icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 20),
              onPressed: () => context.router.push(
                ManualEntryRoute(initialMealType: mealType),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.grams,
    required this.color,
  });

  final String label;
  final int grams;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${grams}g',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealFoodCard extends StatelessWidget {
  const _MealFoodCard({
    required this.log,
    required this.onDelete,
  });

  final FoodLog log;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacing12),
      child: ClayCard(
        padding: const EdgeInsets.all(AppValues.spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Dish Icon Container
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppValues.spacing12),

            // Middle: Name, weight, calories, mini macro
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.dishName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${log.estimatedWeightG}g • ${log.calories} kcal',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Mini macro preview
                      Text(
                        'C:${log.carbsG} F:${log.fatG} P:${log.proteinG}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right Delete Button
            ClayIconButton(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
