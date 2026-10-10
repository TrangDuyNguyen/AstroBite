import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/theme/app_icons.dart';
import '../icons/clay_3d_icons.dart';
import 'bottom_nav_components/clay_hero_camera_fab.dart';
import 'bottom_nav_components/clay_nav_item.dart';

/// Claymorphic × Duolingo 2D/3D Floating Dock Navigation Bar.
/// 
/// - Tactile floating capsule dock with dual-layer 3D clay shadows & glassmorphism
/// - Custom 3D Clay Navigation Emblems (Calendar, Magic Wand, Macro Chart, Astronaut)
/// - Elevated 3D Duolingo Hero Camera FAB with ceramic cradle, sapphire lens, and squash physics
/// - Active tab highlighted with 3D Duolingo tactile pill & active indicator gem
class ClayBottomNav extends StatelessWidget {
  const ClayBottomNav({
    super.key,
    required this.tabsRouter,
  });

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    const dockHeight = 64.0;
    const fabSize = 56.0;
    const fabElevation = 12.0;
    final bottomMargin = (bottomPadding > 0 ? bottomPadding : 12.0) + 8.0;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppValues.screenPadding,
          0,
          AppValues.screenPadding,
          bottomMargin,
        ),
        child: SizedBox(
          height: dockHeight + fabElevation,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // 1. Floating Claymorphic Capsule Dock
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 376),
                    child: Container(
                      height: dockHeight,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(33),
                        border: Border.all(
                          color: AppColors.outline,
                          width: 1.2,
                        ),
                        boxShadow: const [
                          // Layer 1: Chunky 3D clay bottom bevel
                          BoxShadow(
                            color: Color(0xFFDDD8CE),
                            offset: Offset(0, 4.5),
                            blurRadius: 0,
                          ),
                          // Layer 2: Warm ambient soft float
                          BoxShadow(
                            color: Color(0x181E2337),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(33),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              children: [
                                // Tab 1: Hôm nay
                                Expanded(
                                  child: ClayNavItem(
                                    icon: AppIcons.navToday,
                                    selectedIcon: AppIcons.navTodaySelected,
                                    clayIcon: (isSelected) => Clay3DCalendar(
                                      size: 21,
                                      isSelected: isSelected,
                                    ),
                                    label: AppStrings.navToday,
                                    isSelected: tabsRouter.activeIndex == 0,
                                    onTap: () => tabsRouter.setActiveIndex(0),
                                  ),
                                ),
                                // Tab 2: AstroCoach
                                Expanded(
                                  child: ClayNavItem(
                                    icon: AppIcons.navCoach,
                                    selectedIcon: AppIcons.navCoachSelected,
                                    clayIcon: (isSelected) => Clay3DAstroBot(
                                      size: 21,
                                      isSelected: isSelected,
                                    ),
                                    label: AppStrings.navCoach,
                                    isSelected: tabsRouter.activeIndex == 1,
                                    onTap: () => tabsRouter.setActiveIndex(1),
                                  ),
                                ),
                                // Center Spacing Gap for Elevated FAB
                                const SizedBox(width: fabSize + 14),
                                // Tab 3: Thống kê
                                Expanded(
                                  child: ClayNavItem(
                                    icon: AppIcons.navAnalytics,
                                    selectedIcon: AppIcons.navAnalyticsSelected,
                                    clayIcon: (isSelected) => Clay3DAnalyticsChart(
                                      size: 21,
                                      isSelected: isSelected,
                                    ),
                                    label: AppStrings.navInsights,
                                    isSelected: tabsRouter.activeIndex == 2,
                                    onTap: () => tabsRouter.setActiveIndex(2),
                                  ),
                                ),
                                // Tab 4: Cá nhân
                                Expanded(
                                  child: ClayNavItem(
                                    icon: AppIcons.navProfile,
                                    selectedIcon: AppIcons.navProfileSelected,
                                    clayIcon: (isSelected) => Clay3DAstronaut(
                                      size: 21,
                                      isSelected: isSelected,
                                    ),
                                    label: AppStrings.navProfile,
                                    isSelected: tabsRouter.activeIndex == 3,
                                    onTap: () => tabsRouter.setActiveIndex(3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Elevated Center 3D Floating Camera FAB (Hero Action)
              Positioned(
                top: 0,
                child: ClayHeroCameraFab(
                  fabSize: fabSize,
                  onTap: () => context.router.push(const CameraRoute()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef CelestialBottomNav = ClayBottomNav;
