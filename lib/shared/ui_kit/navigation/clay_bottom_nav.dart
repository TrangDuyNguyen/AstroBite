import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/theme/app_icons.dart';
import '../indicators/clay_morph_icon.dart';

/// Claymorphic × Duolingo 2D/3D Floating Dock Navigation Bar.
/// 
/// - Soft clay floating capsule with dual-layer floating shadows
/// - 44pt minimum touch targets
/// - Active tab highlighted with vibrant Duolingo Sky Blue pill
/// - Elevated 3D tactile Camera FAB with Duolingo Sky Blue and bevel shadow
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
    const fabSize = 54.0;
    const fabElevation = 8.0;
    final bottomMargin = (bottomPadding > 0 ? bottomPadding : 12.0) + 8.0;

    return Padding(
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
                  constraints: const BoxConstraints(maxWidth: 368),
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
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              // Tab 1: Hôm nay
                              Expanded(
                                child: _NavItem(
                                  icon: AppIcons.navToday,
                                  selectedIcon: AppIcons.navTodaySelected,
                                  label: AppStrings.navToday,
                                  isSelected: tabsRouter.activeIndex == 0,
                                  onTap: () => tabsRouter.setActiveIndex(0),
                                ),
                              ),
                              // Tab 2: AstroCoach
                              Expanded(
                                child: _NavItem(
                                  icon: AppIcons.navCoach,
                                  selectedIcon: AppIcons.navCoachSelected,
                                  label: AppStrings.navCoach,
                                  isSelected: tabsRouter.activeIndex == 1,
                                  onTap: () => tabsRouter.setActiveIndex(1),
                                ),
                              ),
                              // Center Spacing Gap for Elevated FAB
                              const SizedBox(width: fabSize + 12),
                              // Tab 3: Thống kê
                              Expanded(
                                child: _NavItem(
                                  icon: AppIcons.navAnalytics,
                                  selectedIcon: AppIcons.navAnalyticsSelected,
                                  label: AppStrings.navInsights,
                                  isSelected: tabsRouter.activeIndex == 2,
                                  onTap: () => tabsRouter.setActiveIndex(2),
                                ),
                              ),
                              // Tab 4: Cá nhân
                              Expanded(
                                child: _NavItem(
                                  icon: AppIcons.navProfile,
                                  selectedIcon: AppIcons.navProfileSelected,
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

            // 2. Elevated Center 3D Floating Camera FAB (Duolingo 3D Chunky Style)
            Positioned(
              top: 0,
              child: Semantics(
                button: true,
                label: AppStrings.scanFood,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.router.push(const CameraRoute()),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: fabSize,
                      height: fabSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(
                          color: const Color(0xFF1488C2),
                          width: 1.5,
                        ),
                        boxShadow: const [
                          // 3D bottom bevel
                          BoxShadow(
                            color: Color(0xFF1488C2),
                            offset: Offset(0, 4.5),
                            blurRadius: 0,
                          ),
                          // Soft drop shadow
                          BoxShadow(
                            color: Color(0x351CB0F6),
                            offset: Offset(0, 7),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 3,
                            child: Container(
                              width: fabSize * 0.65,
                              height: fabSize * 0.32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.4),
                                    Colors.white.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            AppIcons.navCamera,
                            color: Colors.white,
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 5,
              ),
              decoration: isSelected
                  ? BoxDecoration(
                      color: const Color(0xFFE5F6FD),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF90D5F7),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFBCE3F7),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClayMorphIcon(
                    icon: isSelected ? selectedIcon : icon,
                    color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef CelestialBottomNav = ClayBottomNav;
