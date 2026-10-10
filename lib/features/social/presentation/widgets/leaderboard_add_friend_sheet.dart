import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Modal bottom sheet for connecting with a friend via Astro ID.
class LeaderboardAddFriendSheet extends StatefulWidget {
  const LeaderboardAddFriendSheet({
    super.key,
    required this.onAddFriend,
  });

  final ValueChanged<String> onAddFriend;

  static void show(BuildContext context, {required ValueChanged<String> onAddFriend}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LeaderboardAddFriendSheet(onAddFriend: onAddFriend),
    );
  }

  @override
  State<LeaderboardAddFriendSheet> createState() => _LeaderboardAddFriendSheetState();
}

class _LeaderboardAddFriendSheetState extends State<LeaderboardAddFriendSheet> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x20000000),
            offset: Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '🚀 Kết Nối Bạn Bè',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nhập mã Astro ID của bạn bè để cùng đua chuỗi và nhắc nhở nhau kỷ luật.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.outline.withValues(alpha: 0.8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _textController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                icon: Icon(Icons.tag_rounded, color: AppColors.primary),
                hintText: 'Ví dụ: AST-9921',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ClayButton(
            text: 'Xác Nhận Kết Bạn',
            variant: ClayButtonVariant.primary,
            width: double.infinity,
            onPressed: () {
              final id = _textController.text.trim();
              if (id.isNotEmpty) {
                Navigator.of(context).pop();
                widget.onAddFriend(id);
              }
            },
          ),
        ],
      ),
    );
  }
}
