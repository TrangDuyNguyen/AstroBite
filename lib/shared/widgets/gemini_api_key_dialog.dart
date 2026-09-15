import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Modal dialog allowing users to view, configure, or clear their personal Gemini API Key.
class GeminiApiKeyDialog extends ConsumerStatefulWidget {
  const GeminiApiKeyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => const GeminiApiKeyDialog(),
    );
  }

  @override
  ConsumerState<GeminiApiKeyDialog> createState() => _GeminiApiKeyDialogState();
}

class _GeminiApiKeyDialogState extends ConsumerState<GeminiApiKeyDialog> {
  late final TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    final currentKey = ref.read(geminiApiKeyServiceProvider).customKey;
    _controller = TextEditingController(text: currentKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && mounted) {
      _controller.text = data!.text!.trim();
    }
  }

  Future<void> _saveKey() async {
    final key = _controller.text.trim();
    await ref.read(geminiApiKeyServiceProvider.notifier).setCustomKey(key);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu Gemini API Key thành công!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _clearKey() async {
    await ref.read(geminiApiKeyServiceProvider.notifier).clearCustomKey();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa Gemini API Key cá nhân.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyState = ref.watch(geminiApiKeyServiceProvider);

    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: const Row(
        children: [
          Icon(Icons.vpn_key_rounded, color: AppColors.tertiary),
          SizedBox(width: AppValues.spacing8),
          Text('Cài đặt Gemini API Key'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AstroBite sử dụng Google Gemini AI để nhận diện món ăn. '
              'Bạn có thể dùng API Key miễn phí 100% (không cần thẻ tín dụng).',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: AppValues.spacing12),
            InkWell(
              onTap: () async {
                await Clipboard.setData(
                  const ClipboardData(text: 'https://aistudio.google.com/app/apikey'),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã sao chép link Google AI Studio vào bộ nhớ tạm!'),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(AppValues.radius8),
              child: Container(
                padding: const EdgeInsets.all(AppValues.spacing8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppValues.radius8),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.open_in_new, size: 16, color: AppColors.primary),
                    SizedBox(width: AppValues.spacing8),
                    Expanded(
                      child: Text(
                        'Lấy Key miễn phí: aistudio.google.com\n(Bấm để copy đường link)',
                        style: TextStyle(fontSize: 12, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppValues.spacing16),
            TextField(
              controller: _controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Gemini API Key',
                hintText: 'AIzaSy...',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                    IconButton(
                      icon: const Icon(Icons.paste_rounded, size: 20),
                      tooltip: 'Dán từ bộ nhớ tạm',
                      onPressed: _pasteFromClipboard,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppValues.spacing12),
            Text(
              keyState.isUsingCustomKey
                  ? 'Trạng thái: Đang dùng Key cá nhân (${keyState.maskedActiveKey})'
                  : keyState.hasKey
                      ? 'Trạng thái: Đang dùng Key mặc định từ hệ thống'
                      : 'Trạng thái: Chưa có API Key nào được cài đặt',
              style: TextStyle(
                fontSize: 12,
                color: keyState.hasKey ? AppColors.success : AppColors.error,
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (keyState.isUsingCustomKey)
          TextButton(
            onPressed: _clearKey,
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Xóa Key'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Đóng'),
        ),
        FilledButton(
          onPressed: _saveKey,
          child: const Text('Lưu Key'),
        ),
      ],
    );
  }
}
