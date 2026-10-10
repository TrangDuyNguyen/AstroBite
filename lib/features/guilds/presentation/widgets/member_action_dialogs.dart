import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/guild_member.dart';
import '../controllers/guild_controller.dart';

/// Confirmation dialogs for transferring leadership or kicking a member.
class MemberActionDialogs {
  const MemberActionDialogs._();

  static void confirmTransfer({
    required BuildContext context,
    required WidgetRef ref,
    required GuildMember member,
  }) {
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

  static void confirmKick({
    required BuildContext context,
    required WidgetRef ref,
    required GuildMember member,
  }) {
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
