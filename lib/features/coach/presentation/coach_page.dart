import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrobite/core/theme/app_colors.dart';
import '../domain/chat_message.dart';
import 'coach_controller.dart';

@RoutePage()
class CoachPage extends ConsumerStatefulWidget {
  const CoachPage({super.key});

  @override
  ConsumerState<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends ConsumerState<CoachPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  static const _quickActions = [
    '✨ Bữa tối nên ăn gì?',
    '📊 Phân tích calo hôm nay',
    '🥩 Gợi ý món giàu Protein',
    '🥗 Món ăn nhẹ dưới 200 kcal',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isSending) return;

    _textController.clear();
    setState(() => _isSending = true);

    try {
      await ref.read(coachControllerProvider.notifier).sendMessage(text.trim());
    } catch (e) {
      if (mounted && e.toString().contains('daily_limit_reached')) {
        _showLimitDialog();
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: const Text('Giới hạn tin nhắn'),
        content: const Text(
          'Bạn đã đạt giới hạn 50 tin nhắn hôm nay. Hãy quay lại ngày mai nhé! 🌙',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(coachControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('AstroCoach AI ✨'),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text('Lỗi: $e', style: const TextStyle(color: AppColors.onSurfaceVariant)),
              ),
              data: (messages) => messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length + (_isSending ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && _isSending) {
                          return _buildTypingIndicator();
                        }
                        return _buildBubble(messages[index]);
                      },
                    ),
            ),
          ),

          // Quick Actions
          if (!_isSending) _buildQuickActions(),

          // Input bar
          _buildInputBar(),

          // Disclaimer
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              '⚕️ AI gợi ý tham khảo, không thay thế chuyên gia y tế',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🤖', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Chào buổi sáng!\nHỏi tôi bất cứ điều gì về dinh dưỡng hôm nay.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceContainer,
          border: Border.all(
            color: isUser
                ? AppColors.primary
                : message.isError
                    ? AppColors.tertiary
                    : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 16 : 4),
            topRight: Radius.circular(isUser ? 4 : 16),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isError) ...[
              const Text('⚠️', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
            ],
            Text(
              message.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.outline,
                  ),
            ),
            if (message.isError)
              TextButton(
                onPressed: () {
                  // ponytail: retry by resending the previous user message
                  final messages = ref.read(coachControllerProvider).valueOrNull ?? [];
                  final lastUserMsg = messages.lastWhere(
                    (m) => m.isUser,
                    orElse: () => message,
                  );
                  if (lastUserMsg.isUser) _sendMessage(lastUserMsg.content);
                },
                child: const Text('Thử lại'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.tertiary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: _quickActions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          return ActionChip(
            label: Text(
              _quickActions[index],
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            backgroundColor: AppColors.surfaceContainer,
            side: const BorderSide(color: AppColors.outline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () => _sendMessage(_quickActions[index]),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                enabled: !_isSending,
                decoration: InputDecoration(
                  hintText: 'Hỏi về dinh dưỡng...',
                  hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(color: AppColors.onSurface),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 44,
              height: 44,
              child: IconButton.filled(
                onPressed: _isSending
                    ? null
                    : () => _sendMessage(_textController.text),
                icon: const Icon(Icons.send, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
