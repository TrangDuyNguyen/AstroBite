import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_providers.dart';
import '../widgets/bmr_tdee_card.dart';
import '../widgets/profile_ecosystem_card.dart';
import '../widgets/profile_hero_card.dart';
import '../widgets/profile_metrics_card.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    final profile = profileAsync.valueOrNull ?? UserProfile.defaultProfile(user?.uid ?? '');

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ClayAppBar(
        title: AppStrings.profile,
        centerTitle: true,
        actions: [
          ClayIconButton(
            size: 40,
            borderRadius: 14,
            icon: Icons.tune_rounded,
            tooltip: 'Chỉnh sửa hồ sơ',
            onPressed: () => context.router.push(const ProfileEditRoute()),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
          children: [
            const SizedBox(height: AppValues.spacing8),

            // Offline Banner
            if (profileAsync.hasError && profileAsync.hasValue)
              Container(
                margin: const EdgeInsets.only(bottom: AppValues.spacing16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.clayBreakfast,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off_rounded, color: AppColors.tertiary, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Đang xem dữ liệu ngoại tuyến',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 1. Hero Profile Clay Card
            ProfileHeroCard(
              user: user,
              profile: profile,
              isEditDisabled: profileAsync.hasError,
              onEditPressed: () => context.router.push(const ProfileEditRoute()),
            ),

            const SizedBox(height: AppValues.spacing20),

            // 2. BMR & TDEE Indicator Card
            BmrTdeeCard(profile: profile),

            const SizedBox(height: AppValues.spacing20),

            // 3. Biological Metrics Grid Card
            ProfileMetricsCard(
              profile: profile,
              isEditDisabled: profileAsync.hasError,
              onEditPressed: () => context.router.push(const ProfileEditRoute()),
            ),

            const SizedBox(height: AppValues.spacing20),

            // 4. AstroBite Ecosystem & Integrations Card
            const ProfileEcosystemCard(),

            const SizedBox(height: AppValues.spacing24),

            // 5. Sign Out Button
            ClayButton(
              text: 'Đăng xuất',
              height: 50,
              borderRadius: 20,
              variant: ClayButtonVariant.outline,
              icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) context.router.replaceAll([const LoginRoute()]);
              },
            ),

            // Spacing to clear floating dock navigation bar
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
