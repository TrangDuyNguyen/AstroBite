import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Giao diện Bảng Xếp Hạng Bạn Bè (Astro Leaderboard) & Thêm Bạn - Gate 4
@RoutePage()
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  // Mã Astro ID của chính người dùng
  final String _myAstroId = '#ASTRO-8821';

  // Danh sách bạn bè trên Leaderboard (có thể thêm mới)
  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'AlexD', 'streak': 45, 'rank': 1, 'astroId': '#AST-0042'},
    {'name': 'TrangNguyen (Bạn)', 'streak': 42, 'rank': 2, 'astroId': '#ASTRO-8821'},
    {'name': 'JohnSmith', 'streak': 30, 'rank': 3, 'astroId': '#AST-9912'},
    {'name': 'AstroDev', 'streak': 12, 'rank': 4, 'astroId': '#AST-3310'},
    {'name': 'LazyPanda', 'streak': 5, 'rank': 5, 'astroId': '#AST-1002'},
  ];

  void _addFriend(String astroId) {
    final cleanId = astroId.trim().toUpperCase();
    if (cleanId.isEmpty) return;

    setState(() {
      _leaderboard.add({
        'name': 'Phi hành gia $cleanId',
        'streak': 1,
        'rank': _leaderboard.length + 1,
        'astroId': cleanId.startsWith('#') ? cleanId : '#$cleanId',
      });
      // Sắp xếp lại theo streak giảm dần
      _leaderboard.sort((a, b) => (b['streak'] as int).compareTo(a['streak'] as int));
      for (int i = 0; i < _leaderboard.length; i++) {
        _leaderboard[i]['rank'] = i + 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.brandGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text('🎉 Đã kết bạn thành công với $cleanId!'),
      ),
    );
  }

  void _showAddFriendSheet() {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
          MediaQuery.of(ctx).viewInsets.bottom + 24,
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
              'Nhập mã Astro ID của bạn bè để cùng theo dõi tiến độ kỷ luật.',
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
                controller: textController,
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
                final id = textController.text;
                if (id.trim().isNotEmpty) {
                  Navigator.of(ctx).pop();
                  _addFriend(id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ClayAppBar(
        title: 'Bảng Xếp Hạng',
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Thêm bạn bè',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: _showAddFriendSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Thẻ hiển thị Astro ID của tôi
          _buildMyAstroIdCard(),
          const SizedBox(height: 16),

          // 2. Tiêu đề danh sách
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thành Viên Thử Thách',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                '${_leaderboard.length} người',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Danh sách xếp hạng
          if (_leaderboard.isEmpty)
            _buildEmptyState()
          else
            ..._leaderboard.map((user) => _buildLeaderboardCard(user)),
        ],
      ),
    );
  }

  Widget _buildMyAstroIdCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F6FD),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            alignment: Alignment.center,
            child: const Text('🚀', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Astro ID của bạn',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _myAstroId,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: _myAstroId));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  content: const Text('📋 Đã sao chép mã Astro ID của bạn!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.copy_rounded, size: 14, color: AppColors.onSurface),
                  SizedBox(width: 4),
                  Text(
                    'Sao chép',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const Text('👩‍🚀', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'Bạn chưa có ai để so tài',
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          ClayButton(
            text: 'Thêm Bạn Ngay',
            variant: ClayButtonVariant.primary,
            width: 180,
            onPressed: _showAddFriendSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(Map<String, dynamic> user) {
    final rank = user['rank'] as int;
    final isTop1 = rank == 1;
    final isMe = (user['name'] as String).contains('(Bạn)');

    Color bgColor = isMe
        ? const Color(0xFFF0F9FF)
        : (isTop1 ? const Color(0xFFFFF2D6) : AppColors.surfaceContainer);

    String rankStr = rank.toString();
    if (rank == 1) {
      rankStr = '👑';
    } else if (rank == 2) {
      rankStr = '🥈';
    } else if (rank == 3) {
      rankStr = '🥉';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMe
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.outline.withValues(alpha: 0.5),
          width: isMe ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              rankStr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] as String,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: (isTop1 || isMe) ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                if (user['astroId'] != null)
                  Text(
                    user['astroId'] as String,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${user['streak']} ngày',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
