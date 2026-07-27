import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/scanner/presentation/pages/camera_page.dart';
import '../../features/scanner/presentation/pages/scan_review_page.dart';
import '../../features/tracker/presentation/pages/home_page.dart';
import '../../features/tracker/presentation/pages/manual_entry_page.dart';
import '../../features/tracker/presentation/pages/meal_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(
      page: ShellRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: AnalyticsRoute.page),
        AutoRoute(page: ManualEntryRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: CameraRoute.page),
    AutoRoute(page: ScanReviewRoute.page),
    AutoRoute(page: MealDetailRoute.page),
    AutoRoute(page: ProfileEditRoute.page),
  ];
}

@RoutePage()
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        AnalyticsRoute(),
        ManualEntryRoute(),
        ProfileRoute(),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.push(const CameraRoute()),
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Tổng quan',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Phân tích',
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_note_outlined),
              selectedIcon: Icon(Icons.edit_note),
              label: 'Nhập tay',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Hồ sơ',
            ),
          ],
        );
      },
    );
  }
}
