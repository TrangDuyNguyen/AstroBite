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
          content: Text('Đã gia nhập bang hội thành công!'),
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
          // Drag handle
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
          const SizedBox(height: 18),

          // Header with 3D Shield Figurine
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.clayLunch,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Clay3DShield(size: 28),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhập Mã Mời Bang Hội',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Nhập mã 6 ký tự do Bang chủ hoặc đồng đội chia sẻ.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Code textfield
          ClayTextField(
            controller: _codeController,
            labelText: 'Mã Mời (6 ký tự)',
            hintText: 'Ví dụ: MARS01',
          ),
          const SizedBox(height: 24),

          // Full-width Chunky 3D Submit button
          ClayButton(
            width: double.infinity,
            height: 52,
            text: 'Gia Nhập Ngay',
            isLoading: uiState.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
