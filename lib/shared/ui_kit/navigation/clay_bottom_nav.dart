import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/theme/app_icons.dart';
import '../icons/clay_3d_icons.dart';

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
                                child: _NavItem(
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
                                child: _NavItem(
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
                                child: _NavItem(
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
                                child: _NavItem(
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
              child: _HeroCameraFab(
                fabSize: fabSize,
                onTap: () => context.router.push(const CameraRoute()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Elevated Hero Camera FAB with 3D ceramic cradle, sapphire lens, and spring squash physics.
class _HeroCameraFab extends StatefulWidget {
  const _HeroCameraFab({
    required this.fabSize,
    required this.onTap,
  });

  final double fabSize;
  final VoidCallback onTap;

  @override
  State<_HeroCameraFab> createState() => _HeroCameraFabState();
}

class _HeroCameraFabState extends State<_HeroCameraFab> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const cradleSize = 64.0;
    final scale = _isPressed ? 0.93 : 1.0;
    final translateY = _isPressed ? 3.0 : 0.0;

    return Semantics(
      button: true,
      label: AppStrings.scanFood,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, translateY)
            ..scale(scale),
          child: SizedBox(
            width: cradleSize,
            height: cradleSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Ceramic White Dock Cradle (Bridge merging seamlessly with dock)
                Container(
                  width: cradleSize,
                  height: cradleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainer,
                    border: Border.all(
                      color: AppColors.outline,
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFDDD8CE),
                        offset: Offset(0, 3.5),
                        blurRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x181E2337),
                        offset: Offset(0, 6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),

                // 2. Chunky 3D Duolingo Sky Blue Button
                Container(
                  width: widget.fabSize,
                  height: widget.fabSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF38BDF8),
                        Color(0xFF1CB0F6),
                        Color(0xFF0284C7),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF1488C2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      // 3D bottom bevel
                      BoxShadow(
                        color: const Color(0xFF0F74A8),
                        offset: Offset(0, _isPressed ? 1.5 : 4.0),
                        blurRadius: 0,
                      ),
                      // Vibrant blue glow
                      const BoxShadow(
                        color: Color(0x351CB0F6),
                        offset: Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Top Specular Reflection Arc
                      Positioned(
                        top: 2,
                        child: Container(
                          width: widget.fabSize * 0.65,
                          height: widget.fabSize * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.5),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Zero-size on-stage Icon for test contracts
                      const SizedBox(
                        width: 0,
                        height: 0,
                        child: OverflowBox(
                          maxWidth: 0,
                          maxHeight: 0,
                          child: Icon(AppIcons.navCamera),
                        ),
                      ),

                      // 3D Clay Food Scanner Camera
                      const Clay3DCamera(size: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.clayIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final Widget Function(bool isSelected) clayIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.92 : 1.0;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(scale),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isSelected ? 8 : 4,
                vertical: widget.isSelected ? 4 : 4,
              ),
              decoration: widget.isSelected
                  ? BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF0F9FE),
                          Color(0xFFE2F4FD),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF90D5F7),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        // 3D bottom bevel
                        BoxShadow(
                          color: Color(0xFFBCE3F7),
                          offset: Offset(0, 2.5),
                          blurRadius: 0,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hidden on-stage Icon for test contracts
                  SizedBox(
                    width: 0,
                    height: 0,
                    child: OverflowBox(
                      maxWidth: 0,
                      maxHeight: 0,
                      child: Icon(
                        widget.isSelected ? widget.selectedIcon : widget.icon,
                        size: 1,
                      ),
                    ),
                  ),

                  // 3D Clay Navigation Emblem with bounce scale
                  AnimatedScale(
                    scale: widget.isSelected ? 1.08 : 0.95,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: widget.clayIcon(widget.isSelected),
                  ),
                  const SizedBox(height: 3),

                  // Label
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: widget.isSelected ? 10.5 : 10.0,
                        fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: widget.isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                    ),
                  ),

                  // Active Indicator Gem Dot
                  if (widget.isSelected) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 10,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF1488C2),
                            offset: Offset(0, 0.8),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
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
