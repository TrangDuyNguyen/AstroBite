import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';

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
          context.l10n.syncPendingTooltip,
        ),
      'failed' => (
          Icons.cloud_off_rounded,
          AppColors.error,
          context.l10n.syncFailedTooltip,
        ),
      _ => (
          Icons.cloud_done_rounded,
          AppColors.success,
          context.l10n.syncSuccessTooltip,
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
