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
                            keyState.isUsingEnvKey
                                ? 'Key hệ thống (.env): ${keyState.maskedActiveKey}'
                                : keyState.isUsingCustomKey
                                    ? 'Key cá nhân: ${keyState.maskedActiveKey}'
                                    : 'Chưa cấu hình API Key',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Text(
                            keyState.hasKey
                                ? 'Nhấn để thay đổi hoặc kiểm tra key'
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
          ],
        ),
      ),
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
