import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../domain/daily_summary.dart';
import '../controllers/tracker_controller.dart';
import 'sync_status_badge.dart';

class MealSection extends ConsumerWidget {
  const MealSection({
    super.key,
    required this.mealType,
    required this.summary,
    required this.onAddTap,
  });

  final String mealType;
  final DailySummary summary;
  final VoidCallback onAddTap;

  String get _title => switch (mealType) {
        'breakfast' => AppStrings.breakfast,
        'lunch' => AppStrings.lunch,
        'dinner' => AppStrings.dinner,
        'snack' => AppStrings.snack,
        _ => mealType,
      };

  IconData get _iconData => switch (mealType) {
        'breakfast' => Icons.wb_twilight_rounded,
        'lunch' => Icons.wb_sunny_rounded,
        'dinner' => Icons.nightlight_round,
        'snack' => Icons.apple_rounded,
        _ => Icons.restaurant_rounded,
      };

  Color get _iconColor => switch (mealType) {
        'breakfast' => AppColors.tertiary,
        'lunch' => const Color(0xFFFFB300),
        'dinner' => const Color(0xFF90CAF9),
        'snack' => AppColors.secondary,
        _ => AppColors.primary,
      };

  int get _suggestedCalories => switch (mealType) {
        'breakfast' => (summary.targetCalories * 0.25).round(),
        'lunch' => (summary.targetCalories * 0.35).round(),
        'dinner' => (summary.targetCalories * 0.30).round(),
        'snack' => (summary.targetCalories * 0.10).round(),
        _ => 200,
      };

  Future<bool?> _showDeleteConfirmationDialog(
    BuildContext context,
    String dishName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.confirmDelete),
        content: const Text(AppStrings.deleteFoodConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = summary.getMealLogs(mealType);
    final totalCalories = summary.getMealCalories(mealType);
    final totalCarbs = summary.getMealCarbs(mealType);
    final totalProtein = summary.getMealProtein(mealType);
    final totalFat = summary.getMealFat(mealType);
    final isCompleted = logs.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: AppValues.spacing12),
      color: AppColors.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.cardRadius),
        side: BorderSide(
          color: AppColors.outline.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppValues.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Avatar Icon Box, Title + Badge + Metrics, and Trailing Action
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Icon Avatar Box
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppValues.radius12),
                    border: Border.all(
                      color: _iconColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _iconColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _iconData,
                    color: _iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppValues.spacing12),

                // 2. Title & Status or Macros info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title + Pill Tag
                      Row(
                        children: [
                          Text(
                            _title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.primary.withValues(alpha: 0.18)
                                  : AppColors.surface.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(AppValues.radius12),
                              border: Border.all(
                                color: isCompleted
                                    ? AppColors.primary.withValues(alpha: 0.4)
                                    : AppColors.outline.withValues(alpha: 0.25),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              isCompleted ? 'Đã hoàn thành' : 'Chưa ăn',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Metrics summary row
                      if (isCompleted) ...[
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '$totalCalories kcal',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                    letterSpacing: AppValues.calorieLetterSpacing,
                                  ),
                            ),
                            Text(
                              '  •  ',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                                fontSize: 11,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                                children: [
                                  const TextSpan(
                                    text: 'C ',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${totalCarbs}g  ',
                                    style: const TextStyle(color: AppColors.onSurface),
                                  ),
                                  const TextSpan(
                                    text: 'P ',
                                    style: TextStyle(
                                      color: AppColors.tertiary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${totalProtein}g  ',
                                    style: const TextStyle(color: AppColors.onSurface),
                                  ),
                                  const TextSpan(
                                    text: 'F ',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${totalFat}g',
                                    style: const TextStyle(color: AppColors.onSurface),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          AppStrings.noMealLogs,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                              ),
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Text(
                              '0 kcal',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    letterSpacing: AppValues.calorieLetterSpacing,
                                  ),
                            ),
                            Text(
                              ' / $_suggestedCalories kcal gợi ý',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 3. Trailing Action: Quick Add / Completed button
                if (isCompleted) ...[
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 22,
                      color: AppColors.primary,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    tooltip: 'Thêm món ăn',
                    onPressed: onAddTap,
                  ),
                  const SizedBox(width: AppValues.spacing4),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(
                        color: AppColors.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ] else ...[
                  Material(
                    color: AppColors.primary,
                    shape: const CircleBorder(),
                    elevation: 2,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    child: InkWell(
                      onTap: onAddTap,
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: AppValues.minTouchTarget,
                        height: AppValues.minTouchTarget,
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // Item list if logs exist
            if (logs.isNotEmpty) ...[
              const SizedBox(height: AppValues.spacing12),
              Divider(
                height: 1,
                color: AppColors.outline.withValues(alpha: 0.15),
              ),
              const SizedBox(height: AppValues.spacing8),
              ...logs.map((log) {
                return Dismissible(
                  key: ValueKey(log.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppValues.spacing16),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppValues.radius8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppColors.onSurface,
                      size: 22,
                    ),
                  ),
                  confirmDismiss: (direction) =>
                      _showDeleteConfirmationDialog(context, log.dishName),
                  onDismissed: (direction) {
                    final user = ref.read(authStateProvider).value;
                    if (user != null) {
                      ref.read(trackerControllerProvider.notifier).deleteFoodLog(
                            userId: user.uid,
                            logId: log.id,
                          );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã xóa món ${log.dishName}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.restaurant_menu_rounded,
                                size: 14,
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: AppValues.spacing8),
                              Flexible(
                                child: Text(
                                  '${log.dishName} (${log.estimatedWeightG}g)',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.onSurface,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (log.isHighSodium) ...[
                                const SizedBox(width: AppValues.spacing4),
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 14,
                                  color: AppColors.warning,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${log.calories} cal',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    letterSpacing: AppValues.calorieLetterSpacing,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(width: AppValues.spacing4),
                            SyncStatusBadge(syncStatus: log.syncStatus),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
