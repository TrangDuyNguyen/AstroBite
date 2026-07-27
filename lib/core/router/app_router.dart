import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/profile/presentation/profile_edit_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/scanner/presentation/camera_screen.dart';
import '../../features/scanner/presentation/scan_review_screen.dart';
import '../../features/tracker/presentation/home_screen.dart';
import '../../features/tracker/presentation/manual_entry_screen.dart';
import '../../features/tracker/presentation/meal_detail_screen.dart';
import 'placeholder_screens.dart';

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

  @override
  List<AutoRouteGuard> get guards => [];
}

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}

@RoutePage()
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});
  @override
  Widget build(BuildContext context) => const AutoRouter();
}
