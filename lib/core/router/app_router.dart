import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/scanner/domain/entities/scan_result.dart';

import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auth/presentation/pages/goal_summary_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/scanner/presentation/pages/camera_page.dart';
import '../../features/scanner/presentation/pages/scan_review_page.dart';
import '../../features/tracker/presentation/pages/home_page.dart';
import '../../features/tracker/presentation/pages/manual_entry_page.dart';
import '../../features/tracker/presentation/pages/meal_detail_page.dart';
import '../../features/coach/presentation/coach_page.dart';
import '../../features/health/presentation/health_connection_page.dart';
import '../../features/recipes/presentation/pages/recipe_builder_page.dart';
import '../../features/recipes/presentation/pages/recipes_page.dart';
import '../../features/recipes/presentation/pages/meal_planner_page.dart';
import '../../shared/ui_kit/ui_kit.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: GoalSummaryRoute.page),
    AutoRoute(
      page: ShellRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: CoachRoute.page),
        AutoRoute(page: AnalyticsRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: ManualEntryRoute.page),
    AutoRoute(page: CameraRoute.page),
    AutoRoute(page: ScanReviewRoute.page),
    AutoRoute(page: MealDetailRoute.page),
    AutoRoute(page: ProfileEditRoute.page),
    AutoRoute(page: HealthConnectionRoute.page),
    AutoRoute(page: RecipesRoute.page),
    AutoRoute(page: RecipeBuilderRoute.page),
    AutoRoute(page: MealPlannerRoute.page),
  ];
}

@RoutePage()
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      routes: const [
        HomeRoute(),
        CoachRoute(),
        AnalyticsRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return ClayBottomNav(tabsRouter: tabsRouter);
      },
    );
  }
}
