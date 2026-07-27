import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/profile/presentation/profile_edit_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/scanner/presentation/camera_screen.dart';
import '../../features/scanner/presentation/scan_review_screen.dart';
import '../../features/tracker/presentation/home_screen.dart';
import '../../features/tracker/presentation/manual_entry_screen.dart';
import '../../features/tracker/presentation/meal_detail_screen.dart';

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
