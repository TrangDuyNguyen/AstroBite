import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../domain/daily_summary.dart';
import '../../domain/entities/food_log.dart';
import '../controllers/tracker_controller.dart';
import 'sync_status_badge.dart';
import 'package:astrobite/features/scanner/presentation/widgets/micronutrient_chips_row.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

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

  Color get _pastelTint => switch (mealType) {
        'breakfast' => AppColors.clayBreakfast,
        'lunch' => AppColors.clayLunch,
        'dinner' => AppColors.clayDinner,
        'snack' => AppColors.claySnack,
        _ => AppColors.surfaceContainer,
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

    return Padding(
      padding: const EdgeInsets.only(bottom: AppValues.spacing12),
      child: ClayCard(
        backgroundColor: _pastelTint,
        elevation: 3.5,
        borderRadius: 22,
        padding: const EdgeInsets.all(AppValues.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Avatar Icon Box, Title + Badge + Metrics, and Trailing Action
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Icon Avatar Box (Clay 3D Badge)
                _ClayMealBadge(
                  mealType: mealType,
                  icon: _iconData,
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
                  ClayIconButton(
                    icon: Icons.add_circle_outline,
                    onPressed: onAddTap,
                    backgroundColor: AppColors.surfaceContainer,
                    iconColor: AppColors.primary,
                    size: 38,
                    borderRadius: 19,
                    tooltip: 'Thêm món ăn',
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.brandGreen,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF46A302),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ] else ...[
                  ClayIconButton(
                    icon: Icons.add_circle_outline,
                    onPressed: onAddTap,
                    backgroundColor: AppColors.primary,
                    iconColor: Colors.white,
                    size: 44,
                    borderRadius: 22,
                    tooltip: 'Thêm món ăn',
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppValues.radius8),
                      onTap: () => _showFoodDetailSheet(context, ref, log),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
                                const SizedBox(width: AppValues.spacing4),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16,
                                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  void _showFoodDetailSheet(BuildContext context, WidgetRef ref, FoodLog log) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final totalMacroG = log.carbsG + log.proteinG + log.fatG;
        final carbsPct =
            totalMacroG > 0 ? ((log.carbsG / totalMacroG) * 100).round() : 0;
        final proteinPct =
            totalMacroG > 0 ? ((log.proteinG / totalMacroG) * 100).round() : 0;
        final fatPct =
            totalMacroG > 0 ? ((log.fatG / totalMacroG) * 100).round() : 0;
        final dishesList = log.dishes ?? [];

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppValues.cardRadius),
            ),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: AppValues.spacing12,
                    bottom: AppValues.spacing8,
                  ),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // 2. Scrollable Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppValues.screenPadding,
                    AppValues.spacing8,
                    AppValues.screenPadding,
                    AppValues.spacing24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header: Title & Close Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppValues.spacing8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _iconColor.withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(AppValues.radius8),
                                        border: Border.all(
                                          color: _iconColor.withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(_iconData, size: 12, color: _iconColor),
                                          const SizedBox(width: AppValues.spacing4),
                                          Text(
                                            _title,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: _iconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppValues.spacing8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppValues.spacing8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius:
                                            BorderRadius.circular(AppValues.radius8),
                                        border: Border.all(
                                          color: AppColors.outline.withValues(alpha: 0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        log.source == 'multi_scan'
                                            ? '🍱 Quét đa món'
                                            : (log.source == 'ai_scan'
                                                ? '✦ AI Vision'
                                                : '✍ Nhập tay'),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppValues.spacing8),
                                Text(
                                  log.dishName,
                                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.onSurfaceVariant,
                            ),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing16),

                      // Calorie & Portion GlassCard
                      Container(
                        padding: const EdgeInsets.all(AppValues.cardPadding),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppValues.cardRadius),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${log.calories} kcal',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    letterSpacing: AppValues.calorieLetterSpacing,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Khẩu phần ước lượng: ${log.estimatedWeightG}g',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppValues.spacing12,
                                vertical: AppValues.spacing4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(AppValues.radius12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.bolt_rounded,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${((log.calories / (summary.targetCalories > 0 ? summary.targetCalories : 2000)) * 100).round()}% Ngày',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppValues.spacing16),

                      // Holographic Macro Triad
                      Row(
                        children: [
                          Expanded(
                            child: _MacroPill(
                              label: 'Tinh bột',
                              value: '${log.carbsG}g',
                              percentage: '$carbsPct%',
                              color: AppColors.primary, // #1A73E8
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Expanded(
                            child: _MacroPill(
                              label: 'Chất đạm',
                              value: '${log.proteinG}g',
                              percentage: '$proteinPct%',
                              color: AppColors.tertiary, // #FFD700
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Expanded(
                            child: _MacroPill(
                              label: 'Chất béo',
                              value: '${log.fatG}g',
                              percentage: '$fatPct%',
                              color: AppColors.secondary, // #FF69B4
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing16),

                      // Micronutrients Row
                      MicronutrientChipsRow(
                        sodiumMg: log.sodiumMg,
                        fiberG: log.fiberG,
                        sugarG: log.sugarG,
                      ),

                      // Multi-dish items breakdown (if present)
                      if (dishesList.isNotEmpty) ...[
                        const SizedBox(height: AppValues.spacing20),
                        Row(
                          children: [
                            const Icon(
                              Icons.restaurant_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppValues.spacing4),
                            Text(
                              'Thành phần trong bữa (${dishesList.length} món)',
                              style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppValues.spacing8),
                        ...dishesList.map((dish) {
                          final name = dish['dish_name'] as String? ?? 'Món ăn';
                          final weight = dish['estimated_weight_g'] as num? ?? 0;
                          final cal = dish['calories'] as num? ?? 0;
                          final c = dish['carbs_g'] as num? ?? 0;
                          final p = dish['protein_g'] as num? ?? 0;
                          final f = dish['fat_g'] as num? ?? 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: AppValues.spacing8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppValues.spacing12,
                              vertical: AppValues.spacing8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppValues.radius8),
                              border: Border.all(
                                color: AppColors.outline.withValues(alpha: 0.15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Khối lượng: ${weight}g • C: ${c}g • P: ${p}g • F: ${f}g',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '$cal cal',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],

                      const SizedBox(height: AppValues.spacing20),

                      // Delete Button Action
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(
                            color: AppColors.error.withValues(alpha: 0.5),
                          ),
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppValues.radius12),
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Xóa món này khỏi nhật ký'),
                        onPressed: () async {
                          final confirm = await _showDeleteConfirmationDialog(
                            ctx,
                            log.dishName,
                          );
                          if (confirm == true) {
                            final user = ref.read(authStateProvider).value;
                            if (user != null) {
                              ref
                                  .read(trackerControllerProvider.notifier)
                                  .deleteFoodLog(
                                    userId: user.uid,
                                    logId: log.id,
                                  );
                            }
                            if (ctx.mounted) {
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã xóa món ${log.dishName}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  final String label;
  final String value;
  final String percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing8,
        vertical: AppValues.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClayMealBadge extends StatelessWidget {
  const _ClayMealBadge({
    required this.mealType,
    required this.icon,
  });

  final String mealType;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final (gradientColors, bevelColor, iconColor) = switch (mealType) {
      'breakfast' => (
        [const Color(0xFFFFB74D), const Color(0xFFFF9800)],
        const Color(0xFFE65100),
        Colors.white,
      ),
      'lunch' => (
        [const Color(0xFFFFD54F), const Color(0xFFFFA000)],
        const Color(0xFFE68900),
        Colors.white,
      ),
      'dinner' => (
        [const Color(0xFF7986CB), const Color(0xFF5C6BC0)],
        const Color(0xFF3949AB),
        Colors.white,
      ),
      'snack' => (
        [const Color(0xFFFF8A80), const Color(0xFFFF5252)],
        const Color(0xFFD32F2F),
        Colors.white,
      ),
      _ => (
        [const Color(0xFF64B5F6), const Color(0xFF1CB0F6)],
        const Color(0xFF1488C2),
        Colors.white,
      ),
    };

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // 3D tactile bottom bevel
          BoxShadow(
            color: bevelColor,
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
          // Ambient glow
          BoxShadow(
            color: gradientColors[1].withValues(alpha: 0.35),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: ClayMorphIcon(
        icon: icon,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
