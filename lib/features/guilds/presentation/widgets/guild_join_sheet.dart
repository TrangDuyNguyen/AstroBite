import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/guild_controller.dart';

class GuildJoinSheet extends ConsumerStatefulWidget {
  const GuildJoinSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GuildJoinSheet(),
    );
  }

  @override
  ConsumerState<GuildJoinSheet> createState() => _GuildJoinSheetState();
}

class _GuildJoinSheetState extends ConsumerState<GuildJoinSheet> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã mời phải gồm đúng 6 ký tự'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final success = await ref
        .read(guildControllerProvider.notifier)
        .joinGuild(code);

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gia nhập bang hội thành công! 🎉'),
          backgroundColor: AppColors.brandGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(guildControllerProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nhập Mã Mời Bang Hội 🔑',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Nhập mã 6 ký tự do Trưởng bang hoặc đồng đội của bạn chia sẻ.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),

          // Code textfield
          ClayTextField(
            controller: _codeController,
            labelText: 'Mã Mời (6 ký tự)',
            hintText: 'Ví dụ: MARS01',
          ),
          const SizedBox(height: 24),

          // Submit button
          ClayButton(
            text: 'Gia Nhập Ngay',
            isLoading: uiState.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
