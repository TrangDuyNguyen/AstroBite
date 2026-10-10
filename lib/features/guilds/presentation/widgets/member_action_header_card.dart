import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild_member.dart';

/// Header card displaying member avatar, display name, role badge, streak, and weekly XP.
class MemberActionHeaderCard extends StatelessWidget {
  const MemberActionHeaderCard({
    super.key,
    required this.member,
  });

  final GuildMember member;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      backgroundColor: AppColors.surfaceContainer,
      child: Row(
        children: [
          // Avatar with role-based pastel colors
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: member.isLeader
                  ? AppColors.clayDinner
                  : member.isElder
                      ? AppColors.clayLunch
                      : AppColors.clayMint,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.displayName.isNotEmpty
                    ? member.displayName[0].toUpperCase()
                    : '?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Member Info & Badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _RoleBadge(role: member.role),
                  ],
                ),
                Row(
                  children: [
                    const Clay3DFlame(size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${member.currentStreak} ngày streak',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.outline,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${member.weeklyContributionXp} XP tuần',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.brandGreen,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;
    String label;

    switch (role) {
      case 'leader':
        bg = AppColors.clayDinner;
        fg = const Color(0xFF6B21A8);
        border = const Color(0xFFD8B4FE);
        label = 'Bang Chủ';
        break;
      case 'elder':
        bg = AppColors.clayLunch;
        fg = const Color(0xFF0369A1);
        border = const Color(0xFFBAE6FD);
        label = 'Phó Bang';
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        fg = const Color(0xFF4B5563);
        border = const Color(0xFFE5E7EB);
        label = 'Thành viên';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}
