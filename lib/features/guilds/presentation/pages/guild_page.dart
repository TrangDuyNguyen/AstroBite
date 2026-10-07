import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';
import '../controllers/guild_controller.dart';
import '../widgets/guild_create_sheet.dart';
import '../widgets/guild_edit_sheet.dart';
import '../widgets/guild_join_sheet.dart';
import '../widgets/guild_member_tile.dart';
import '../widgets/member_action_sheet.dart';
import '../widgets/planetary_challenge_card.dart';

@RoutePage()
class GuildPage extends ConsumerWidget {
  const GuildPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guildAsync = ref.watch(currentUserGuildStreamProvider);

    // Listen to errors & success
    ref.listen<GuildUiState>(guildControllerProvider, (_, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
        ref.read(guildControllerProvider.notifier).clearMessages();
      } else if (state.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.successMessage!),
            backgroundColor: AppColors.brandGreen,
          ),
        );
        ref.read(guildControllerProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ClayAppBar(
        title: 'Bang Hội Vũ Trụ',
        subtitle: 'Cùng đồng đội chinh phục dinh dưỡng',
        actions: [
          IconButton(
            key: const Key('guild_create_action_button'),
            icon: const Icon(Icons.group_add_rounded, color: AppColors.primary),
            tooltip: 'Tạo hoặc đổi Bang hội',
            onPressed: () {
              _showCreateOrJoinMenu(context);
            },
          ),
          IconButton(
            key: const Key('guild_info_button'),
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.onSurfaceVariant),
            tooltip: 'Thể lệ thử thách',
            onPressed: () {
              _showRulesDialog(context);
            },
          ),
        ],
      ),
      body: guildAsync.when(
        loading: () => _buildShimmerLoading(),
        error: (err, _) => _buildErrorState(context, ref, err.toString()),
        data: (guild) {
          if (guild == null) {
            return _buildEmptyState(context);
          }
          return _buildActiveGuild(context, ref, guild);
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ClaySkeletonLoader(width: double.infinity, height: 120, borderRadius: 24),
        SizedBox(height: 16),
        ClaySkeletonLoader(width: double.infinity, height: 180, borderRadius: 24),
        SizedBox(height: 16),
        ClaySkeletonLoader(width: double.infinity, height: 60, borderRadius: 16),
        SizedBox(height: 8),
        ClaySkeletonLoader(width: double.infinity, height: 60, borderRadius: 16),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.claySnack,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Color(0xFFEF4444),
                ),
                const SizedBox(height: 12),
                Text(
                  'Đã xảy ra lỗi tải dữ liệu',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 16),
                ClayButton(
                  text: 'Thử lại',
                  onPressed: () {
                    ref.invalidate(currentUserGuildStreamProvider);
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.clayLunch,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 3),
              ),
              child: const Center(
                child: Text('🛸', style: TextStyle(fontSize: 54)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Gia Nhập Bang Hội Vũ Trụ',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đừng theo đuổi mục tiêu một mình! Hãy cùng bạn bè lập đội thi đua, gánh vác thử thách hành tinh và cùng nhau tiến bộ mỗi ngày.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 32),
            ClayButton(
              key: const Key('create_guild_button'),
              text: '🚀 Khởi Tạo Bang Hội Mới',
              onPressed: () => GuildCreateSheet.show(context),
            ),
            const SizedBox(height: 12),
            ClayButton(
              key: const Key('join_guild_button'),
              text: '🔑 Nhập Mã Mời Của Bạn Bè',
              variant: ClayButtonVariant.outline,
              onPressed: () => GuildJoinSheet.show(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGuild(BuildContext context, WidgetRef ref, Guild guild) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final userMember = guild.findMember(currentUserId);
    final sortedMembers = [...guild.members]
      ..sort((a, b) => b.weeklyContributionXp.compareTo(a.weeklyContributionXp));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentUserGuildStreamProvider);
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Guild Header
          ClayCard(
            borderRadius: 24,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.clayLunch,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getPlanetIcon(guild.avatarPlanet),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  guild.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  guild.description.isNotEmpty
                                      ? guild.description
                                      : 'Cùng nhau giữ kỷ luật dinh dưỡng',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Governance Settings Button
                          IconButton(
                            key: const Key('guild_settings_button'),
                            icon: const Icon(Icons.settings_outlined, color: AppColors.onSurfaceVariant),
                            tooltip: 'Cài đặt bang hội',
                            onPressed: () => _showGuildGovernanceSheet(context, ref, guild, currentUserId),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.clayMint,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${guild.memberCount}/20 Thành viên',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.brandGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const Spacer(),
                          // Copy code button
                          InkWell(
                            key: const Key('copy_invite_code_button'),
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: guild.inviteCode));
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã sao chép mã mời: ${guild.inviteCode}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.outline),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    guild.inviteCode,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Planetary Challenge
          if (guild.activeChallenge != null) ...[
            PlanetaryChallengeCard(
              challenge: guild.activeChallenge!,
              userWeeklyContribution: userMember?.weeklyContributionXp ?? 0,
            ),
            const SizedBox(height: 20),
          ],

          // Member Leaderboard Section Header
          Row(
            children: [
              Text(
                'BẢNG XẾP HẠNG ĐÓNG GÓP',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const Spacer(),
              Text(
                '${sortedMembers.length} thành viên',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Chạm vào thành viên để quản lý vai trò hoặc tương tác',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 8),

          // Member List
          ...List.generate(sortedMembers.length, (index) {
            final member = sortedMembers[index];
            final rank = index + 1;
            final isMe = member.userId == currentUserId;
            return GuildMemberTile(
              member: member,
              rank: rank,
              isCurrentUser: isMe,
              onTap: () {
                MemberActionSheet.show(
                  context,
                  member: member,
                  guild: guild,
                  currentUserId: currentUserId,
                );
              },
              onNudge: () {
                HapticFeedback.mediumImpact();
                ref.read(guildControllerProvider.notifier).sendNudge(member.userId);
              },
            );
          }),
          const SizedBox(height: 24),

          // Leave Guild option
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.exit_to_app_rounded, size: 18, color: Color(0xFFEF4444)),
              label: const Text(
                'Rời khỏi bang hội này',
                style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600),
              ),
              onPressed: () => _confirmLeaveGuild(context, ref, guild, currentUserId),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showGuildGovernanceSheet(
    BuildContext context,
    WidgetRef ref,
    Guild guild,
    String currentUserId,
  ) {
    final canEdit = guild.canEditGuild(currentUserId);
    final canDisband = guild.canDisbandGuild(currentUserId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.fromLTRB(
              24,
              20,
              24,
              MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cài Đặt Bang Hội ⚙️',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quản trị thông tin và quyền hạn trong bang.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),

            if (canEdit) ...[
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
                title: const Text('Chỉnh sửa thông tin Bang Hội'),
                subtitle: const Text('Đổi tên, biểu tượng hành tinh và tuyên ngôn'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: AppColors.surfaceContainer,
                onTap: () {
                  Navigator.of(ctx).pop();
                  GuildEditSheet.show(context, guild: guild);
                },
              ),
              const SizedBox(height: 10),
            ],

            ListTile(
              leading: const Icon(Icons.share_rounded, color: AppColors.brandGreen),
              title: const Text('Sao chép mã mời bạn bè'),
              subtitle: Text('Mã: ${guild.inviteCode}'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: AppColors.surfaceContainer,
              onTap: () {
                Navigator.of(ctx).pop();
                Clipboard.setData(ClipboardData(text: guild.inviteCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã sao chép mã mời: ${guild.inviteCode}')),
                );
              },
            ),
            const SizedBox(height: 10),

            if (canDisband) ...[
              ListTile(
                leading: const Icon(Icons.delete_forever_rounded, color: Color(0xFFEF4444)),
                title: const Text(
                  'Giải tán Bang Hội',
                  style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Hành động này không thể hoàn tác'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: AppColors.surfaceContainer,
                onTap: () {
                  Navigator.of(ctx).pop();
                  _confirmDisbandGuild(context, ref, guild);
                },
              ),
            ],
          ],
        ),
      ),
    ),
  ),
);
}

  void _confirmDisbandGuild(BuildContext context, WidgetRef ref, Guild guild) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Giải Tán Bang Hội? ⚠️'),
        content: Text(
          'Bạn đang là Bang Chủ. Nếu giải tán "${guild.name}", toàn bộ thành viên sẽ bị loại bỏ và bang hội sẽ bị xoá vĩnh viễn. Bạn có chắc chắn?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(guildControllerProvider.notifier).disbandGuild();
            },
            child: const Text('Giải Tán', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  void _confirmLeaveGuild(BuildContext context, WidgetRef ref, Guild guild, String currentUserId) {
    final isLeader = guild.isLeader(currentUserId);
    final otherMembers = guild.members.where((m) => m.userId != currentUserId).isNotEmpty;

    if (isLeader && otherMembers) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Không Thể Rời Bang! 👑'),
          content: const Text(
            'Bạn đang giữ chức Bang Chủ. Vui lòng chuyển giao chức Bang Chủ cho thành viên khác trước khi rời bang, hoặc chọn Giải tán bang hội.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Đã Hiểu'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rời Bang Hội?'),
        content: const Text(
          'Bạn sẽ không còn cùng tiến độ với đồng đội trong thử thách tuần này. Bạn có chắc chắn muốn rời?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(guildControllerProvider.notifier).leaveGuild();
            },
            child: const Text('Rời Đi', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thể Lệ Thử Thách Vũ Trụ 🪐'),
        content: const Text(
          '1. Mỗi bữa ăn bạn ghi nhận hợp lệ sẽ đóng góp +50 Starlight XP vào quỹ điểm chung của Bang Hội.\n\n'
          '2. Hoàn thành mục tiêu tuần (50,000 XP) trước Chủ Nhật để mở khóa Huy Hiệu Hành Tinh cho toàn đội.\n\n'
          '3. Giữ vững ngọn lửa Streak để nhận thêm điểm thưởng và trở thành MVP của tuần!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đã Hiểu'),
          ),
        ],
      ),
    );
  }

  void _showCreateOrJoinMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tùy Chọn Bang Hội 🪐',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Khởi tạo bang hội mới hoặc gia nhập cùng nhóm bạn khác.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            ClayButton(
              text: '🚀 Khởi Tạo Bang Hội Của Riêng Bạn',
              onPressed: () {
                Navigator.of(ctx).pop();
                GuildCreateSheet.show(context);
              },
            ),
            const SizedBox(height: 12),
            ClayButton(
              text: '🔑 Nhập Mã Mời Của Bạn Bè',
              variant: ClayButtonVariant.outline,
              onPressed: () {
                Navigator.of(ctx).pop();
                GuildJoinSheet.show(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getPlanetIcon(String planet) {
    switch (planet.toLowerCase()) {
      case 'mars':
        return '🔴';
      case 'venus':
        return '🟡';
      case 'jupiter':
        return '🟠';
      case 'saturn':
        return '🪐';
      case 'neptune':
        return '🔵';
      default:
        return '🚀';
    }
  }
}
