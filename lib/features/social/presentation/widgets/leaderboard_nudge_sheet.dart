import 'package:flutter/material.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Modal bottom sheet confirming a streak saving reminder signal (Nudge) to a friend.
class LeaderboardNudgeSheet extends StatelessWidget {
  const LeaderboardNudgeSheet({
    super.key,
    required this.user,
    required this.onConfirmNudge,
  });

  final LeaderboardEntry user;
  final VoidCallback onConfirmNudge;

  static void show(
    BuildContext context, {
    required LeaderboardEntry user,
    required VoidCallback onConfirmNudge,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => LeaderboardNudgeSheet(user: user, onConfirmNudge: onConfirmNudge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x20000000),
            offset: Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2D6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🔥', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Cứu Streak Bạn Bè',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Gửi một tín hiệu nhắc nhở tới ${user.name} để bảo vệ chuỗi kỷ luật 🔥 ${user.streak} ngày trước khi hết ngày hôm nay!',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ClayButton(
                  text: 'Hủy',
                  variant: ClayButtonVariant.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClayButton(
                  text: 'Gửi Tín Hiệu',
                  variant: ClayButtonVariant.primary,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirmNudge();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
