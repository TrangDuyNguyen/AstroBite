import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../domain/entities/user_profile.dart';
import '../domain/profile_providers.dart';
import 'widgets/bmr_tdee_card.dart';

@RoutePage()
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
