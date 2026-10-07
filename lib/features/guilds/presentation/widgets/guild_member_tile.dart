import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild_member.dart';

class GuildMemberTile extends StatelessWidget {
  final GuildMember member;
  final int rank;
  final bool isCurrentUser;
  final VoidCallback onNudge;
  final VoidCallback? onTap;

  const GuildMemberTile({
    super.key,
    required this.member,
    required this.rank,
    this.isCurrentUser = false,
    required this.onNudge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTop1 = rank == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ClayCard(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: isCurrentUser
              ? AppColors.clayLunch
              : AppColors.surfaceContainer,
          child: Row(
            children: [
              // Rank badge / 3D Star for Top 1
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isTop1
                      ? AppColors.tertiary.withValues(alpha: 0.15)
                      : AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: isTop1
                    ? const Clay3DStar(size: 18)
                    : Text(
                        '#$rank',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
              ),
              const SizedBox(width: 12),

              // Member Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: member.isLeader
                      ? AppColors.clayDinner
                      : member.isElder
                          ? AppColors.clayLunch
                          : (isTop1 ? AppColors.clayBreakfast : AppColors.clayMint),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: member.isLeader
                        ? const Color(0xFFC084FC)
                        : member.isElder
                            ? const Color(0xFF7DD3FC)
                            : Colors.transparent,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    member.displayName.isNotEmpty
                        ? member.displayName[0].toUpperCase()
                        : '?',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            member.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: isCurrentUser || isTop1
                                      ? FontWeight.w800
                                      : FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                          ),
                        ),
                        if (member.isLeader) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.clayDinner,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFD8B4FE), width: 1),
                            ),
                            child: const Text(
                              'Bang Chủ',
                              style: TextStyle(
                                color: Color(0xFF6B21A8),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ] else if (member.isElder) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.clayLunch,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                            ),
                            child: const Text(
                              'Phó Bang',
                              style: TextStyle(
                                color: Color(0xFF0369A1),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ] else if (isTop1) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.clayBreakfast,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFDE68A), width: 1),
                            ),
                            child: const Text(
                              'MVP',
                              style: TextStyle(
                                color: Color(0xFFB45309),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Clay3DFlame(size: 13),
                        const SizedBox(width: 4),
                        Text(
                          '${member.currentStreak} ngày streak',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // XP and Nudge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${member.weeklyContributionXp} XP',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.brandGreen,
                        ),
                  ),
                ],
              ),

              if (!isCurrentUser) ...[
                const SizedBox(width: 8),
                IconButton(
                  key: Key('nudge_btn_${member.userId}'),
                  icon: const Icon(
                    Icons.notifications_active_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  tooltip: 'Nhắc nhở đồng đội',
                  onPressed: onNudge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
