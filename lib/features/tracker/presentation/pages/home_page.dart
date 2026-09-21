import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import '../../domain/tracker_providers.dart';
import '../widgets/celestial_offline_banner.dart';
import '../widgets/daily_micronutrient_card.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/date_picker_strip.dart';
import '../widgets/meal_section.dart';

import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import 'package:astrobite/features/gamification/presentation/widgets/cosmic_streak_badge.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.todayOverview),
        actions: [
          const Center(child: CosmicStreakBadge()),
          const SizedBox(width: AppValues.spacing8),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: AppStrings.profile,
            onPressed: () => context.router.push(const ProfileRoute()),
          ),
          const SizedBox(width: AppValues.spacing8),
        ],
      ),
      body: SafeArea(
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
                  const SizedBox(height: AppValues.spacing16),
                  DailyMicronutrientCard(summary: summary),
                  const SizedBox(height: AppValues.spacing16),
                  // AstroCoach Quick Tip & CTA
                  GlassCard(
                    padding: const EdgeInsets.all(AppValues.cardPadding),
                    child: InkWell(
                      onTap: () => context.router.push(const CoachRoute()),
                      borderRadius: BorderRadius.circular(AppValues.cardRadius),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'AstroCoach AI',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.onSurface,
                                          ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiary.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'PROACTIVE',
                                        style: TextStyle(
                                          color: AppColors.tertiary,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Hôm nay bạn cần gợi ý thực đơn hay phân tích calo? Bấm để hỏi ngay!',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppValues.spacing24),
                  Text(
                    AppStrings.nutritionLog,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
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
          ],
        ),
      ),
    ],
  ),
),
);
}
}
