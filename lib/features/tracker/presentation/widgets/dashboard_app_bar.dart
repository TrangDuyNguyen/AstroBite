import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/theme/app_icons.dart';
import 'package:astrobite/features/gamification/presentation/widgets/cosmic_streak_badge.dart';
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
  });

  final VoidCallback? onProfileTap;
  final VoidCallback? onRecipesTap;
  final VoidCallback? onDateTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final now = DateTime.now();
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
        IconButton(
          icon: const Icon(
            AppIcons.book,
            color: AppColors.onSurfaceVariant,
            size: 24,
          ),
          tooltip: 'Công thức món ăn',
          onPressed: onRecipesTap ?? () => context.router.push(const RecipesRoute()),
        ),
        const Center(child: CosmicStreakBadge()),
        const SizedBox(width: AppValues.screenPadding),
      ],
    );
  }
}
