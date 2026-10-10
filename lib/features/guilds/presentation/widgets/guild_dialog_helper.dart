import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';
import 'guild_create_sheet.dart';
import 'guild_join_sheet.dart';

/// Static helper for displaying Guild confirmation dialogs, rules, and menus.
class GuildDialogHelper {
  const GuildDialogHelper._();

  static void confirmDisbandGuild(
    BuildContext context, {
    required Guild guild,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Giải Tán Bang Hội?', style: TextStyle(fontWeight: FontWeight.w900)),
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
              onConfirm();
            },
            child: const Text('Giải Tán', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void confirmLeaveGuild(
    BuildContext context, {
    required Guild guild,
    required String currentUserId,
    required VoidCallback onConfirm,
  }) {
    final isLeader = guild.isLeader(currentUserId);
    final otherMembers = guild.members.where((m) => m.userId != currentUserId).isNotEmpty;

    if (isLeader && otherMembers) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Không Thể Rời Bang!', style: TextStyle(fontWeight: FontWeight.w900)),
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
        title: const Text('Rời Bang Hội?', style: TextStyle(fontWeight: FontWeight.w900)),
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
              onConfirm();
            },
            child: const Text('Rời Đi', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Clay3DPlanet(planet: 'saturn', size: 24),
            SizedBox(width: 8),
            Text('Thể Lệ Thử Thách', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
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

  static void showCreateOrJoinMenu(BuildContext context) {
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
            Row(
              children: [
                const Clay3DPlanet(planet: 'saturn', size: 28),
                const SizedBox(width: 10),
                Text(
                  'Tùy Chọn Bang Hội',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Khởi tạo bang hội mới hoặc gia nhập cùng nhóm bạn khác.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 20),
            ClayButton(
              width: double.infinity,
              height: 52,
              icon: const Clay3DCarrotRocket(size: 22),
              text: 'Khởi Tạo Bang Hội Mới',
              onPressed: () {
                Navigator.of(ctx).pop();
                GuildCreateSheet.show(context);
              },
            ),
            const SizedBox(height: 12),
            ClayButton(
              width: double.infinity,
              height: 52,
              variant: ClayButtonVariant.outline,
              icon: const Clay3DShield(size: 20),
              text: 'Nhập Mã Mời Của Bạn Bè',
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
}
