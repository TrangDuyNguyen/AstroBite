import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/login_controller.dart';

/// Shows the reset password dialog for forgotten credentials.
Future<void> showLoginResetPasswordDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String initialEmail,
}) async {
  final resetEmailController = TextEditingController(text: initialEmail);
  final resetFormKey = GlobalKey<FormState>();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
          side: const BorderSide(color: AppColors.outline),
        ),
        title: Text(
          dialogContext.l10n.resetPassword,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: resetFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nhập địa chỉ email của bạn để nhận liên kết đặt lại mật khẩu.',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppValues.spacing16),
              ClayTextField(
                controller: resetEmailController,
                labelText: dialogContext.l10n.email,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.onSurfaceVariant,
                ),
                validator: (v) => v != null && v.contains('@') ? null : 'Email không hợp lệ',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              dialogContext.l10n.cancel,
              style: const TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () async {
              if (!resetFormKey.currentState!.validate()) return;
              final email = resetEmailController.text.trim();
              Navigator.of(dialogContext).pop();
              final success = await ref.read(loginControllerProvider.notifier).sendPasswordResetEmail(email: email);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.resetPasswordSent),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: Text(dialogContext.l10n.sendResetLink),
          ),
        ],
      );
    },
  );
  resetEmailController.dispose();
}
