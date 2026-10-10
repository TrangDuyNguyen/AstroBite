import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

class HomeWidgetGuideSheet extends ConsumerWidget {
  const HomeWidgetGuideSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const HomeWidgetGuideSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
          const _GuideStep(number: 1, text: 'Chạm giữ vào vùng trống trên màn hình chính.'),
          const _GuideStep(number: 2, text: 'Nhấn dấu "+" (iOS) hoặc chọn "Tiện ích / Widgets" (Android).'),
          const _GuideStep(number: 3, text: 'Tìm "AstroBite" và thêm widget yêu thích.'),
          const SizedBox(height: 16),
          ClayButton(
            text: 'Ghim Widget Ngay',
            variant: ClayButtonVariant.primary,
            onPressed: () async {
              final success = await ref.read(widgetSyncServiceProvider).requestPinWidget();
              if (context.mounted) {
                Navigator.pop(context);
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
    );
  }
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
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
