import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../../coach_controller.dart';

/// Helper dialog and actions for confirming Coach history deletion.
class CoachHistoryDeleteDialog {
  const CoachHistoryDeleteDialog._();

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, [
    String? date,
  ]) async {
    final messages = ref.read(coachControllerProvider).valueOrNull ?? [];
    if (date == null && messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuộc trò chuyện hiện tại đang trống.'),
          backgroundColor: AppColors.surfaceContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xoá cuộc trò chuyện?',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          date != null
              ? 'Tất cả tin nhắn trong phiên ngày $date sẽ bị xoá vĩnh viễn và không thể khôi phục.'
              : 'Tất cả tin nhắn trong phiên này sẽ bị xoá vĩnh viễn và không thể khôi phục.',
          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xoá', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(coachControllerProvider.notifier).deleteSession(date);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Đã xoá cuộc trò chuyện thành công.'),
            backgroundColor: AppColors.surfaceContainer,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
