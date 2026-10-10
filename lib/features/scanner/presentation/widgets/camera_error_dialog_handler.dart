import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
        title: const Text('Không nhận diện được món ăn'),
        content: Text(ctx.l10n.notFood),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onClearPreview();
            },
            child: const Text('Chụp lại'),
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

  static void _handleScanError(
    BuildContext context,
    String message,
    Uint8List bytes,
    Future<void> Function(Uint8List) onRetry,
  ) {
    final isMissingKey = message.contains('Chưa cấu hình Gemini API Key');
    final isInvalidKey = message.contains('API_KEY_INVALID') ||
        message.contains('API key not valid') ||
        message.contains('firebasevertexai') ||
        message.contains('Firebase AI Logic API') ||
        message.contains('disabled');

    if (isMissingKey || isInvalidKey) {
      _showApiKeyDialog(context, isInvalidKey);
    } else if (message.contains('503') ||
        message.contains('UNAVAILABLE') ||
        message.contains('high demand') ||
        message.contains('capacity')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: const Text(
            'Máy chủ AI hiện đang quá tải (503). Vui lòng bấm "Thử lại" sau giây lát.',
          ),
          action: SnackBarAction(
            label: 'Thử lại',
            textColor: AppColors.primary,
            onPressed: () => onRetry(bytes),
          ),
        ),
      );
    } else {
      final friendlyMessage = formatErrorMessage(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlyMessage),
          action: SnackBarAction(
            label: 'Thử lại',
            textColor: AppColors.primary,
            onPressed: () => onRetry(bytes),
          ),
        ),
      );
    }
  }

  static void _showApiKeyDialog(BuildContext context, bool isInvalidKey) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.vpn_key_rounded, color: AppColors.tertiary),
            const SizedBox(width: AppValues.spacing8),
            Text(isInvalidKey ? 'Gemini API Key Không Hợp Lệ' : 'Cần Gemini API Key'),
          ],
        ),
        content: Text(
          isInvalidKey
              ? 'Key API bạn đang sử dụng không hợp lệ hoặc đã hết hạn.\n\nVui lòng kiểm tra lại Key trong file .env hoặc tạo Key mới (phải bắt đầu bằng AIzaSy...) từ Google AI Studio.'
              : 'Để quét món ăn bằng AI miễn phí (không cần thẻ tín dụng), bạn cần cài đặt Gemini API Key từ Google AI Studio (aistudio.google.com).\n\nBạn có thể dán Key ngay bây giờ hoặc sử dụng tính năng Nhập tay.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.router.push(ManualEntryRoute());
            },
            child: const Text('Nhập tay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              GeminiApiKeyDialog.show(context);
            },
            icon: const Icon(Icons.vpn_key, size: 18),
            label: const Text('Cài đặt Key'),
          ),
        ],
      ),
    );
  }

  static String formatErrorMessage(String rawMessage) {
    if (rawMessage.contains('GenerativeAIException') || rawMessage.contains('{')) {
      if (rawMessage.contains('503') || rawMessage.contains('UNAVAILABLE')) {
        return 'Máy chủ AI tạm thời quá tải. Vui lòng thử lại sau giây lát.';
      }
      if (rawMessage.contains('429') || rawMessage.contains('RESOURCE_EXHAUSTED')) {
        return 'Đã vượt giới hạn gọi AI tạm thời. Vui lòng thử lại sau ít phút.';
      }
      return 'Không thể kết nối đến máy chủ AI. Vui lòng thử lại.';
    }
    return rawMessage;
  }
}
