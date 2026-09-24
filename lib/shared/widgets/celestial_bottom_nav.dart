import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Redesigned Floating 3D Celestial Island Navigation Bar (Floating Nav Cockpit).
/// Matches the official Stitch design specification:
/// - Floating capsule dock with 20px blur glassmorphism and ambient cyan glow
/// - Active tab highlighted with glowing neon pill container
/// - Elevated 3D center AI Camera FAB with dual-layer celestial gradient & glow
/// - Strict 44pt touch targets and ergonomic spacing
class CelestialBottomNav extends StatelessWidget {
  const CelestialBottomNav({
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
    // Lift the dock capsule cleanly above the Android gesture pill / iOS home bar
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
            // 1. Floating 3D Glassmorphic Capsule Dock
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 358),
                  child: Container(
                    height: dockHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.55),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xD90D1C32), // bg-[#0d1c32]/85
                            borderRadius: BorderRadius.circular(33),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              // Tab 1: Hôm nay
                              Expanded(
                                child: _NavItem(
                                  icon: Icons.nightlight_outlined,
                                  selectedIcon: Icons.nightlight_outlined,
                                  label: AppStrings.navToday,
                                  isSelected: tabsRouter.activeIndex == 0,
                                  onTap: () => tabsRouter.setActiveIndex(0),
                                ),
                              ),
                              // Tab 2: AstroCoach
                              Expanded(
                                child: _NavItem(
                                  icon: Icons.smart_toy_outlined,
                                  selectedIcon: Icons.smart_toy_rounded,
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
                                  icon: Icons.analytics_outlined,
                                  selectedIcon: Icons.analytics_rounded,
                                  label: AppStrings.navInsights,
                                  isSelected: tabsRouter.activeIndex == 2,
                                  onTap: () => tabsRouter.setActiveIndex(2),
                                ),
                              ),
                              // Tab 4: Cá nhân
                              Expanded(
                                child: _NavItem(
                                  icon: Icons.person_outline_rounded,
                                  selectedIcon: Icons.person_rounded,
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

            // 2. Elevated Center 3D Floating Camera FAB
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
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF1A73E8),
                            Color(0xFF3B82F6),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFADC7FF).withValues(alpha: 0.4),
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A73E8).withValues(alpha: 0.40),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.28),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.photo_camera_rounded,
                        color: Colors.white,
                        size: 26,
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
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.28),
                        width: 1.0,
                      ),
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
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
                        letterSpacing: -0.3,
                        shadows: isSelected
                            ? [
                                Shadow(
                                  color: AppColors.primary.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
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
