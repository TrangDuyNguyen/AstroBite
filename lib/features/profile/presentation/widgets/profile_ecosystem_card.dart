import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import 'home_widget_guide_sheet.dart';

class ProfileEcosystemCard extends ConsumerWidget {
  const ProfileEcosystemCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cấu hình Gemini AI',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 20),
                tooltip: 'Cài đặt API Key',
                onPressed: () => GeminiApiKeyDialog.show(context),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Gemini API Key Tile
          Consumer(
            builder: (context, ref, _) {
              final keyState = ref.watch(geminiApiKeyServiceProvider);
              return _MenuTile(
                icon: '🔑',
                title: keyState.isUsingCustomKey
                    ? 'Key cá nhân: ${keyState.maskedActiveKey}'
                    : keyState.hasKey
                        ? 'AstroBite AI: Đã kích hoạt'
                        : 'Chưa cấu hình API Key',
                subtitle: keyState.isUsingCustomKey
                    ? 'Đang dùng key tùy chỉnh • Nhấn để thay đổi'
                    : keyState.hasKey
                        ? 'Hệ thống AI tích hợp sẵn sàng • Tùy chọn nâng cao'
                        : 'Nhấn để thêm key miễn phí từ AI Studio',
                iconBg: keyState.hasKey ? AppColors.clayMint : AppColors.claySnack,
                onTap: () => GeminiApiKeyDialog.show(context),
              );
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: Color(0xFFF0EFEB), height: 1),
          ),

          // AI Coach
          _MenuTile(
            icon: '🤖',
            title: 'AI Coach',
            subtitle: 'Tư vấn chế độ ăn uống thông minh',
            iconBg: AppColors.clayLunch,
            onTap: () => context.router.push(const CoachRoute()),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: Color(0xFFF0EFEB), height: 1),
          ),

          // Health Integration
          _MenuTile(
            icon: '🏃',
            title: 'Kết nối Sức khỏe',
            subtitle: 'Đồng bộ Apple Health / Health Connect',
            iconBg: AppColors.clayMint,
            onTap: () => context.router.push(const HealthConnectionRoute()),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: Color(0xFFF0EFEB), height: 1),
          ),

          // Home Widget
          _MenuTile(
            icon: '📱',
            title: 'Tiện ích Màn hình chính (Widget)',
            subtitle: 'Xem nhanh Calo/Macro & Quét AI 1-chạm',
            iconBg: AppColors.clayBreakfast,
            onTap: () => HomeWidgetGuideSheet.show(context),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: Color(0xFFF0EFEB), height: 1),
          ),

          // Recipe Catalog
          _MenuTile(
            icon: '🍲',
            title: 'Công thức món ăn',
            subtitle: 'Quản lý công thức cá nhân & co giãn khẩu phần',
            iconBg: AppColors.clayLunch,
            onTap: () => context.router.push(const RecipesRoute()),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: Color(0xFFF0EFEB), height: 1),
          ),

          // Meal Planner
          _MenuTile(
            icon: '📅',
            title: 'Kế hoạch thực đơn 7 ngày',
            subtitle: 'Lên lịch bữa ăn & 1-chạm nạp nhật ký',
            iconBg: AppColors.clayBreakfast,
            onTap: () => context.router.push(const MealPlannerRoute()),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(color: Color(0xFFF0EFEB), height: 1),
          ),

          // Social Guilds
          _MenuTile(
            icon: '🪐',
            title: 'Bang Hội Vũ Trụ',
            subtitle: 'Lập đội thi đua & Thử thách hành tinh tuần',
            iconBg: AppColors.clayMint,
            onTap: () => context.router.push(const GuildRoute()),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final Color iconBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
