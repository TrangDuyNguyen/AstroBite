import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import '../../domain/daily_summary.dart';
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
      backgroundColor: AppColors.surface,
      appBar: const DashboardAppBar(),
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
                  const _QuickMealPlanActions(),
                  const SizedBox(height: AppValues.spacing20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(
                                  color: const Color(0xFFEDE8DD),
                                  width: 1.2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x12000000),
                                    offset: Offset(0, 2),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Clay3DCookbook(size: 22),
                              ),
                            ),
                            const SizedBox(width: AppValues.spacing8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.nutritionLog,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.onSurface,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '4 bữa • Cần nạp đủ để duy trì năng lượng',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppValues.spacing8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F5EE),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE8E3D7),
                            width: 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x10000000),
                              offset: Offset(0, 1.5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Text(
                          '${summary.totalCalories} / ${summary.targetCalories} kcal',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                                letterSpacing: 0.3,
                              ),
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
                  _AstroCoachSuggestionCard(summary: summary),
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

class _AstroCoachSuggestionCard extends StatelessWidget {
  const _AstroCoachSuggestionCard({required this.summary});

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final needsProtein = summary.totalProteinG < summary.targetProteinG;
    final proteinDiff = summary.targetProteinG - summary.totalProteinG;

    return ClayCard(
      elevation: 3.5,
      borderRadius: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => context.router.push(const CoachRoute()),
      child: Row(
        children: [
          // 1. 3D Ceramic AstroCoach Badge (AstroBot)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFBAE6FD),
                width: 1.2,
              ),
              boxShadow: const [
                // 3D bottom bevel
                BoxShadow(
                  color: Color(0xFF7DD3FC),
                  offset: Offset(0, 2.5),
                  blurRadius: 0,
                ),
                // Soft glow
                BoxShadow(
                  color: Color(0x200284C7),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Top inner specular gloss arc
                Positioned(
                  top: 2,
                  child: Container(
                    width: 26,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const Clay3DAstroBot(size: 26),
              ],
            ),
          ),
          const SizedBox(width: AppValues.spacing12),

          // 2. Title & Dynamic Nutritional Advice
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Gợi ý từ AstroCoach',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const SizedBox(width: 6),
                    // 3D Mini AI Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFDDD6FE),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFC4B5FD),
                            offset: Offset(0, 1.2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Text(
                        'AI COACH',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w800,
                          fontSize: 8.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                    ),
                    children: needsProtein
                        ? [
                            const TextSpan(text: 'Cần thêm '),
                            TextSpan(
                              text: '${proteinDiff}g Protein',
                              style: const TextStyle(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: ' để đạt mục tiêu...'),
                          ]
                        : const [
                            TextSpan(text: 'Dinh dưỡng hôm nay '),
                            TextSpan(
                              text: 'đang rất cân bằng',
                              style: TextStyle(
                                color: AppColors.brandGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: ' và tối ưu! 🥑'),
                          ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // 3. Tactile 3D Circular Arrow Button
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF8F6F2),
              border: Border.all(
                color: const Color(0xFFEDE8DD),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFDDD8CE),
                  offset: Offset(0, 1.5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFF78829A),
            ),
          ),
        ],
      ),
    );
  }
}
