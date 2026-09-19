import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Kết nối Sức khỏe'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection Status Card
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('❤️', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repo.platformName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            connectionAsync.when(
                              loading: () => const Text(
                                'Đang kiểm tra...',
                                style: TextStyle(color: AppColors.onSurfaceVariant),
                              ),
                              error: (_, __) => const Text(
                                'Lỗi kết nối',
                                style: TextStyle(color: AppColors.tertiary),
                              ),
                              data: (connected) => Text(
                                connected ? 'Đã kết nối ✅' : 'Chưa kết nối',
                                style: TextStyle(
                                  color: connected
                                      ? const Color(0xFF4CAF50)
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: connectionAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (connected) => connected
                          ? OutlinedButton(
                              onPressed: () => _showDisconnectDialog(context, ref),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.outline),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Ngắt kết nối'),
                            )
                          : FilledButton(
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
                                    ),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Kết nối'),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Write-back toggle
          connectionAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (connected) {
              if (!connected) return const SizedBox.shrink();
              return GlassCard(
                child: Padding(
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
                                    color: AppColors.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tự động ghi calo nạp vào ${repo.platformName} sau mỗi bữa ăn',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Data types info
          GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dữ liệu truy cập',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              color: Color(0xFF4CAF50),
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
        title: const Text('Ngắt kết nối'),
        content: const Text(
          'Bạn có chắc muốn ngắt kết nối? Dữ liệu vận động sẽ không hiển thị trong AstroBite.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              ref.read(healthConnectionControllerProvider.notifier).disconnect();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã ngắt kết nối Health')),
              );
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
