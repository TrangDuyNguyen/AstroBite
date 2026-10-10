import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/controllers/tracker_controller.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../widgets/meal_detail_components/meal_detail_empty_state.dart';
import '../widgets/meal_detail_components/meal_detail_food_card.dart';
import '../widgets/meal_detail_components/meal_detail_overview_card.dart';

@RoutePage()
class MealDetailPage extends ConsumerWidget {
  const MealDetailPage({
    super.key,
    this.mealType = 'lunch',
  });

  final String mealType;

  String _mealTitle(BuildContext context) => switch (mealType) {
        'breakfast' => context.l10n.breakfast,
        'lunch' => context.l10n.lunch,
        'dinner' => context.l10n.dinner,
        'snack' => context.l10n.snack,
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
        title: Text(
          ctx.l10n.confirmDelete,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa món "$dishName" khỏi bữa ăn này không?',
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              ctx.l10n.cancel,
              style: const TextStyle(color: AppColors.onSurfaceVariant),
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
            child: Text(ctx.l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);
    final logs = summary.getMealLogs(mealType);

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
          _mealTitle(context),
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
            MealDetailOverviewCard(
              mealTint: _mealTint,
              mealIcon: _mealIcon,
              totalCalories: summary.getMealCalories(mealType),
              totalCarbs: summary.getMealCarbs(mealType),
              totalFat: summary.getMealFat(mealType),
              totalProtein: summary.getMealProtein(mealType),
            ),
            const SizedBox(height: AppValues.spacing16),
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
            if (logs.isEmpty)
              MealDetailEmptyState(
                mealTitle: _mealTitle(context),
                onAddTap: () => context.router.push(
                  ManualEntryRoute(initialMealType: mealType),
                ),
              )
            else
              ...logs.map((log) => MealDetailFoodCard(
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
