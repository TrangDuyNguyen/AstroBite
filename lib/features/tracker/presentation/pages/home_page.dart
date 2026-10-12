import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import 'package:astrobite/features/voice/presentation/widgets/astro_voice_sheet.dart';
import 'package:astrobite/features/voice/presentation/widgets/voice_pulsing_mic_button.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/daily_summary.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/tracker_providers.dart';
import '../controllers/meal_slots_controller.dart';
import '../controllers/tracker_controller.dart';
import '../widgets/add_meal_slot_button.dart';
import '../widgets/add_meal_slot_sheet.dart';
import '../widgets/celestial_offline_banner.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/delete_meal_confirmation_sheet.dart';
import '../widgets/galactic_date_orbit.dart';
import '../widgets/home_components/home_astro_coach_suggestion_card.dart';
import '../widgets/home_components/home_nutrition_log_header.dart';
import '../widgets/home_components/home_quick_actions_bar.dart';
import '../widgets/meal_section.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _handleDeleteSlot(
    BuildContext context,
    WidgetRef ref,
    MealSlot slot,
    DailySummary summary,
  ) async {
    final logs = summary.getMealLogs(slot.id);
    final activeSlots = ref.read(mealSlotsNotifierProvider);

    if (logs.isNotEmpty) {
      final result = await DeleteMealConfirmationSheet.show(
        context,
        slotToDelete: slot,
        availableSlots: activeSlots,
        logs: logs,
      );

      if (result == null || !context.mounted) return;

      final user = ref.read(authStateProvider).value;

      if (result.action == DeleteMealAction.migrate && result.targetSlotId != null) {
        if (user != null) {
          await ref.read(trackerControllerProvider.notifier).migrateMealLogs(
                userId: user.uid,
                logsToMigrate: logs,
                targetMealType: result.targetSlotId!,
              );
        }
      } else if (result.action == DeleteMealAction.deleteAll) {
        if (user != null) {
          await ref.read(trackerControllerProvider.notifier).deleteMealLogs(
                userId: user.uid,
                logsToDelete: logs,
              );
        }
      }

      ref.read(mealSlotsNotifierProvider.notifier).removeSlot(slot.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa "${slot.label}"'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      final removed = ref.read(mealSlotsNotifierProvider.notifier).removeSlot(slot.id);
      if (removed != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa "${slot.label}"'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Hoàn tác',
              textColor: AppColors.primary,
              onPressed: () {
                ref.read(mealSlotsNotifierProvider.notifier).restoreSlot(
                      removed,
                      slot.orderIndex,
                    );
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);
    final mealSlots = ref.watch(mealSlotsNotifierProvider);

    // Sync to native OS widgets reactively
    ref.listen(todaySummaryProvider, (_, next) {
      ref.read(widgetSyncServiceProvider).sync(
            summary: next,
            streak: ref.read(streakNotifierProvider).valueOrNull,
          );
    });

    // Immediate initial sync on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widgetSyncServiceProvider).sync(
            summary: summary,
            streak: ref.read(streakNotifierProvider).valueOrNull,
          );
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const DashboardAppBar(),
      floatingActionButton: VoicePulsingMicButton(
        onTap: () => AstroVoiceSheet.show(context),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const CelestialOfflineBanner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppValues.screenPadding),
                children: [
                  const GalacticDateOrbit(),
                  const SizedBox(height: AppValues.spacing16),
                  DailySummaryCard(summary: summary),
                  const SizedBox(height: AppValues.spacing12),
                  HomeAstroCoachSuggestionCard(summary: summary),
                  const SizedBox(height: AppValues.spacing16),
                  HomeNutritionLogHeader(summary: summary),
                  const SizedBox(height: AppValues.spacing12),
                  ...mealSlots.map((slot) {
                    return MealSection(
                      key: ValueKey('meal_section_${slot.id}'),
                      mealType: slot.id,
                      slot: slot,
                      summary: summary,
                      onAddTap: () => context.router.push(
                        ManualEntryRoute(initialMealType: slot.id),
                      ),
                      onDeleteTap: slot.isRemovable
                          ? () => _handleDeleteSlot(context, ref, slot, summary)
                          : null,
                    );
                  }),
                  AddMealSlotButton(
                    onTap: () {
                      AddMealSlotBottomSheet.show(
                        context,
                        onAddSlot: (newSlot) {
                          ref.read(mealSlotsNotifierProvider.notifier).addSlot(newSlot);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AppValues.spacing12),
                  const HomeQuickActionsBar(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
