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
              // Rank badge
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isTop1
                      ? AppColors.tertiary.withValues(alpha: 0.2)
                      : AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: isTop1
                    ? const Text('👑', style: TextStyle(fontSize: 16))
                    : Text(
                        '#$rank',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
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
                ),
                child: Center(
                  child: Text(
                    member.displayName.isNotEmpty
                        ? member.displayName[0].toUpperCase()
                        : '?',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
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
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                          ),
                        ),
                        if (member.isLeader) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.clayDinner,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Bang Chủ',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(0xFF7C3AED),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ] else if (member.isElder) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.clayLunch,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Phó Bang',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ] else if (isTop1) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.clayBreakfast,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'MVP',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.tertiary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: Color(0xFFEF4444),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${member.currentStreak} ngày streak',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
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
                          fontWeight: FontWeight.bold,
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
