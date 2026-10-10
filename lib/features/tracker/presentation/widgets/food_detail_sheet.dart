import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/core/constants/meal_enums.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';

import 'package:astrobite/features/scanner/presentation/widgets/micronutrient_chips_row.dart';
import 'package:astrobite/features/tracker/domain/entities/food_log.dart';
import 'package:astrobite/features/tracker/presentation/controllers/tracker_controller.dart';
import 'package:astrobite/features/tracker/presentation/widgets/calorie_portion_card.dart';
import 'package:astrobite/features/tracker/presentation/widgets/dishes_breakdown_section.dart';

import 'package:astrobite/features/tracker/presentation/widgets/macro_pill.dart';

import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Modal bottom sheet displaying detailed nutritional breakdown and actions for a logged food item.
class FoodDetailSheet extends StatelessWidget {
  const FoodDetailSheet({
    super.key,
    required this.log,
    required this.mealType,
    required this.targetCalories,
    required this.onDelete,
  });

  final FoodLog log;
  final MealType mealType;
  final int targetCalories;
  final Future<void> Function() onDelete;

  static Future<void> show({
    required BuildContext context,
    required WidgetRef ref,
    required FoodLog log,
    required MealType mealType,
    required int targetCalories,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FoodDetailSheet(
        log: log,
        mealType: mealType,
        targetCalories: targetCalories,
        onDelete: () async {
          final confirm = await showDialog<bool>(
            context: ctx,
            builder: (dCtx) => AlertDialog(
              title: Text(dCtx.l10n.confirmDelete),
              content: Text(dCtx.l10n.deleteFoodConfirmMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(false),
                  child: Text(dCtx.l10n.cancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                  onPressed: () => Navigator.of(dCtx).pop(true),
                  child: Text(dCtx.l10n.delete),
                ),
              ],
            ),
          );

          if (confirm == true) {
            final user = ref.read(authStateProvider).value;
            if (user != null) {
              await ref.read(trackerControllerProvider.notifier).deleteFoodLog(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalMacroG = log.carbsG + log.proteinG + log.fatG;
    final carbsPct = totalMacroG > 0 ? ((log.carbsG / totalMacroG) * 100).round() : 0;
    final proteinPct = totalMacroG > 0 ? ((log.proteinG / totalMacroG) * 100).round() : 0;
    final fatPct = totalMacroG > 0 ? ((log.fatG / totalMacroG) * 100).round() : 0;
    final dishesList = log.dishes ?? [];


    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AppColors.outline, width: 1.2)),
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
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppValues.spacing12, bottom: AppValues.spacing8),
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
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
                  // Header
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
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: mealType.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: mealType.color.withValues(alpha: 0.35),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(mealType.icon, size: 13, color: mealType.color),
                                      const SizedBox(width: AppValues.spacing4),
                                      Text(
                                        mealType.label,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800,
                                          color: mealType.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppValues.spacing8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.outline, width: 1.2),
                                  ),
                                  child: Text(
                                    log.source == 'multi_scan'
                                        ? '🍱 Quét đa món'
                                        : (log.source == 'ai_scan' ? '✦ AI Vision' : '✍ Nhập tay'),
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppValues.spacing16),

                  // Calories & portion card
                  CaloriePortionCard(
                    calories: log.calories,
                    weightG: log.estimatedWeightG,
                    targetCalories: targetCalories,
                  ),
                  const SizedBox(height: AppValues.spacing16),


                  // Macro triad
                  Row(
                    children: [
                      Expanded(
                        child: MacroPill(
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
                        child: MacroPill(
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
                        child: MacroPill(
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

                  // Micronutrients
                  MicronutrientChipsRow(
                    sodiumMg: log.sodiumMg,
                    fiberG: log.fiberG,
                    sugarG: log.sugarG,
                  ),

                  // Multi-dish breakdown
                  DishesBreakdownSection(dishes: dishesList),

                  const SizedBox(height: AppValues.spacing20),


                  // Delete action button
                  ClayButton(
                    text: 'Xóa món này khỏi nhật ký',
                    variant: ClayButtonVariant.danger,
                    height: 50,
                    width: double.infinity,
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
