import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';

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
      SnackBar(
        content: Text(context.l10n.apiKeySavedSuccess),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _clearKey() async {
    await ref.read(geminiApiKeyServiceProvider.notifier).clearCustomKey();
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.apiKeyRemovedSuccess),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyState = ref.watch(geminiApiKeyServiceProvider);

    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          const Icon(Icons.vpn_key_rounded, color: AppColors.tertiary),
          const SizedBox(width: AppValues.spacing8),
          Text(context.l10n.apiKeySettings),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.apiKeyDialogDescription,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: AppValues.spacing12),
            InkWell(
              onTap: () async {
                await Clipboard.setData(
                  const ClipboardData(text: 'https://aistudio.google.com/app/apikey'),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.apiKeyCopiedLink),
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
                child: Row(
                  children: [
                    const Icon(Icons.open_in_new, size: 16, color: AppColors.primary),
                    const SizedBox(width: AppValues.spacing8),
                    Expanded(
                      child: Text(
                        context.l10n.apiKeyGetFree,
                        style: const TextStyle(fontSize: 12, color: AppColors.primary),
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
                      tooltip: context.l10n.pasteFromClipboard,
                      onPressed: _pasteFromClipboard,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppValues.spacing12),
            Text(
              keyState.isUsingEnvKey
                  ? context.l10n.apiKeyStatusDefault
                  : keyState.isUsingCustomKey
                      ? context.l10n.apiKeyStatusCustom(keyState.maskedActiveKey)
                      : context.l10n.apiKeyStatusNone,
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
            child: Text(context.l10n.deleteKey),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.close),
        ),
        FilledButton(
          onPressed: _saveKey,
          child: Text(context.l10n.saveKey),
        ),
      ],
    );
  }
}
