import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';
import 'package:astrobite/features/social/presentation/controllers/social_controller.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Giao diện Bảng Xếp Hạng Bạn Bè (Astro Leaderboard) & Streak Nudge — Gate 4
@RoutePage()
class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  final String _myAstroId = '#ASTRO-8821';

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
                final id = textController.text.trim();
                if (id.isNotEmpty) {
                  Navigator.of(ctx).pop();
                  ref.read(socialControllerProvider.notifier).addFriend(id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNudgeConfirmationSheet(LeaderboardEntry user) {
    showModalBottomSheet(
      context: context,
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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2D6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('🔥', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Cứu Streak Bạn Bè',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Gửi một tín hiệu nhắc nhở tới ${user.name} để bảo vệ chuỗi kỷ luật 🔥 ${user.streak} ngày trước khi hết ngày hôm nay!',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ClayButton(
                    text: 'Hủy',
                    variant: ClayButtonVariant.outline,
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: ClayButton(
                    text: 'Gửi Tín Hiệu',
                    variant: ClayButtonVariant.primary,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ref
                          .read(socialControllerProvider.notifier)
                          .nudgeFriend(user.astroId, user.name);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe thông báo lỗi hoặc thành công từ Controller
    ref.listen<SocialActionState>(socialControllerProvider, (prev, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Text(next.errorMessage!),
          ),
        );
        ref.read(socialControllerProvider.notifier).clearMessages();
      } else if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.brandGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Text(next.successMessage!),
          ),
        );
        ref.read(socialControllerProvider.notifier).clearMessages();
      }
    });

    final leaderboardAsync = ref.watch(leaderboardStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ClayAppBar(
        title: 'Bảng Xếp Hạng',
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Bang Hội Vũ Trụ',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.brandGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Text('🪐', style: TextStyle(fontSize: 16)),
            ),
            onPressed: () => context.router.push(const GuildRoute()),
          ),
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
      body: leaderboardAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, _) => _buildErrorState(error),
        data: (leaderboard) => ListView(
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
                  '${leaderboard.length} người',
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
            if (leaderboard.isEmpty)
              _buildEmptyState()
            else
              ...leaderboard.map((user) => _buildLeaderboardCard(user)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMyAstroIdCard(),
        const SizedBox(height: 24),
        ...List.generate(
          5,
          (index) => const ClaySkeletonLoader(height: 76, borderRadius: 20),
        ),
      ],
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.secondary),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải Bảng Xếp Hạng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            ClayButton(
              text: 'Thử Lại',
              variant: ClayButtonVariant.primary,
              width: 140,
              onPressed: () => ref.refresh(leaderboardStreamProvider),
            ),
          ],
        ),
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

  Widget _buildLeaderboardCard(LeaderboardEntry user) {
    final rank = user.rank;
    final isTop1 = rank == 1;
    final isMe = user.isMe;

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
                  user.name,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: (isTop1 || isMe) ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                Text(
                  user.astroId,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Chỉ báo Streak
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '${user.streak}d',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Tương tác: Đạt chuẩn vs Nudge (Cứu Streak)
          if (isMe)
            const SizedBox.shrink()
          else if (user.goalAchievedToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F9D8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Đạt chuẩn ✨',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else if (user.isNudgedToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EEE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Đã nhắc',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            InkWell(
              onTap: () => _showNudgeConfirmationSheet(user),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2D6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD580)),
                ),
                child: const Row(
                  children: [
                    Text('⚡', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 2),
                    Text(
                      'Nhắc',
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
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
}
