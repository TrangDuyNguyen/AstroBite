import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'health_controller.dart';

@RoutePage()
class HealthConnectionPage extends ConsumerWidget {
  const HealthConnectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(healthConnectionControllerProvider);
    final writeAsync = ref.watch(healthWriteControllerProvider);
    final repo = ref.read(healthRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const ClayAppBar(
        title: 'Kết nối Sức khỏe',
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection Status Card
          ClayCard(
            borderRadius: 20,
            elevation: 4,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.claySnack,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text('❤️', style: TextStyle(fontSize: 26)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repo.platformName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(height: 4),
                          connectionAsync.when(
                            loading: () => const Text(
                              'Đang kiểm tra...',
                              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                            ),
                            error: (_, __) => const Text(
                              'Lỗi kết nối',
                              style: TextStyle(color: AppColors.tertiary, fontSize: 13),
                            ),
                            data: (connected) => Text(
                              connected ? 'Đã kết nối ✅' : 'Chưa kết nối',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: connected
                                    ? AppColors.brandGreen
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                connectionAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (connected) => connected
                      ? ClayButton(
                          text: 'Ngắt kết nối',
                          height: 48,
                          borderRadius: 16,
                          variant: ClayButtonVariant.outline,
                          onPressed: () => _showDisconnectDialog(context, ref),
                        )
                      : ClayButton(
                          text: 'Kết nối ngay',
                          height: 48,
                          borderRadius: 16,
                          variant: ClayButtonVariant.primary,
                          onPressed: () async {
                            final success = await ref
                                .read(healthConnectionControllerProvider.notifier)
                                .connect();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Đã kết nối ${repo.platformName} thành công'
                                        : 'Cần cấp quyền truy cập Health',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Write-back toggle
          connectionAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (connected) {
              if (!connected) return const SizedBox.shrink();
              return ClayCard(
                borderRadius: 20,
                elevation: 4,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đồng bộ calo sang Health',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tự động ghi calo nạp vào ${repo.platformName} sau mỗi bữa ăn',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    writeAsync.when(
                      loading: () => const SizedBox(width: 44, height: 44),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (enabled) => Switch(
                        value: enabled,
                        onChanged: (_) => ref
                            .read(healthWriteControllerProvider.notifier)
                            .toggle(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Data types info
          ClayCard(
            borderRadius: 20,
            elevation: 4,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dữ liệu truy cập',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                ),
                const SizedBox(height: 12),
                _buildDataTypeRow('📊', 'Số bước đi (Steps)', 'Read'),
                _buildDataTypeRow('🔥', 'Calo tiêu hao (Active Energy)', 'Read'),
                _buildDataTypeRow('🏃', 'Bài tập (Workouts)', 'Read'),
                _buildDataTypeRow('🍽', 'Calo nạp vào (Dietary Energy)', 'Write'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTypeRow(String icon, String label, String access) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            '✅ $access',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.brandGreen,
            ),
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Ngắt kết nối', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Bạn có chắc muốn ngắt kết nối? Dữ liệu vận động sẽ không hiển thị trong AstroBite.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              ref.read(healthConnectionControllerProvider.notifier).disconnect();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã ngắt kết nối Health'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Xác nhận', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
