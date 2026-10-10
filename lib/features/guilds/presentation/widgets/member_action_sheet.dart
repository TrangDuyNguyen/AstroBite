import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';
import '../../domain/models/guild_member.dart';
import '../controllers/guild_controller.dart';
import 'member_action_dialogs.dart';
import 'member_action_header_card.dart';

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
          MemberActionHeaderCard(member: member),
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
                  MemberActionDialogs.confirmTransfer(
                    context: context,
                    ref: ref,
                    member: member,
                  );
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
                  MemberActionDialogs.confirmKick(
                    context: context,
                    ref: ref,
                    member: member,
                  );
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
}
