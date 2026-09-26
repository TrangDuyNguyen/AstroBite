import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:astrobite/core/genui/a2ui_model.dart';
import 'package:astrobite/core/genui/a2ui_parser.dart';
import 'package:astrobite/core/genui/catalog.dart';
import 'package:astrobite/core/genui/catalog_item.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/coach/domain/astrobite_genui_catalog.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/controllers/tracker_controller.dart';
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
  final Set<String> _loggedMessageIds = {};
  late final GenUiCatalog _genUiCatalog;

  @override
  void initState() {
    super.initState();
    _genUiCatalog = createAstroBiteCatalog(
      onSendUserMessage: (msg) => _sendMessage(msg),
    );
  }

  List<String> get _dynamicQuickActions {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return const [
        '🥣 Bữa sáng giàu năng lượng',
        '☕ Cà phê & Calo',
        '🥩 Bữa sáng giàu đạm',
        '⚡ Mục tiêu calo hôm nay',
      ];
    } else if (hour >= 11 && hour < 14) {
      return const [
        '🍱 Gợi ý bữa trưa cân bằng',
        '🥩 Bữa trưa giàu đạm',
        '🥗 Món ăn ít dầu mỡ',
        '⚡ Phân tích calo sáng',
      ];
    } else if (hour >= 14 && hour < 17) {
      return const [
        '🍎 Ăn xế dưới 150 kcal',
        '💧 Nhắc nhở uống nước',
        '⚡ Năng lượng trước tập gym',
        '🍵 Trà xanh ít calo',
      ];
    } else {
      return const [
        '🥗 Gợi ý bữa tối giàu protein',
        '⚡ Phân tích natri hôm nay',
        '🥩 Phục hồi cơ sau tập gym',
        '💧 Lượng nước cần bù',
      ];
    }
  }

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
        title: const Text('Giới hạn tin nhắn', style: TextStyle(color: AppColors.onSurface)),
        content: const Text(
          'Bạn đã đạt giới hạn 50 tin nhắn hôm nay. Hãy quay lại ngày mai nhé! 🌙',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đã hiểu', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteSession([String? date]) async {
    final messages = ref.read(coachControllerProvider).valueOrNull ?? [];
    if (date == null && messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuộc trò chuyện hiện tại đang trống.'),
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
        title: const Text(
          'Xoá cuộc trò chuyện?',
          style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Text(
          date != null
              ? 'Tất cả tin nhắn trong phiên ngày $date sẽ bị xoá vĩnh viễn và không thể khôi phục.'
              : 'Tất cả tin nhắn trong phiên này sẽ bị xoá vĩnh viễn và không thể khôi phục.',
          style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Huỷ', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xoá', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(coachControllerProvider.notifier).deleteSession(date);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Đã xoá cuộc trò chuyện thành công.'),
            backgroundColor: AppColors.surfaceContainer,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  static Map<String, dynamic>? _extractMealData(String content) {
    // 1. Try markdown code block ```astrobite-meal ... ```
    final blockMatch = RegExp(r'```(?:astrobite-meal|json)?\s*(\{.*?"dishName".*?\})\s*```', dotAll: true).firstMatch(content)
        ?? RegExp(r'```astrobite-meal\s*(\{.*?\})\s*```', dotAll: true).firstMatch(content);
    if (blockMatch != null) {
      try {
        final jsonStr = blockMatch.group(1)?.trim();
        if (jsonStr != null) {
          return jsonDecode(jsonStr) as Map<String, dynamic>;
        }
      } catch (_) {}
    }

    // 2. Try HTML comment <!--astrobite-meal:...-->
    final commentMatch = RegExp(r'<!--astrobite-meal:(.*?)-->', dotAll: true).firstMatch(content);
    if (commentMatch != null) {
      try {
        return jsonDecode(commentMatch.group(1)!) as Map<String, dynamic>;
      } catch (_) {}
    }

    return null;
  }

  static String _cleanDisplayContent(String content) {
    return content
        .replaceAll(RegExp(r'```(?:astrobite-meal|json)?\s*\{.*?"dishName".*?\}\s*```', dotAll: true), '')
        .replaceAll(RegExp(r'```astrobite-meal\s*\{.*?\}\s*```', dotAll: true), '')
        .replaceAll(RegExp(r'<!--astrobite-meal:.*?-->', dotAll: true), '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(coachControllerProvider);
    final summary = ref.watch(todaySummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface, size: 20),
          onPressed: () => context.router.maybePop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.surfaceContainer,
                backgroundImage: AssetImage('assets/images/astrobot_mascot.png'),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'AstroCoach AI ✨',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E676),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Online • Real-time Nutritionist',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.onSurfaceVariant, size: 22),
            tooltip: 'Xoá cuộc trò chuyện',
            onPressed: () => _confirmDeleteSession(),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.onSurface, size: 22),
            tooltip: 'Lịch sử hội thoại',
            onPressed: _showHistorySheet,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          // Background Mascot Artwork
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/images/astrobot_mascot.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Column(
            children: [
              // Context Header Strip
              _buildContextHeader(summary),

          // Reviewing past session notice banner
          if (ref.watch(coachControllerProvider.notifier).selectedDate != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_note_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đang xem lại phiên: ${ref.watch(coachControllerProvider.notifier).selectedDate}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.read(coachControllerProvider.notifier).selectSessionDate(null),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      'Hôm nay ↺',
                      style: TextStyle(
                        color: AppColors.protein,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
                  ? _buildEmptyState(summary)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          // Dynamic Quick Actions
          if (!_isSending) _buildQuickActions(),

          // Medical Disclaimer (Placed cleanly above Input Bar)
          const Padding(
            padding: EdgeInsets.only(top: 4, bottom: 2),
            child: Text(
              '⚕️ AI gợi ý tham khảo, không thay thế chuyên gia y tế',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Input bar + Floating Dock Clearance
          Padding(
            padding: EdgeInsets.only(
              bottom: (MediaQuery.viewInsetsOf(context).bottom > 0) ? 8 : 106,
            ),
            child: _buildInputBar(),
          ),
        ],
      ),
        ],
      ),
    );
  }

  /// Context Header Strip displaying real-time calories, 3 macros, and sodium warning
  Widget _buildContextHeader(DailySummary summary) {
    final remainingCalories = summary.targetCalories - summary.totalCalories;
    final isSodiumWarning = summary.totalSodiumMg >= 1500;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng quan dinh dưỡng hôm nay',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                'Còn lại: ${remainingCalories.clamp(0, 9999)} kcal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: remainingCalories >= 0 ? AppColors.onSurface : AppColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 3 Compact Macro Progress Bars
          Row(
            children: [
              Expanded(
                child: _buildMacroMiniBar(
                  label: 'Carbs',
                  current: summary.totalCarbsG,
                  target: summary.targetCarbsG,
                  color: AppColors.carbs,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroMiniBar(
                  label: 'Protein',
                  current: summary.totalProteinG,
                  target: summary.targetProteinG,
                  color: AppColors.protein,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroMiniBar(
                  label: 'Fat',
                  current: summary.totalFatG,
                  target: summary.targetFatG,
                  color: AppColors.fat,
                ),
              ),
            ],
          ),
          if (isSodiumWarning) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x22FFB300),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Cảnh báo Natri: ${summary.totalSodiumMg.toInt()}mg / ${summary.targetSodiumMg.toInt()}mg (sắp chạm ngưỡng khuyến nghị)',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMacroMiniBar({
    required String label,
    required int current,
    required int target,
    required Color color,
  }) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
            ),
            Text(
              '$current/${target}g',
              style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(DailySummary summary) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/astrobot_mascot.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Xin chào! Tôi là AstroBot ✨',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hôm nay bạn đã nạp ${summary.totalCalories} kcal (${summary.totalProteinG}g Protein).\nHãy chọn câu hỏi nhanh bên dưới hoặc nhập thực đơn bạn muốn tư vấn!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(ChatMessage message) {
    final isUser = message.isUser;
    final a2uiPayload = isUser
        ? A2uiMessagePayload(text: message.content)
        : A2uiParser.parse(message.content);
    final displayContent = isUser
        ? message.content
        : (a2uiPayload.text.isNotEmpty
            ? a2uiPayload.text
            : _cleanDisplayContent(message.content));
    final mealData = _extractMealData(message.content);
    final isLogged = message.isLogged || _loggedMessageIds.contains(message.id);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.surfaceContainer,
          border: Border.all(
            color: isUser
                ? AppColors.primary.withValues(alpha: 0.45)
                : message.isError
                    ? AppColors.tertiary
                    : Colors.white.withValues(alpha: 0.08),
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
            if (displayContent.isNotEmpty)
              isUser || message.isError
                  ? Text(
                      displayContent,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurface,
                            height: 1.35,
                          ),
                    )
                  : MarkdownBody(
                      data: displayContent,
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurface,
                              height: 1.45,
                            ),
                        h3: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                        strong: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        listBullet: const TextStyle(color: AppColors.onSurface),
                        horizontalRuleDecoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                      ),
                    ),
            // GenUI Dynamic A2UI Components
            if (!isUser && a2uiPayload.hasComponents && mealData == null) ...[
              for (final comp in a2uiPayload.components) ...[
                const SizedBox(height: 10),
                _genUiCatalog.buildWidget(
                  context,
                  comp,
                  CatalogItemContext(
                    isLogged: isLogged,
                    onAction: (action, payload) {
                      if (action == 'log_meal' && payload is Map<String, dynamic>) {
                        _logMealFromCoach(message.id, payload);
                      }
                    },
                    onSendUserMessage: (prompt) => _sendMessage(prompt),
                  ),
                ),
              ],
            ] else if (mealData != null) ...[
              const SizedBox(height: 10),
              _buildHolographicMealCard(message, mealData, isLogged),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.outline,
                      ),
                ),
                if (!isUser) ...[
                  const SizedBox(width: 6),
                  const Text(
                    '• AstroCoach',
                    style: TextStyle(fontSize: 10, color: AppColors.outline),
                  ),
                ],
              ],
            ),
            if (message.isError)
              TextButton(
                onPressed: () {
                  final messages = ref.read(coachControllerProvider).valueOrNull ?? [];
                  final lastUserMsg = messages.lastWhere(
                    (m) => m.isUser,
                    orElse: () => message,
                  );
                  if (lastUserMsg.isUser) {
                    ref.read(coachControllerProvider.notifier).removeErrors();
                    _sendMessage(lastUserMsg.content);
                  }
                },
                child: const Text('Thử lại', style: TextStyle(color: AppColors.primary)),
              ),
          ],
        ),
      ),
    );
  }

  /// Holographic Bento Meal Card with 1-Tap Log CTA
  Widget _buildHolographicMealCard(
    ChatMessage message,
    Map<String, dynamic> mealData,
    bool isLogged,
  ) {
    final dishName = mealData['dishName']?.toString() ?? 'Gợi ý món ăn';
    final calories = mealData['calories'] ?? 0;
    final protein = mealData['protein'] ?? 0;
    final carbs = mealData['carbs'] ?? 0;
    final fat = mealData['fat'] ?? 0;
    final sodium = mealData['sodium'];
    final ingredients = mealData['ingredients'] as List<dynamic>?;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🍲', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dishName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$calories kcal • ${protein}g P • ${carbs}g C • ${fat}g F',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.protein.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '$calories kcal',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.protein,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Macro badges row
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _buildMacroBadge('Đạm', '${protein}g', AppColors.protein),
              _buildMacroBadge('Carbs', '${carbs}g', AppColors.carbs),
              _buildMacroBadge('Béo', '${fat}g', AppColors.fat),
              if (sodium != null)
                _buildMacroBadge('Natri', '${sodium}mg', AppColors.warning),
            ],
          ),
          if (ingredients != null && ingredients.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Thành phần: ${ingredients.join(', ')}',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 10),
          // 1-Tap Log CTA Action Button
          SizedBox(
            width: double.infinity,
            height: 38,
            child: isLogged
                ? OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00E676),
                      side: const BorderSide(color: Color(0xFF00E676)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: null,
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text(
                      '✓ Đã ghi vào nhật ký',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                : FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => _logMealFromCoach(message.id, mealData),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          '⚡ 1-Tap Log • ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '1-Chạm',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Future<void> _logMealFromCoach(String messageId, Map<String, dynamic> mealData) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final log = FoodLogDto(
      id: '${now.microsecondsSinceEpoch}',
      date: DateFormat('yyyy-MM-dd').format(now),
      mealType: mealData['mealType']?.toString() ?? 'lunch',
      dishName: mealData['dishName']?.toString() ?? 'Món từ AstroCoach',
      estimatedWeightG: (mealData['weightG'] as num?)?.toInt() ?? 150,
      calories: (mealData['calories'] as num?)?.toInt() ?? 300,
      proteinG: (mealData['protein'] as num?)?.toInt() ?? 25,
      carbsG: (mealData['carbs'] as num?)?.toInt() ?? 30,
      fatG: (mealData['fat'] as num?)?.toInt() ?? 8,
      source: 'ai_coach',
    );

    setState(() {
      _loggedMessageIds.add(messageId);
    });

    ref.read(coachControllerProvider.notifier).markMessageLogged(messageId);

    await ref.read(trackerControllerProvider.notifier).addFoodLog(
          userId: user.uid,
          log: log,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✨ Đã thêm "${log.dishName}" (${log.calories} kcal) vào nhật ký!'),
          backgroundColor: AppColors.surfaceContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'AstroCoach đang suy nghĩ...',
              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(width: 8),
            _buildDot(AppColors.carbs),
            const SizedBox(width: 4),
            _buildDot(AppColors.protein),
            const SizedBox(width: 4),
            _buildDot(AppColors.fat),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = _dynamicQuickActions;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          return ActionChip(
            label: Text(
              actions[index],
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            backgroundColor: AppColors.surfaceContainer,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            onPressed: () => _sendMessage(actions[index]),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                enabled: !_isSending,
                decoration: InputDecoration(
                  hintText: 'Hỏi AstroCoach về thực đơn, macros...',
                  hintStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  prefixIcon: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(color: AppColors.onSurface, fontSize: 13),
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
                icon: const Icon(Icons.send_rounded, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final sessionsAsync = ref.watch(chatSessionsListProvider);
            final currentSelected =
                ref.read(coachControllerProvider.notifier).selectedDate;

            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.35,
              maxChildSize: 0.85,
              expand: false,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outline.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.history_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Lịch sử hội thoại AstroCoach',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white10),
                      Expanded(
                        child: sessionsAsync.when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                          error: (e, _) => Center(
                            child: Text('Lỗi tải lịch sử: $e', style: const TextStyle(color: AppColors.onSurfaceVariant)),
                          ),
                          data: (sessions) {
                            if (sessions.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Chưa có cuộc trò chuyện nào trước đó.',
                                  style: TextStyle(color: AppColors.onSurfaceVariant),
                                ),
                              );
                            }
                            return ListView.separated(
                              controller: scrollController,
                              itemCount: sessions.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final s = sessions[index];
                                final dateStr = s['date'] as String? ?? '';
                                final count = s['message_count'] as int? ?? 0;
                                final lastMsg = s['last_message'] as String? ?? '';
                                final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                final isSelected = (currentSelected == null && dateStr == todayStr) ||
                                    (currentSelected == dateStr);

                                return InkWell(
                                  onTap: () {
                                    ref.read(coachControllerProvider.notifier).selectSessionDate(
                                          dateStr == todayStr ? null : dateStr,
                                        );
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(alpha: 0.15)
                                          : AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.white.withValues(alpha: 0.08),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                dateStr == todayStr ? 'Hôm nay ($dateStr)' : dateStr,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.surfaceContainer,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '$count tin nhắn',
                                                style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            InkWell(
                                              onTap: () => _confirmDeleteSession(dateStr),
                                              borderRadius: BorderRadius.circular(6),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.onSurfaceVariant),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (lastMsg.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            lastMsg,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
