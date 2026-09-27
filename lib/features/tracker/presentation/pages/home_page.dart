import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import '../../domain/tracker_providers.dart';
import '../widgets/celestial_offline_banner.dart';
import '../widgets/daily_summary_card.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/date_picker_strip.dart';
import '../widgets/meal_section.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
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

    return Scaffold(
      appBar: const DashboardAppBar(),
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
                  const SizedBox(height: AppValues.spacing12),
                  const _QuickMealPlanActions(),
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
                  const SizedBox(height: 100),
                ],
              ),
      ),
    ],
  ),
),
);
}
}

class _QuickMealPlanActions extends StatelessWidget {
  const _QuickMealPlanActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionChipButton(
            icon: Icons.menu_book_rounded,
            label: 'Công thức món',
            color: AppColors.primary,
            onTap: () => context.router.push(const RecipesRoute()),
          ),
        ),
        const SizedBox(width: AppValues.spacing12),
        Expanded(
          child: _ActionChipButton(
            icon: Icons.calendar_month_rounded,
            label: 'Kế hoạch 7 ngày',
            color: AppColors.tertiary,
            onTap: () => context.router.push(const MealPlannerRoute()),
          ),
        ),
      ],
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPrimary = color == AppColors.primary;
    final badgeBg = isPrimary ? const Color(0xFFE5F6FD) : const Color(0xFFFFF2D6);
    final badgeBevel = isPrimary ? const Color(0xFFBCE3F7) : const Color(0xFFF7DEB0);

    return ClayCard(
      onTap: onTap,
      elevation: 3.0,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing12,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badgeBg,
              boxShadow: [
                BoxShadow(
                  color: badgeBevel,
                  offset: const Offset(0, 1.5),
                  blurRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: AppValues.spacing8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
