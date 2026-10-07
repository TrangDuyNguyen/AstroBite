import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';
import '../../domain/models/guild_member.dart';
import '../controllers/guild_controller.dart';

class MemberActionSheet extends ConsumerWidget {
  final GuildMember member;
  final Guild guild;
  final String currentUserId;

  const MemberActionSheet({
    super.key,
    required this.member,
    required this.guild,
    required this.currentUserId,
  });

  static Future<void> show(
    BuildContext context, {
    required GuildMember member,
    required Guild guild,
    required String currentUserId,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MemberActionSheet(
        member: member,
        guild: guild,
        currentUserId: currentUserId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = member.userId == currentUserId;
    final canKick = guild.canKick(currentUserId, member.userId);
    final canPromoteOrDemote = guild.canPromoteOrDemote(currentUserId) && !isMe;
    final canTransfer = guild.canTransferLeadership(currentUserId) && !isMe;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
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
          const SizedBox(height: 18),

          // Member Header Card
          ClayCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            backgroundColor: AppColors.surfaceContainer,
            child: Row(
              children: [
                // Avatar
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

                // Info
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
                          _buildRoleBadge(context, member.role),
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
                          Container(width: 3, height: 3, decoration: const BoxDecoration(color: AppColors.outline, shape: BoxShape.circle)),
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
          ),
          const SizedBox(height: 18),

          // Actions
          if (!isMe) ...[
            // Nudge Action
            ListTile(
              leading: const Icon(Icons.notifications_active_rounded, color: AppColors.primary),
              title: const Text('Nhắc nhở giữ streak'),
              subtitle: const Text('Gửi tín hiệu cổ vũ đồng đội ăn đúng giờ'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: AppColors.surfaceContainer,
              onTap: () {
                Navigator.of(context).pop();
                HapticFeedback.lightImpact();
                ref.read(guildControllerProvider.notifier).sendNudge(member.userId);
              },
            ),
            const SizedBox(height: 10),

            // Promote / Demote Action
            if (canPromoteOrDemote) ...[
              if (member.isElder)
                ListTile(
                  leading: const Icon(Icons.arrow_downward_rounded, color: AppColors.tertiary),
                  title: const Text('Miễn nhiệm Phó Bang'),
                  subtitle: const Text('Hạ cấp về vị trí Thành viên thường'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  tileColor: AppColors.surfaceContainer,
                  onTap: () async {
                    Navigator.of(context).pop();
                    await ref.read(guildControllerProvider.notifier).updateMemberRole(
                          targetUserId: member.userId,
                          newRole: 'member',
                        );
                  },
                )
              else if (member.role == 'member')
                ListTile(
                  leading: const Icon(Icons.military_tech_rounded, color: AppColors.primary),
                  title: const Text('Bổ nhiệm làm Phó Bang (Elder)'),
                  subtitle: const Text('Cấp quyền quản lý thành viên & chỉnh sửa thông tin'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  tileColor: AppColors.surfaceContainer,
                  onTap: () async {
                    Navigator.of(context).pop();
                    await ref.read(guildControllerProvider.notifier).updateMemberRole(
                          targetUserId: member.userId,
                          newRole: 'elder',
                        );
                  },
                ),
              const SizedBox(height: 10),
            ],

            // Transfer Leadership Action
            if (canTransfer) ...[
              ListTile(
                leading: const Icon(Icons.workspace_premium_rounded, color: Color(0xFF7C3AED)),
                title: const Text(
                  'Chuyển giao quyền Bang Chủ',
                  style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Bạn sẽ lùi lại làm Phó Bang'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: AppColors.surfaceContainer,
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmTransfer(context, ref);
                },
              ),
              const SizedBox(height: 10),
            ],

            // Kick Member Action
            if (canKick) ...[
              ListTile(
                leading: const Icon(Icons.person_remove_rounded, color: Color(0xFFEF4444)),
                title: const Text(
                  'Mời rời khỏi Bang Hội',
                  style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Xóa thành viên khỏi danh sách bang hội'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: AppColors.surfaceContainer,
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmKick(context, ref);
                },
              ),
            ],
          ] else ...[
            // Current user clicked their own tile
            ListTile(
              leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
              title: const Text('Đây là hồ sơ của bạn'),
              subtitle: Text(
                member.isLeader
                    ? 'Bạn đang là Bang Chủ. Hãy dẫn dắt các đồng đội!'
                    : member.isElder
                        ? 'Bạn là Phó Bang, hãy hỗ trợ quản lý thành viên.'
                        : 'Đóng góp thêm XP mỗi bữa ăn để thăng cấp!',
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: AppColors.surfaceContainer,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context, String role) {
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

  void _confirmTransfer(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chuyển Giao Bang Chủ', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text(
          'Bạn có chắc chắn muốn chuyển giao toàn bộ quyền Bang Chủ cho "${member.displayName}"? '
          'Sau khi chuyển giao, bạn sẽ trở thành Phó Bang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(guildControllerProvider.notifier).transferLeadership(member.userId);
            },
            child: const Text('Xác Nhận Chuyển Giao', style: TextStyle(color: Color(0xFF7C3AED))),
          ),
        ],
      ),
    );
  }

  void _confirmKick(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mời Rời Bang Hội'),
        content: Text('Bạn có chắc chắn muốn loại thành viên "${member.displayName}" khỏi bang hội?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(guildControllerProvider.notifier).kickMember(member.userId);
            },
            child: const Text('Đồng Ý Loại', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }
}
