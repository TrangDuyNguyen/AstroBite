import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'guild_create_sheet.dart';
import 'guild_join_sheet.dart';

/// Empty state when user hasn't joined any guild yet.
class GuildEmptyView extends StatelessWidget {
  const GuildEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.clayLunch,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25), width: 2.5),
              ),
              child: const Center(
                child: Clay3DCarrotRocket(size: 64),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Gia Nhập Bang Hội Vũ Trụ',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đừng theo đuổi mục tiêu một mình! Hãy cùng bạn bè lập đội thi đua, gánh vác thử thách hành tinh và cùng nhau tiến bộ mỗi ngày.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 32),
            ClayButton(
              key: const Key('create_guild_button'),
              width: double.infinity,
              height: 52,
              icon: const Clay3DCarrotRocket(size: 22),
              text: 'Khởi Tạo Bang Hội Mới',
              onPressed: () => GuildCreateSheet.show(context),
            ),
            const SizedBox(height: 12),
            ClayButton(
              key: const Key('join_guild_button'),
              width: double.infinity,
              height: 52,
              variant: ClayButtonVariant.outline,
              icon: const Clay3DShield(size: 20),
              text: 'Nhập Mã Mời Của Bạn Bè',
              onPressed: () => GuildJoinSheet.show(context),
            ),
          ],
        ),
      ),
    );
  }
}
