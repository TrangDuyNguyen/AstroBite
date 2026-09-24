import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Celestial Dark UI Bottom Navigation Bar matching the official design specification.
/// Features a 5-slot layout with 4 navigation tabs and a centered floating Camera FAB.
class CelestialBottomNav extends StatelessWidget {
  const CelestialBottomNav({
    super.key,
    required this.tabsRouter,
  });

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const barHeight = 64.0;
    const fabSize = AppValues.fabSize; // 60x60

    return SizedBox(
      height: barHeight + bottomPadding + 14,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background Bar Container
          Container(
            height: barHeight + bottomPadding,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(
                  color: AppColors.outline.withValues(alpha: 0.2),
                  width: 0.8,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                children: [
                  // Slot 1: Today
                  Expanded(
                    child: _NavItem(
                      icon: Icons.nightlight_outlined,
                      selectedIcon: Icons.nightlight_round,
                      label: 'Today',
                      isSelected: tabsRouter.activeIndex == 0,
                      onTap: () => tabsRouter.setActiveIndex(0),
                    ),
                  ),
                  // Slot 2: AstroCoach
                  Expanded(
                    child: _NavItem(
                      icon: Icons.smart_toy_outlined,
                      selectedIcon: Icons.smart_toy_rounded,
                      label: 'AstroCoach',
                      isSelected: tabsRouter.activeIndex == 1,
                      onTap: () => tabsRouter.setActiveIndex(1),
                    ),
                  ),
                  // Slot 3: Empty gap for Center Camera FAB
                  const SizedBox(width: fabSize + AppValues.spacing8),
                  // Slot 4: Insights
                  Expanded(
                    child: _NavItem(
                      icon: Icons.insights_outlined,
                      selectedIcon: Icons.insights_rounded,
                      label: 'Insights',
                      isSelected: tabsRouter.activeIndex == 2,
                      onTap: () => tabsRouter.setActiveIndex(2),
                    ),
                  ),
                  // Slot 5: Profile
                  Expanded(
                    child: _NavItem(
                      icon: Icons.person_outline_rounded,
                      selectedIcon: Icons.person_rounded,
                      label: 'Profile',
                      isSelected: tabsRouter.activeIndex == 3,
                      onTap: () => tabsRouter.setActiveIndex(3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Center Floating Camera FAB
          Positioned(
            top: 0,
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.45),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
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
    final color = isSelected ? AppColors.primary : AppColors.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppValues.radius12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.spacing4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: AppValues.spacing4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: color,
                letterSpacing: -0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
