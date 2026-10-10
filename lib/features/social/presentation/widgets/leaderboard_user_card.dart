import 'package:flutter/material.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Card item displaying a user rank, streak, and nudge or achieved status.
class LeaderboardUserCard extends StatelessWidget {
  const LeaderboardUserCard({
    super.key,
    required this.user,
    required this.onNudge,
  });

  final LeaderboardEntry user;
  final VoidCallback onNudge;

  @override
  Widget build(BuildContext context) {
    final rank = user.rank;
    final isTop1 = rank == 1;
    final isMe = user.isMe;

    final bgColor = isMe
        ? const Color(0xFFF0F9FF)
        : (isTop1 ? const Color(0xFFFFF2D6) : AppColors.surfaceContainer);

    String rankStr = rank.toString();
    if (rank == 1) {
      rankStr = '👑';
    } else if (rank == 2) {
      rankStr = '🥈';
    } else if (rank == 3) {
      rankStr = '🥉';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMe
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.outline.withValues(alpha: 0.5),
          width: isMe ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              rankStr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: (isTop1 || isMe) ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                Text(
                  user.astroId,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Chỉ báo Streak
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '${user.streak}d',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Tương tác: Đạt chuẩn vs Nudge (Cứu Streak)
          if (isMe)
            const SizedBox.shrink()
          else if (user.goalAchievedToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9D8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Đạt chuẩn ✨',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else if (user.isNudgedToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Đã nhắc',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            InkWell(
              onTap: onNudge,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2D6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD580)),
                ),
                child: const Row(
                  children: [
                    Text('⚡', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 2),
                    Text(
                      'Nhắc',
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
