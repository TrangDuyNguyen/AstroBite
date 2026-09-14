import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../domain/daily_summary.dart';
import '../controllers/tracker_controller.dart';

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

  String get _icon => switch (mealType) {
        'breakfast' => '🌅',
        'lunch' => '☀️',
        'dinner' => '🌙',
        'snack' => '🍪',
        _ => '🍽️',
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

    return Card(
      margin: const EdgeInsets.only(bottom: AppValues.spacing12),
      color: AppColors.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.cardRadius),
        side: BorderSide(
          color: AppColors.outline.withValues(alpha: 0.15),
          width: 1,
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
                Row(
                  children: [
                    Text(_icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: AppValues.spacing8),
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$totalCalories kcal',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            letterSpacing: AppValues.calorieLetterSpacing,
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: AppValues.spacing4),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 22,
                        color: AppColors.primary,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: AppValues.minTouchTarget,
                        minHeight: AppValues.minTouchTarget,
                      ),
                      tooltip: 'Thêm món ăn',
                      onPressed: onAddTap,
                    ),
                  ],
                ),
              ],
            ),
            if (logs.isNotEmpty) ...[
              const Divider(height: AppValues.spacing16),
              ...logs.map((log) {
                return Dismissible(
                  key: ValueKey(log.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppValues.spacing16),
                    margin: const EdgeInsets.symmetric(vertical: 2),
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
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${log.dishName} (${log.estimatedWeightG}g)',
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${log.calories} cal',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                letterSpacing: AppValues.calorieLetterSpacing,
                                color: AppColors.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(top: AppValues.spacing8),
                child: Text(
                  AppStrings.noMealLogs,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
