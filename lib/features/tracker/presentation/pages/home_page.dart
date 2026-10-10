import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import 'package:astrobite/features/voice/presentation/widgets/astro_voice_sheet.dart';
import 'package:astrobite/features/voice/presentation/widgets/voice_pulsing_mic_button.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/tracker_providers.dart';
import '../widgets/celestial_offline_banner.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/date_picker_strip.dart';
import '../widgets/home_components/home_astro_coach_suggestion_card.dart';
import '../widgets/home_components/home_nutrition_log_header.dart';
import '../widgets/home_components/home_quick_actions_bar.dart';
import '../widgets/meal_section.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);

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
                  const DatePickerStrip(),
                  const SizedBox(height: AppValues.spacing16),
                  DailySummaryCard(summary: summary),
                  const SizedBox(height: AppValues.spacing12),
                  const HomeQuickActionsBar(),
                  const SizedBox(height: AppValues.spacing20),
                  HomeNutritionLogHeader(summary: summary),
                  const SizedBox(height: AppValues.spacing12),
                  MealSection(
                    mealType: 'breakfast',
                    summary: summary,
                    onAddTap: () => context.router.push(ManualEntryRoute(initialMealType: 'breakfast')),
                  ),
                  MealSection(
                    mealType: 'lunch',
                    summary: summary,
                    onAddTap: () => context.router.push(ManualEntryRoute(initialMealType: 'lunch')),
                  ),
                  MealSection(
                    mealType: 'dinner',
                    summary: summary,
                    onAddTap: () => context.router.push(ManualEntryRoute(initialMealType: 'dinner')),
                  ),
                  MealSection(
                    mealType: 'snack',
                    summary: summary,
                    onAddTap: () => context.router.push(ManualEntryRoute(initialMealType: 'snack')),
                  ),
                  const SizedBox(height: AppValues.spacing8),
                  HomeAstroCoachSuggestionCard(summary: summary),
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
