import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/theme/app_icons.dart';
import '../controllers/streak_controller.dart';
import 'streak_detail_sheet.dart';

/// Compact Celestial Pill Badge displaying the user's active streak and shield count.
class CosmicStreakBadge extends ConsumerWidget {
  const CosmicStreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakNotifierProvider);

    return streakAsync.when(
      data: (streak) {
        final hasStreak = streak.hasActiveStreak;

        return InkWell(
          onTap: () => StreakDetailSheet.show(context, streak),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasStreak
                    ? const Color(0xFFFF9600)
                    : AppColors.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: hasStreak
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF9600).withValues(alpha: 0.20),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasStreak ? '🔥' : '✨',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 5),
                Text(
                  '${streak.currentStreak}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: hasStreak ? AppColors.onSurface : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  AppIcons.shield,
                  size: 15,
                  color: streak.hasShield
                      ? const Color(0xFF9AA5B8)
                      : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Container(
        width: 68,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
