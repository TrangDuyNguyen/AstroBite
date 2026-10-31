import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_keys.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import '../../domain/usecases/scan_food_usecase.dart';

/// Centralized error dialog and feedback router for camera scanning results.
class CameraErrorDialogHandler {
  const CameraErrorDialogHandler._();

  static void handleResult({
    required BuildContext context,
    required ScanFoodResult result,
    required Uint8List bytes,
    required VoidCallback onClearPreview,
    required Future<void> Function(Uint8List) onRetry,
  }) {
    switch (result) {
      case ScanSuccess(:final result):
        context.router.push(ScanReviewRoute(scanResult: result, imageBytes: bytes));
      case QuotaExceeded():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.quotaExceeded)),
        );
      case NotFoodResult():
        _showNotFoodDialog(context, onClearPreview);
      case ScanError(:final message):
        _handleScanError(context, message, bytes, onRetry);
    }
  }

  static void _showNotFoodDialog(BuildContext context, VoidCallback onClearPreview) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.dishNotRecognized),
        content: Text(ctx.l10n.notFood),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onClearPreview();
            },
            child: Text(ctx.l10n.retakePhoto),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.router.push(ManualEntryRoute());
            },
            child: Text(ctx.l10n.manualEntry),
          ),
        ],
      ),
    );
  }

  static bool _isNetworkError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('no address associated') ||
        lower.contains('network is unreachable') ||
        lower.contains('clientexception') ||
        lower.contains('connection refused') ||
        lower.contains('connection reset') ||
        lower.contains('connection timed out') ||
        lower.contains('timeoutexception') ||
        lower.contains('handshakeexception') ||
        lower.contains('networkerror');
  }

  static void _handleScanError(
    BuildContext context,
    String message,
    Uint8List bytes,
    Future<void> Function(Uint8List) onRetry,
  ) {
    final isMissingKey = message.contains('Chưa cấu hình Gemini API Key') ||
        message.contains('API Key');
    final isInvalidKey = message.contains('API_KEY_INVALID') ||
        message.contains('API key not valid') ||
        message.contains('firebasevertexai') ||
        message.contains('Firebase AI Logic API') ||
        message.contains('disabled');
    final isNetwork = _isNetworkError(message);

    if (isMissingKey || isInvalidKey) {
      _showApiKeyDialog(context, isInvalidKey);
    } else if (isNetwork) {
      _showOfflineDialog(context, bytes, onRetry);
    } else if (message.contains('503') ||
        message.contains('UNAVAILABLE') ||
        message.contains('high demand') ||
        message.contains('capacity')) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          content: Text(context.l10n.aiServerBusy),
          action: SnackBarAction(
            label: context.l10n.retry,
            textColor: AppColors.primary,
            onPressed: () => onRetry(bytes),
          ),
        ),
      );
    } else {
      final friendlyMessage = formatErrorMessage(context, message);
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(friendlyMessage),
          action: SnackBarAction(
            label: context.l10n.retry,
            textColor: AppColors.primary,
            onPressed: () => onRetry(bytes),
          ),
        ),
      );
    }
  }

  static void _showOfflineDialog(
    BuildContext context,
    Uint8List bytes,
    Future<void> Function(Uint8List) onRetry,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.outline, width: 1.2),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0E8FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wifi_off_rounded, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: AppValues.spacing12),
            const Expanded(
              child: Text(
                'Mất kết nối mạng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.onSurface),
              ),
            ),
          ],
        ),
        content: const Text(
          'AI Vision cần kết nối Internet để phân tích hình ảnh và tính toán calo món ăn. '
          'Bạn vui lòng bật Wi-Fi hoặc 4G để thử lại, hoặc bạn có thể nhập món ăn thủ công vào nhật ký.',
          style: TextStyle(color: AppColors.onSurfaceVariant, height: 1.4, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.router.push(ManualEntryRoute());
            },
            child: Text(ctx.l10n.manualEntry, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onRetry(bytes);
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(ctx.l10n.retry),
          ),
        ],
      ),
    );
  }

  static void _showApiKeyDialog(BuildContext context, bool isInvalidKey) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.vpn_key_rounded, color: AppColors.tertiary),
            const SizedBox(width: AppValues.spacing8),
            Text(isInvalidKey ? ctx.l10n.apiKeyInvalidTitle : ctx.l10n.apiKeyRequiredTitle),
          ],
        ),
        content: Text(
          isInvalidKey ? ctx.l10n.apiKeyInvalidDesc : ctx.l10n.apiKeyRequiredDesc,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.router.push(ManualEntryRoute());
            },
            child: Text(ctx.l10n.manualEntry),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(ctx.l10n.close),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              GeminiApiKeyDialog.show(context);
            },
            icon: const Icon(Icons.vpn_key, size: 18),
            label: Text(ctx.l10n.setupApiKey),
          ),
        ],
      ),
    );
  }

  static String formatErrorMessage(BuildContext context, String rawMessage) {
    if (_isNetworkError(rawMessage)) {
      return 'Không có kết nối Internet. Vui lòng kiểm tra Wi-Fi/4G và thử lại.';
    }
    final lower = rawMessage.toLowerCase();
    if (lower.contains('503') || lower.contains('unavailable') || lower.contains('high demand') || lower.contains('capacity')) {
      return context.l10n.aiOverloaded;
    }
    if (lower.contains('429') || lower.contains('resource_exhausted') || lower.contains('rate limit')) {
      return context.l10n.aiRateLimited;
    }
    if (lower.contains('generativeaiexception') || lower.contains('{') || lower.contains('http') || lower.contains('client') || lower.contains('api')) {
      return context.l10n.aiConnectionError;
    }
    return rawMessage;
  }
}
