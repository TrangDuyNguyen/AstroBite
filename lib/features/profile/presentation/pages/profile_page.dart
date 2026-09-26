import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_providers.dart';
import '../widgets/bmr_tdee_card.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final user = ref.watch(authStateProvider).value;

    final profile = profileAsync.value ?? UserProfile.defaultProfile(user?.uid ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.router.push(const ProfileEditRoute()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    child: Text(
                      user?.email?.isNotEmpty == true ? user!.email![0].toUpperCase() : '👤',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: AppValues.spacing12),
                  Text(
                    user?.email ?? 'Chưa đăng nhập',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.spacing24),
            BmrTdeeCard(profile: profile),
            const SizedBox(height: AppValues.spacing24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppValues.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thông số cá nhân', style: Theme.of(context).textTheme.titleMedium),
                    const Divider(height: AppValues.spacing16),
                    _InfoRow(label: 'Giới tính', value: profile.gender == 'male' ? 'Nam' : 'Nữ'),
                    _InfoRow(label: 'Năm sinh', value: '${profile.birthYear} (${profile.age} tuổi)'),
                    _InfoRow(label: 'Chiều cao', value: '${profile.heightCm.round()} cm'),
                    _InfoRow(label: 'Cân nặng', value: '${profile.weightKg} kg'),
                    _InfoRow(label: 'Mức độ vận động', value: profile.activityLevel),
                    _InfoRow(label: 'Mục tiêu Calo/ngày', value: '${profile.dailyTargetCalories} kcal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppValues.spacing24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppValues.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cấu hình Gemini AI', style: Theme.of(context).textTheme.titleMedium),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined, size: 20),
                          tooltip: 'Cài đặt API Key',
                          onPressed: () => GeminiApiKeyDialog.show(context),
                        ),
                      ],
                    ),
                    const Divider(height: AppValues.spacing16),
                    Consumer(
                      builder: (context, ref, _) {
                        final keyState = ref.watch(geminiApiKeyServiceProvider);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: keyState.hasKey
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.error.withValues(alpha: 0.15),
                            child: Icon(
                              Icons.vpn_key_rounded,
                              color: keyState.hasKey ? AppColors.success : AppColors.error,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            keyState.isUsingCustomKey
                                ? 'Key cá nhân: ${keyState.maskedActiveKey}'
                                : keyState.hasKey
                                    ? 'AstroBite AI: Đã kích hoạt'
                                    : 'Chưa cấu hình API Key',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Text(
                            keyState.isUsingCustomKey
                                ? 'Đang dùng key tùy chỉnh • Nhấn để thay đổi'
                                : keyState.hasKey
                                    ? 'Hệ thống AI tích hợp sẵn sàng • Tùy chọn nâng cao'
                                    : 'Nhấn để thêm key miễn phí từ AI Studio',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => GeminiApiKeyDialog.show(context),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                        child: const Text('🤖', style: TextStyle(fontSize: 18)),
                      ),
                      title: const Text('AI Coach', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(
                        'Tư vấn chế độ ăn uống thông minh',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.router.push(const CoachRoute()),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
                        child: const Text('🏃', style: TextStyle(fontSize: 18)),
                      ),
                      title: const Text('Kết nối Sức khỏe', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(
                        'Đồng bộ Apple Health / Health Connect',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.router.push(const HealthConnectionRoute()),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.tertiary.withValues(alpha: 0.15),
                        child: const Text('📱', style: TextStyle(fontSize: 18)),
                      ),
                      title: const Text('Tiện ích Màn hình chính (Widget)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(
                        'Xem nhanh Calo/Macro & Quét AI 1-chạm',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showWidgetGuideSheet(context, ref),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppValues.spacing24),
            OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) context.router.replaceAll([const LoginRoute()]);
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('Đăng xuất', style: TextStyle(color: Colors.redAccent)),
            ),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  void _showWidgetGuideSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppValues.cardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: AppValues.spacing16),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.surfaceContainer,
                      child: Text('📱', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: AppValues.spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tiện ích Màn hình chính',
                            style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'AstroBite Quick Glance & AI Scan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppValues.spacing16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚡ Ghim nhanh Widget (Android 8.0+)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Hệ thống sẽ mở hộp thoại xác nhận thêm widget AstroBite trực tiếp ra màn hình chờ.',
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () async {
                            final success = await ref.read(widgetSyncServiceProvider).requestPinWidget();
                            if (ctx.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? '✨ Đã gửi yêu cầu ghim Widget ra màn hình chính!'
                                      : '💡 Thiết bị chưa hỗ trợ ghim tự động. Vui lòng thêm thủ công theo hướng dẫn bên dưới.'),
                                  backgroundColor: AppColors.surfaceContainer,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.push_pin_outlined, size: 18),
                          label: const Text('Ghim Widget Ngay', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppValues.spacing16),
                Text('📖 Hướng dẫn thêm thủ công', style: Theme.of(ctx).textTheme.titleSmall),
                const SizedBox(height: 8),
                const Text(
                  '• Android: Nhấn giữ khoảng trống trên Màn hình chính ➔ Chọn "Tiện ích" (Widgets) ➔ Tìm "AstroBite" ➔ Chạm giữ và kéo ra màn hình.\n\n• iOS: Nhấn giữ khoảng trống trên Màn hình chính ➔ Nhấn biểu tượng "+" góc trên ➔ Tìm "AstroBite" ➔ Chọn kích thước Widget và nhấn "Thêm tiện ích".',
                  style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppValues.spacing16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
