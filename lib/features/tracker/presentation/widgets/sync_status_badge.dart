import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

class SyncStatusBadge extends StatelessWidget {
  const SyncStatusBadge({
    super.key,
    required this.syncStatus,
    this.onTap,
  });

  final String syncStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (syncStatus == 'synced') {
      return const SizedBox.shrink();
    }

    final (icon, color, tooltip) = switch (syncStatus) {
      'pending_sync' => (
          Icons.cloud_upload_outlined,
          AppColors.warning,
          'Bữa ăn này đang lưu trên thiết bị. Sẽ tự tải lên khi có mạng.',
        ),
      'failed' => (
          Icons.cloud_off_rounded,
          AppColors.error,
          'Chưa thể tải lên máy chủ. Chạm vào đây để thử lại.',
        ),
      _ => (
          Icons.cloud_done_rounded,
          AppColors.success,
          'Đã đồng bộ lên đám mây',
        ),
    };

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
