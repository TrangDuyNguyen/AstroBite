import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_providers.dart';
import '../widgets/bmr_tdee_card.dart';

@RoutePage()
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  String _translateActivityLevel(String level) {
    return switch (level) {
      'sedentary' => 'Ít vận động',
      'light' => 'Nhẹ (1-3 ngày)',
      'moderate' => 'Vừa phải (3-5 ngày)',
      'active' => 'Năng động (6-7 ngày)',
      'very_active' => 'Rất năng động',
      _ => level,
    };
  }

  String _translateFitnessGoal(String? goal) {
    return switch (goal) {
      'lose_weight' => 'Giảm mỡ',
      'maintain' => 'Duy trì cân nặng',
      'gain_muscle' => 'Tăng cơ',
      _ => goal ?? 'Duy trì cân nặng',
    };
  }

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
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: AppColors.tertiary, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
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
            ClayCard(
              borderRadius: 22,
              elevation: 4,
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Tactile 3D Avatar
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF38BDF8),
                              AppColors.primary,
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x301CB0F6),
                              offset: Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user?.email?.isNotEmpty == true
                              ? user!.email![0].toUpperCase()
                              : '👤',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.email ?? 'Chưa đăng nhập',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: AppColors.onSurface,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.clayLunch,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.25),
                                    ),
                                  ),
                                  child: Text(
                                    '🎯 ${_translateFitnessGoal(profile.fitnessGoal)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.clayMint,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.brandGreen.withValues(alpha: 0.25),
                                    ),
                                  ),
                                  child: Text(
                                    '📊 BMI ${profile.bmi.toStringAsFixed(1)} • ${profile.bmiCategory}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.brandGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Compact Edit Profile Button
                  ClayButton(
                    text: 'Chỉnh sửa thông số',
                    height: 42,
                    borderRadius: 16,
                    variant: ClayButtonVariant.outline,
                    icon: const Icon(Icons.tune_rounded, size: 16, color: AppColors.onSurface),
                    onPressed: profileAsync.hasError ? null : () => context.router.push(const ProfileEditRoute()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppValues.spacing20),

            // 2. BMR & TDEE Indicator Card
            BmrTdeeCard(profile: profile),

            const SizedBox(height: AppValues.spacing20),

            // 3. Biological Metrics Grid Card
            ClayCard(
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
                        'Thông số cá nhân',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                      ),
                      InkWell(
                        onTap: profileAsync.hasError ? null : () => context.router.push(const ProfileEditRoute()),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            'Sửa',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: profileAsync.hasError ? AppColors.onSurfaceVariant : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppValues.spacing12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.3,
                    children: [
                      _buildStatTile(
                        icon: '🚻',
                        label: 'Giới tính',
                        value: profile.gender == 'male' ? 'Nam' : 'Nữ',
                      ),
                      _buildStatTile(
                        icon: '🎂',
                        label: 'Năm sinh',
                        value: '${profile.birthYear} (${profile.age}t)',
                      ),
                      _buildStatTile(
                        icon: '📏',
                        label: 'Chiều cao',
                        value: '${profile.heightCm.round()} cm',
                      ),
                      _buildStatTile(
                        icon: '⚖️',
                        label: 'Cân nặng hiện tại',
                        value: '${profile.weightKg} kg',
                      ),
                      _buildStatTile(
                        icon: '🎯',
                        label: 'Cân nặng mục tiêu',
                        value: profile.targetWeightKg != null
                            ? '${profile.targetWeightKg!.round()} kg'
                            : 'Chưa đặt',
                        valueColor: profile.targetWeightKg != null ? AppColors.brandGreen : null,
                      ),
                      _buildStatTile(
                        icon: '🏃',
                        label: 'Mức độ vận động',
                        value: _translateActivityLevel(profile.activityLevel),
                      ),
                      _buildStatTile(
                        icon: '📊',
                        label: 'Chỉ số BMI',
                        value: '${profile.bmi.toStringAsFixed(1)} (${profile.bmiCategory})',
                        valueColor: AppColors.primary,
                      ),
                      _buildStatTile(
                        icon: '🔥',
                        label: 'Mục tiêu Calo/ngày',
                        value: '${profile.dailyTargetCalories} kcal',
                        valueColor: AppColors.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppValues.spacing20),

            // 4. AstroBite Ecosystem & Integrations Card
            ClayCard(
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
                      return _buildMenuTile(
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
                  _buildMenuTile(
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
                  _buildMenuTile(
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
                  _buildMenuTile(
                    icon: '📱',
                    title: 'Tiện ích Màn hình chính (Widget)',
                    subtitle: 'Xem nhanh Calo/Macro & Quét AI 1-chạm',
                    iconBg: AppColors.clayBreakfast,
                    onTap: () => _showWidgetGuideSheet(context, ref),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Divider(color: Color(0xFFF0EFEB), height: 1),
                  ),

                  // Recipe Catalog
                  _buildMenuTile(
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
                  _buildMenuTile(
                    icon: '📅',
                    title: 'Kế hoạch thực đơn 7 ngày',
                    subtitle: 'Lên lịch bữa ăn & 1-chạm nạp nhật ký',
                    iconBg: AppColors.clayBreakfast,
                    onTap: () => context.router.push(const MealPlannerRoute()),
                  ),
                ],
              ),
            ),

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

  Widget _buildStatTile({
    required String icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E5DF), width: 1),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required String icon,
    required String title,
    required String subtitle,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
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

  void _showWidgetGuideSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.clayLunch,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text('📱', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiện ích Màn hình chính',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Theo dõi Calo & Quét món ăn 1 chạm',
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _guideStep(1, 'Chạm giữ vào vùng trống trên màn hình chính.'),
            _guideStep(2, 'Nhấn dấu "+" (iOS) hoặc chọn "Tiện ích / Widgets" (Android).'),
            _guideStep(3, 'Tìm "AstroBite" và thêm widget yêu thích.'),
            const SizedBox(height: 16),
            ClayButton(
              text: 'Ghim Widget Ngay',
              variant: ClayButtonVariant.primary,
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
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _guideStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

