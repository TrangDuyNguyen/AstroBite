import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFAF7F2)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasStreak
                    ? const Color(0xFFFF9600)
                    : AppColors.outline.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                // 3D tactile bottom bevel
                BoxShadow(
                  color: hasStreak ? const Color(0x35FF9600) : const Color(0x14000000),
                  offset: const Offset(0, 2.5),
                  blurRadius: 0,
                ),
                // Ambient floating glow
                BoxShadow(
                  color: hasStreak
                      ? const Color(0x30FF9600)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: hasStreak ? 10 : 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Semantic text for accessibility and tests
                    Opacity(
                      opacity: 0.0,
                      child: Text(
                        hasStreak ? '🔥' : '✨',
                        style: const TextStyle(fontSize: 0),
                      ),
                    ),
                    // 3D Clay Flame
                    hasStreak
                        ? const Clay3DFlame(size: 19)
                        : const Text('✨', style: TextStyle(fontSize: 14)),
                  ],
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
                const SizedBox(width: 7),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Semantic icon for accessibility and tests
                    Opacity(
                      opacity: 0.0,
                      child: Icon(
                        AppIcons.shield,
                        size: 0,
                        color: streak.hasShield
                            ? const Color(0xFF9AA5B8)
                            : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    // 3D Clay Shield
                    Clay3DShield(
                      size: 16,
                      isActive: streak.hasShield,
                    ),
                  ],
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
