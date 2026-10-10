import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';
import '../controllers/guild_controller.dart';
import '../widgets/guild_dialog_helper.dart';
import '../widgets/guild_empty_view.dart';
import '../widgets/guild_governance_sheet.dart';
import '../widgets/guild_header_card.dart';
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
            onPressed: () => GuildDialogHelper.showCreateOrJoinMenu(context),
          ),
          IconButton(
            key: const Key('guild_info_button'),
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.onSurfaceVariant),
            tooltip: 'Thể lệ thử thách',
            onPressed: () => GuildDialogHelper.showRulesDialog(context),
          ),
        ],
      ),
      body: guildAsync.when(
        loading: () => _buildShimmerLoading(),
        error: (err, _) => _buildErrorState(context, ref, err.toString()),
        data: (guild) {
          if (guild == null) {
            return const GuildEmptyView();
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
                onPressed: () => ref.invalidate(currentUserGuildStreamProvider),
              ),
            ],
          ),
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
      onRefresh: () async => ref.invalidate(currentUserGuildStreamProvider),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Guild Header
          GuildHeaderCard(
            guild: guild,
            onOpenGovernance: () => GuildGovernanceSheet.show(
              context,
              guild: guild,
              currentUserId: currentUserId,
              onDisband: () => GuildDialogHelper.confirmDisbandGuild(
                context,
                guild: guild,
                onConfirm: () => ref.read(guildControllerProvider.notifier).disbandGuild(),
              ),
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
              onTap: () => MemberActionSheet.show(
                context,
                member: member,
                guild: guild,
                currentUserId: currentUserId,
              ),
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
              onPressed: () => GuildDialogHelper.confirmLeaveGuild(
                context,
                guild: guild,
                currentUserId: currentUserId,
                onConfirm: () => ref.read(guildControllerProvider.notifier).leaveGuild(),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
