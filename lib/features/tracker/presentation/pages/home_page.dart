import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../../domain/tracker_providers.dart';
import '../widgets/celestial_offline_banner.dart';
import '../widgets/celestial_time_avatar.dart';
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

    // Immediate initial sync on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widgetSyncServiceProvider).sync(
            summary: summary,
            streak: ref.read(streakNotifierProvider).valueOrNull,
          );
    });

    final selectedDate = ref.watch(selectedDateProvider);
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
    final weekdayStr = switch (selectedDate.weekday) {
      DateTime.monday => 'Thứ Hai',
      DateTime.tuesday => 'Thứ Ba',
      DateTime.wednesday => 'Thứ Tư',
      DateTime.thursday => 'Thứ Năm',
      DateTime.friday => 'Thứ Sáu',
      DateTime.saturday => 'Thứ Bảy',
      DateTime.sunday => 'Chủ Nhật',
      _ => '',
    };
    final dateSubtitle =
        '$weekdayStr, ${selectedDate.day.toString().padLeft(2, '0')} Th${selectedDate.month.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: AppValues.screenPadding,
        title: Row(
          children: [
            CelestialTimeAvatar(
              onTap: () => context.router.push(const ProfileRoute()),
            ),
            const SizedBox(width: AppValues.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isToday ? AppStrings.todayOverview : 'Nhật ký dinh dưỡng',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                              color: AppColors.onSurface,
                            ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        ref.read(selectedDateProvider.notifier).state = picked;
                      }
                    },
                    borderRadius: BorderRadius.circular(AppValues.radius8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dateSubtitle,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: const [
          Center(child: CosmicStreakBadge()),
          SizedBox(width: AppValues.screenPadding),
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
                  const SizedBox(height: AppValues.spacing20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.nutritionLog,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '4 bữa • Cần nạp đủ để duy trì năng lượng',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        '${summary.totalCalories} / ${summary.targetCalories} kcal',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
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
                  const SizedBox(height: AppValues.spacing8),
                  // AstroCoach Suggestion Card
                  InkWell(
                    onTap: () => context.router.push(const CoachRoute()),
                    borderRadius: BorderRadius.circular(AppValues.radius12),
                    child: Container(
                      padding: const EdgeInsets.all(AppValues.spacing12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(AppValues.radius12),
                        border: Border.all(
                          color: AppColors.outline.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.tertiary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppValues.radius8),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: AppColors.tertiary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Gợi ý từ AstroCoach',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  summary.totalProteinG < summary.targetProteinG
                                      ? 'Cần thêm ${(summary.targetProteinG - summary.totalProteinG)}g Protein để đạt mục tiêu...'
                                      : 'Dinh dưỡng hôm nay đang rất cân bằng và tối ưu!',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
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
