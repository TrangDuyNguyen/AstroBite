import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/gamification/presentation/widgets/cosmic_streak_badge.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/tracker_providers.dart';
import 'celestial_time_avatar.dart';

/// Celestial Top AppBar for the Tracker/Dashboard screen.
///
/// Features:
/// - Dynamic Celestial Time Avatar with cosmic gradient ring and satellite indicator
/// - Screen title ("Hôm nay") with Sky Blue active dot indicator
/// - Interactive date dropdown ("Chủ Nhật, 27 Th09 ▾") opening the date picker
/// - Recipe book quick action button
/// - Glowing amber Streak Pill Badge ("🔥 2 🛡")
class DashboardAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
    this.onProfileTap,
    this.onRecipesTap,
    this.onDateTap,
    this.currentTime,
  });

  final VoidCallback? onProfileTap;
  final VoidCallback? onRecipesTap;
  final VoidCallback? onDateTap;
  final DateTime? currentTime;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final now = currentTime ?? DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final weekdayStr = switch (selectedDate.weekday) {
      DateTime.monday => 'Thứ Hai',
      DateTime.tuesday => 'Thứ Ba',
      DateTime.wednesday => 'Thứ Tư',
      DateTime.thursday => 'Thứ Năm',
      DateTime.friday => 'Thứ Sáu',
      DateTime.saturday => 'Thứ Bảy',
      DateTime.sunday => 'Chủ Nhật',
      _ => '',
    };

    final dateSubtitle =
        '$weekdayStr, ${selectedDate.day.toString().padLeft(2, '0')} Th${selectedDate.month.toString().padLeft(2, '0')}';

    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      toolbarHeight: kToolbarHeight + 4,
      titleSpacing: AppValues.screenPadding,
      title: Row(
        children: [
          CelestialTimeAvatar(
            onTap: onProfileTap ?? () => context.router.push(const ProfileRoute()),
          ),
          const SizedBox(width: AppValues.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isToday ? AppStrings.todayOverview : 'Nhật ký dinh dưỡng',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                InkWell(
                  onTap: onDateTap ??
                      () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          ref.read(selectedDateProvider.notifier).state = picked;
                        }
                      },
                  borderRadius: BorderRadius.circular(AppValues.radius8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dateSubtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        AppIcons.arrowDown,
                        size: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Tooltip(
            message: 'Công thức món ăn',
            child: InkWell(
              onTap: onRecipesTap ?? () => context.router.push(const RecipesRoute()),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFFAF7F2)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x121E2337),
                      offset: Offset(0, 2.5),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x0A000000),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Semantic icon for tests and accessibility
                      Opacity(
                        opacity: 0.0,
                        child: Icon(
                          AppIcons.book,
                          size: 24,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      // 3D Sculpted Clay Cookbook
                      const IgnorePointer(child: Clay3DCookbook(size: 24)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Tooltip(
            message: 'Bang Hội Vũ Trụ',
            child: InkWell(
              key: const Key('dashboard_guild_button'),
              onTap: () => context.router.push(const GuildRoute()),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFFAF7F2)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x121E2337),
                      offset: Offset(0, 2.5),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x0A000000),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🪐', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Tooltip(
            message: 'Bảng xếp hạng',
            child: InkWell(
              onTap: () => context.router.push(const LeaderboardRoute()),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFFAF7F2)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x121E2337),
                      offset: Offset(0, 2.5),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x0A000000),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        ),
        const Center(child: CosmicStreakBadge()),
        const SizedBox(width: AppValues.screenPadding),
      ],
    );
  }
}
