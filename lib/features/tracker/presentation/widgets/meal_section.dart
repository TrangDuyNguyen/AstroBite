import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(0xFFE8F9D8)
                                  : Colors.white.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isCompleted
                                    ? const Color(0xFF58CC02)
                                    : const Color(0xFFDDD8CE),
                                width: isCompleted ? 1.0 : 0.8,
                              ),
                              boxShadow: isCompleted
                                  ? const [
                                      BoxShadow(
                                        color: Color(0xFF46A302),
                                        offset: Offset(0, 1.2),
                                        blurRadius: 0,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isCompleted) ...[
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 11,
                                    color: Color(0xFF46A302),
                                  ),
                                  const SizedBox(width: 3),
                                ],
                                Text(
                                  isCompleted ? 'Đã hoàn thành' : 'Chưa ăn',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isCompleted
                                        ? const Color(0xFF46A302)
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
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
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
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
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFEDE8DD),
                            width: 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x10000000),
                              offset: Offset(0, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _showFoodDetailSheet(context, ref, log),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: _pastelTint,
                                            borderRadius: BorderRadius.circular(9),
                                            border: Border.all(
                                              color: _iconColor.withValues(alpha: 0.25),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.restaurant_menu_rounded,
                                              size: 16,
                                              color: _iconColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppValues.spacing8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '${log.dishName} (${log.estimatedWeightG}g)',
                                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                            color: AppColors.onSurface,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (log.isHighSodium) ...[
                                                    const SizedBox(width: AppValues.spacing4),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.error.withValues(alpha: 0.12),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.warning_amber_rounded,
                                                            size: 11,
                                                            color: AppColors.error,
                                                          ),
                                                          SizedBox(width: 2),
                                                          Text(
                                                            'Muối cao',
                                                            style: TextStyle(
                                                              fontSize: 9,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.error,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  _MiniMacroDot(color: AppColors.primary, label: '${log.carbsG}g C'),
                                                  const SizedBox(width: 6),
                                                  _MiniMacroDot(color: AppColors.tertiary, label: '${log.proteinG}g P'),
                                                  const SizedBox(width: 6),
                                                  _MiniMacroDot(color: AppColors.secondary, label: '${log.fatG}g F'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppValues.spacing8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F4EC),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFE8E3D7), width: 0.8),
                                        ),
                                        child: Text(
                                          '${log.calories} cal',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                letterSpacing: AppValues.calorieLetterSpacing,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.onSurface,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: AppValues.spacing4),
                                      SyncStatusBadge(syncStatus: log.syncStatus),
                                      const SizedBox(width: 2),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0xFFEDE8DD), width: 0.8),
                                        ),
                                        child: const Icon(
                                          Icons.chevron_right_rounded,
                                          size: 14,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
          decoration: const BoxDecoration(
            color: AppColors.surface, // Warm milk canvas
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.outline,
                width: 1.2,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x1F1E2337),
                blurRadius: 24,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Chunky Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: AppValues.spacing12,
                    bottom: AppValues.spacing8,
                  ),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(2.5),
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
                      // Header: Category/Source Pills & Close Button
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
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _iconColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _iconColor.withValues(alpha: 0.35),
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(_iconData, size: 13, color: _iconColor),
                                          const SizedBox(width: AppValues.spacing4),
                                          Text(
                                            _title,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w800,
                                              color: _iconColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppValues.spacing8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainer,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.outline,
                                          width: 1.2,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x0A000000),
                                            offset: Offset(0, 1.5),
                                            blurRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        log.source == 'multi_scan'
                                            ? '🍱 Quét đa món'
                                            : (log.source == 'ai_scan'
                                                ? '✦ AI Vision'
                                                : '✍ Nhập tay'),
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppValues.spacing8),
                                Text(
                                  log.dishName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.onSurface,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClayIconButton(
                            icon: Icons.close_rounded,
                            size: 36,
                            borderRadius: 12,
                            iconColor: AppColors.onSurfaceVariant,
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppValues.spacing16),

                      // Calorie & Portion ClayCard
                      ClayCard(
                        padding: const EdgeInsets.all(AppValues.spacing16),
                        borderRadius: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${log.calories} kcal',
                                  style: GoogleFonts.outfit(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    letterSpacing: AppValues.calorieLetterSpacing,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Khẩu phần ước lượng: ${log.estimatedWeightG}g',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppValues.spacing12,
                                vertical: 6,
                              ),
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.bolt_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${((log.calories / (summary.targetCalories > 0 ? summary.targetCalories : 2000)) * 100).round()}% Ngày',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.5,
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
                              color: AppColors.primary,
                              bgColor: const Color(0xFFF0F9FF),
                              borderColor: const Color(0xFFBAE6FD),
                              bevelColor: const Color(0xFF7DD3FC),
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Expanded(
                            child: _MacroPill(
                              label: 'Chất đạm',
                              value: '${log.proteinG}g',
                              percentage: '$proteinPct%',
                              color: AppColors.tertiary,
                              bgColor: const Color(0xFFFFF8ED),
                              borderColor: const Color(0xFFFFE2B3),
                              bevelColor: const Color(0xFFFDBA74),
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Expanded(
                            child: _MacroPill(
                              label: 'Chất béo',
                              value: '${log.fatG}g',
                              percentage: '$fatPct%',
                              color: AppColors.secondary,
                              bgColor: const Color(0xFFFFF1F5),
                              borderColor: const Color(0xFFFECDD3),
                              bevelColor: const Color(0xFFFDA4AF),
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
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
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
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE5E0D8),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFD4CEBF),
                                  offset: Offset(0, 2),
                                  blurRadius: 0,
                                ),
                              ],
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
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.5,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Khối lượng: ${weight}g • C: ${c}g • P: ${p}g • F: ${f}g',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
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
                                    '$cal cal',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.5,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],

                      const SizedBox(height: AppValues.spacing20),

                      // Delete Button Action (Duolingo 3D Button)
                      ClayButton(
                        text: 'Xóa món này khỏi nhật ký',
                        variant: ClayButtonVariant.danger,
                        height: 50,
                        width: double.infinity,
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
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
    this.bgColor,
    this.borderColor,
    this.bevelColor,
  });

  final String label;
  final String value;
  final String percentage;
  final Color color;
  final Color? bgColor;
  final Color? borderColor;
  final Color? bevelColor;

  @override
  Widget build(BuildContext context) {
    final bg = bgColor ?? Colors.white;
    final border = borderColor ?? color.withValues(alpha: 0.35);
    final bevel = bevelColor ?? color.withValues(alpha: 0.25);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing8,
        vertical: AppValues.spacing8,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
          width: 1.2,
        ),
        boxShadow: [
          // 3D tactile bottom bevel
          BoxShadow(
            color: bevel,
            offset: const Offset(0, 2.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            percentage,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMacroDot extends StatelessWidget {
  const _MiniMacroDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5.5,
          height: 5.5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 3.5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
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
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.5,
        ),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 2,
            left: 5,
            right: 5,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.50),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          ClayMorphIcon(
            icon: icon,
            color: iconColor,
            size: 24,
          ),
        ],
      ),
    );
  }
}
