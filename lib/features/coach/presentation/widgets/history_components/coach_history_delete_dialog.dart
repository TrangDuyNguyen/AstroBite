import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../../coach_controller.dart';

/// Helper dialog and actions for confirming Coach history deletion.
class CoachHistoryDeleteDialog {
  const CoachHistoryDeleteDialog._();

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, [
    String? date,
  ]) async {
    final l10n = context.l10n;
    final messages = ref.read(coachControllerProvider).valueOrNull ?? [];
    if (date == null && messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.deleteChatEmpty),
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
        title: Text(
          l10n.deleteChatTitle,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          date != null
              ? l10n.deleteChatConfirmDate(date)
              : l10n.deleteChatConfirmGeneral,
          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.deleteCancel, style: const TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteAction, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(coachControllerProvider.notifier).deleteSession(date);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.deleteChatSuccess),
            backgroundColor: AppColors.surfaceContainer,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
