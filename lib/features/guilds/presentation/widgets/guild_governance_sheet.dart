import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';
import 'guild_edit_sheet.dart';

/// Modal bottom sheet for guild settings, governance, invite code copy and disband.
class GuildGovernanceSheet extends StatelessWidget {
  const GuildGovernanceSheet({
    super.key,
    required this.guild,
    required this.currentUserId,
    required this.onDisband,
  });

  final Guild guild;
  final String currentUserId;
  final VoidCallback onDisband;

  static void show(
    BuildContext context, {
    required Guild guild,
    required String currentUserId,
    required VoidCallback onDisband,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GuildGovernanceSheet(
        guild: guild,
        currentUserId: currentUserId,
        onDisband: onDisband,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = guild.canEditGuild(currentUserId);
    final canDisband = guild.canDisbandGuild(currentUserId);

    return SafeArea(
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
            MediaQuery.of(context).viewInsets.bottom + 24,
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
              Row(
                children: [
                  const Clay3DShield(size: 26),
                  const SizedBox(width: 10),
                  Text(
                    'Cài Đặt Bang Hội',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Quản trị thông tin và quyền hạn trong bang.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 16),

              if (canEdit) ...[
                ListTile(
                  leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
                  title: const Text('Chỉnh sửa thông tin Bang Hội', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text('Đổi tên, biểu tượng hành tinh và tuyên ngôn'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  tileColor: AppColors.surfaceContainer,
                  onTap: () {
                    Navigator.of(context).pop();
                    GuildEditSheet.show(context, guild: guild);
                  },
                ),
                const SizedBox(height: 10),
              ],

              ListTile(
                leading: const Icon(Icons.share_rounded, color: AppColors.brandGreen),
                title: const Text('Sao chép mã mời bạn bè', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('Mã: ${guild.inviteCode}'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: AppColors.surfaceContainer,
                onTap: () {
                  Navigator.of(context).pop();
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
                    style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text('Hành động này không thể hoàn tác'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  tileColor: AppColors.surfaceContainer,
                  onTap: () {
                    Navigator.of(context).pop();
                    onDisband();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
