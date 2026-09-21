import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasStreak
                    ? AppColors.tertiary.withValues(alpha: 0.6)
                    : AppColors.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: hasStreak
                  ? [
                      BoxShadow(
                        color: AppColors.tertiary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
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
                const SizedBox(width: 4),
                Text(
                  '${streak.currentStreak}',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: hasStreak ? AppColors.onSurface : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 1,
                  height: 12,
                  color: AppColors.outline.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.shield_moon_rounded,
                  size: 14,
                  color: streak.hasShield ? AppColors.secondary : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                if (streak.starlightShields > 0) ...[
                  const SizedBox(width: 2),
                  Text(
                    '${streak.starlightShields}',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
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
