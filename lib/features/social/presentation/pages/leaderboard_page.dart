import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/social/presentation/controllers/social_controller.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../widgets/leaderboard_add_friend_sheet.dart';
import '../widgets/leaderboard_my_id_card.dart';
import '../widgets/leaderboard_nudge_sheet.dart';
import '../widgets/leaderboard_user_card.dart';

/// Giao diện Bảng Xếp Hạng Bạn Bè (Astro Leaderboard) & Streak Nudge — Gate 4
@RoutePage()
class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  static const String _myAstroId = '#ASTRO-8821';

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
            onPressed: () => LeaderboardAddFriendSheet.show(
              context,
              onAddFriend: (id) => ref.read(socialControllerProvider.notifier).addFriend(id),
            ),
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
            const LeaderboardMyIdCard(myAstroId: _myAstroId),
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
              ...leaderboard.map(
                (user) => LeaderboardUserCard(
                  user: user,
                  onNudge: () => LeaderboardNudgeSheet.show(
                    context,
                    user: user,
                    onConfirmNudge: () => ref
                        .read(socialControllerProvider.notifier)
                        .nudgeFriend(user.astroId, user.name),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const LeaderboardMyIdCard(myAstroId: _myAstroId),
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
            onPressed: () => LeaderboardAddFriendSheet.show(
              context,
              onAddFriend: (id) => ref.read(socialControllerProvider.notifier).addFriend(id),
            ),
          ),
        ],
      ),
    );
  }
}
