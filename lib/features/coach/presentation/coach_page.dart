import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import '../domain/chat_message.dart';
import 'coach_controller.dart';

@RoutePage()
class CoachPage extends ConsumerStatefulWidget {
  const CoachPage({super.key});

  @override
  ConsumerState<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends ConsumerState<CoachPage> with WidgetsBindingObserver {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  Timer? _scrollTimer;
  bool _isSending = false;
  bool _showSuggestions = true;
  bool _wasKeyboardOpen = false;
  final Set<String> _loggedMessageIds = {};
  late final GenUiCatalog _genUiCatalog;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
    _genUiCatalog = createAstroBiteCatalog(
      onSendUserMessage: (msg) => _sendMessage(msg),
    );
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    }
  }

  int _suggestionShuffleIndex = 0;

  List<String> _getDynamicQuickActions(DailySummary summary) {
    final hour = DateTime.now().hour;
    final contextSuggestions = <String>[];

    // 1. Dynamic Context-Aware Insights based on user's real-time nutrition
    final remainingCal = summary.targetCalories - summary.totalCalories;
    if (remainingCal > 800) {
      contextSuggestions.add('🔥 Còn $remainingCal kcal, ăn gì no lâu?');
    } else if (remainingCal > 0 && remainingCal <= 400) {
      contextSuggestions.add('🥗 Còn $remainingCal kcal, món nhẹ dưới 300 kcal?');
    } else if (remainingCal <= 0 && summary.totalCalories > 0) {
      contextSuggestions.add('⚠️ Vượt ${summary.totalCalories - summary.targetCalories} kcal, mẹo cân bằng?');
    }

    final remainingProtein = summary.targetProteinG - summary.totalProteinG;
    if (remainingProtein > 20) {
      contextSuggestions.add('🥩 Thiếu ${remainingProtein}g đạm, ăn gì bù nhanh?');
    } else if (remainingProtein <= 0 && summary.totalProteinG > 0) {
      contextSuggestions.add('💪 Đã đủ đạm, ăn gì tiếp không thừa calo?');
    }

    if (summary.totalSodiumMg >= 1500) {
      contextSuggestions.add('🧂 Lượng natri cao, cách giảm tích nước?');
    }

    if (summary.totalFiberG < 10 && summary.logs.isNotEmpty) {
      contextSuggestions.add('🥦 Gợi ý món nhiều chất xơ dễ tiêu hóa');
    }

    // 2. Time-of-Day Rich Pools
    final List<String> timePool;
    if (hour >= 5 && hour < 11) {
      timePool = const [
        '🍳 Bữa sáng giàu đạm dưới 400 kcal',
        '☕ Cà phê sáng & calo cần lưu ý',
        '🥣 Bữa sáng nhanh 5 phút eat clean',
        '⚡ Nạp năng lượng khởi động ngày mới',
        '🥑 Thực phẩm giảm mỡ bụng buổi sáng',
        '🥪 Gợi ý bánh mì ngũ cốc & trứng',
      ];
    } else if (hour >= 11 && hour < 14) {
      timePool = const [
        '🍱 Gợi ý bữa trưa eat clean văn phòng',
        '🥩 Bữa trưa giàu đạm ít tinh bột',
        '🥗 Món trưa no lâu không gây buồn ngủ',
        '🍜 Bún bò/phở chứa bao nhiêu calo?',
        '🍚 Nên ăn cơm trắng hay gạo lứt?',
        '🍗 Cách chế biến ức gà mềm ngon',
      ];
    } else if (hour >= 14 && hour < 17) {
      timePool = const [
        '🍎 Ăn xế chống đói dưới 150 kcal',
        '💧 Nhắc nhở uống nước & điện giải',
        '⚡ Ăn gì trước giờ tập gym 30 phút?',
        '🍵 Trà xanh ít calo giúp tỉnh táo',
        '🥜 Các loại hạt tốt cho giảm cân',
        '🥛 Sữa chua Hy Lạp và hoa quả',
      ];
    } else if (hour >= 17 && hour < 21) {
      timePool = const [
        '🥗 Bữa tối nhẹ bụng giàu protein',
        '🥩 Phục hồi cơ sau tập gym tối',
        '🍲 Món ăn tối ít carbs hỗ trợ giảm cân',
        '🌙 Ăn tối mấy giờ để không tích mỡ?',
        '🐟 Cá hồi & rau củ áp chảo lành mạnh',
        '🥑 Bổ sung chất béo tốt vào bữa tối',
      ];
    } else {
      timePool = const [
        '🌙 Đói đêm ăn gì không sợ béo?',
        '🍵 Thức uống ấm giúp ngủ sâu giấc',
        '💤 Mẹo dập tắt cơn thèm ăn khuya',
        '📊 Nhận xét thực đơn hôm nay của tôi',
        '🥛 Uống sữa không đường trước khi ngủ?',
        '⚡ Chuẩn bị dinh dưỡng cho ngày mai',
      ];
    }

    // 3. Nutrition Science & Fitness Lifestyle Pool
    const generalPool = [
      '🏋️ Ăn trước hay sau khi tập gym tốt hơn?',
      '🔥 Cách tính thâm hụt calo chuẩn khoa học',
      '🥑 Tỷ lệ Macro chuẩn để giảm mỡ tăng cơ',
      '💧 Uống bao nhiêu lít nước mỗi ngày theo cân nặng?',
      '🧂 Tác hại của ăn mặn đối với mỡ thừa',
      '🍳 So sánh trứng luộc và trứng chiên',
      '🏃 30 phút chạy bộ đốt bao nhiêu calo?',
      '🥩 Nguồn đạm thực vật tốt cho người ăn chay',
    ];

    // Combine time pool and general pool, rotate by _suggestionShuffleIndex
    final combinedPool = [...timePool, ...generalPool];
    final startIndex = (_suggestionShuffleIndex * 4) % combinedPool.length;
    final selectedQuestions = <String>[];
    for (var i = 0; i < 4; i++) {
      selectedQuestions.add(combinedPool[(startIndex + i) % combinedPool.length]);
    }

    return [
      '🎲 Đổi gợi ý khác',
      ...contextSuggestions.take(2),
      ...selectedQuestions,
    ];
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0) {
      _wasKeyboardOpen = true;
      _scrollToBottom();
    } else if (bottomInset == 0 && _wasKeyboardOpen) {
      _wasKeyboardOpen = false;
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }
    setState(() {});
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isSending) return;

    _focusNode.unfocus();
    _textController.clear();
    setState(() => _isSending = true);
    _scrollToBottom();

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
          curve: Curves.easeOutCubic,
        );
      }
      _scrollTimer?.cancel();
      _scrollTimer = Timer(const Duration(milliseconds: 250), () {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
          );
        }
      });
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
    final viewInsetsBottom = MediaQuery.viewInsetsOf(context).bottom;
    final rawViewInsetsBottom = View.of(context).viewInsets.bottom;
    final hasPhysicalKeyboard = viewInsetsBottom > 0 || rawViewInsetsBottom > 0;
    final isKeyboardOpen = hasPhysicalKeyboard || _focusNode.hasFocus;

    bool isInTabs = false;
    try {
      AutoTabsRouter.of(context, watch: false);
      isInTabs = true;
    } catch (_) {
      isInTabs = false;
    }

    ref.listen(coachControllerProvider, (prev, next) {
      final prevCount = prev?.valueOrNull?.length ?? 0;
      final nextCount = next.valueOrNull?.length ?? 0;
      if (nextCount > prevCount) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Tooltip(
              message: 'Lịch sử hội thoại',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showHistorySheet();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE2DDD5),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFD4CEBF),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          size: 17,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Lịch sử',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Clean Warm Milk Canvas
          Positioned.fill(
            child: Container(color: AppColors.surface),
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
                      style: GoogleFonts.inter(
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
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        hasPhysicalKeyboard ? 16 : (isInTabs ? 96 : 24),
                      ),
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

          // Collapsible Dynamic Quick Actions & Disclaimer (never blocks chat view)
          _buildCollapsibleSuggestionsSection(isKeyboardOpen, summary),

          // Input bar + Floating Dock Clearance
          Padding(
            padding: EdgeInsets.only(
              bottom: hasPhysicalKeyboard ? 6 : (isInTabs ? 106 : (MediaQuery.paddingOf(context).bottom + 8)),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E0D8),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD4CEBF),
            offset: Offset(0, 2),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng quan dinh dưỡng hôm nay',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Còn lại: ${remainingCalories.clamp(0, 9999)} kcal',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: remainingCalories >= 0 ? AppColors.primary : AppColors.tertiary,
                  ),
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
                color: const Color(0xFFFFF8ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFE2B3), width: 1.2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Cảnh báo Natri: ${summary.totalSodiumMg.toInt()}mg / ${summary.targetSodiumMg.toInt()}mg (sắp chạm ngưỡng khuyến nghị)',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.w600,
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
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$current/${target}g',
              style: GoogleFonts.inter(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: const Color(0xFFF1EFEA),
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
              ? const Color(0xFFE0F2FE)
              : Colors.white,
          border: Border.all(
            color: isUser
                ? const Color(0xFFBAE6FD)
                : (message.isError ? AppColors.tertiary : const Color(0xFFE5E0D8)),
            width: 1.2,
          ),
          boxShadow: isUser
              ? const [
                  BoxShadow(
                    color: Color(0xFFBAE6FD),
                    offset: Offset(0, 2),
                    blurRadius: 0,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0xFFD4CEBF),
                    offset: Offset(0, 2.5),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x081E2337),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 18 : 4),
            topRight: Radius.circular(isUser ? 4 : 18),
            bottomLeft: const Radius.circular(18),
            bottomRight: const Radius.circular(18),
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
                      style: GoogleFonts.inter(
                        color: AppColors.onSurface,
                        fontSize: 14.5,
                        fontWeight: isUser ? FontWeight.w600 : FontWeight.w400,
                        height: 1.4,
                      ),
                    )
                  : MarkdownBody(
                      data: displayContent,
                      shrinkWrap: true,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.inter(
                          color: AppColors.onSurface,
                          fontSize: 14,
                          height: 1.45,
                        ),
                        h3: GoogleFonts.outfit(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                        strong: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        listBullet: GoogleFonts.inter(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        horizontalRuleDecoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFE5E0D8),
                              width: 1,
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
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                if (!isUser) ...[
                  const SizedBox(width: 6),
                  Text(
                    '• AstroCoach',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
            if (message.isError) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton.icon(
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
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Thử lại'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    ),
                  ),
                  if (message.content.contains('API Key'))
                    FilledButton.tonalIcon(
                      onPressed: () => GeminiApiKeyDialog.show(context),
                      icon: const Icon(Icons.vpn_key_rounded, size: 16),
                      label: const Text('Cài đặt API Key'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF7ED),
                        foregroundColor: AppColors.tertiary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                    ),
                ],
              ),
            ],
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

  Widget _buildCollapsibleSuggestionsSection(bool isKeyboardOpen, DailySummary summary) {
    if (_isSending || isKeyboardOpen) return const SizedBox.shrink();
    final actions = _getDynamicQuickActions(summary);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      child: _showSuggestions
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuickActions(actions),
                _buildMedicalDisclaimer(),
              ],
            )
          : _buildSuggestionsTogglePill(actions.length - 1),
    );
  }

  Widget _buildSuggestionsTogglePill(int count) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _showSuggestions = true);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2DDD5), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    offset: Offset(0, 1.5),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Gợi ý câu hỏi ($count)',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalDisclaimer() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0x0C1E2337),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '⚕️ AI gợi ý tham khảo, không thay thế chuyên gia y tế',
          style: GoogleFonts.inter(
            fontSize: 10.5,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildQuickActions(List<String> actions) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: actions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final action = actions[index];
                final isShuffle = action == '🎲 Đổi gợi ý khác';

                return ActionChip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(
                    action,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: isShuffle ? FontWeight.w700 : FontWeight.w600,
                      color: isShuffle ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  backgroundColor: isShuffle ? const Color(0xFFE5F6FD) : Colors.white,
                  side: BorderSide(
                    color: isShuffle ? const Color(0xFFBAE6FD) : const Color(0xFFE2DDD5),
                    width: 1.2,
                  ),
                  elevation: 1,
                  shadowColor: const Color(0x15000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (isShuffle) {
                      setState(() => _suggestionShuffleIndex++);
                    } else {
                      _sendMessage(action);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Tooltip(
              message: 'Thu gọn gợi ý',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _showSuggestions = false);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2DDD5), width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0E1E2337),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                enabled: !_isSending,
                decoration: InputDecoration(
                  hintText: 'Hỏi AstroCoach về thực đơn, macros...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.auto_awesome,
                      color: _showSuggestions ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                      size: 19,
                    ),
                    tooltip: _showSuggestions ? 'Thu gọn gợi ý' : 'Mở gợi ý câu hỏi',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() => _showSuggestions = !_showSuggestions);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2DDD5),
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2DDD5),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: GoogleFonts.inter(
                  color: AppColors.onSurface,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isSending ? null : () => _sendMessage(_textController.text),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF0369A1),
                      offset: Offset(0, 3),
                      blurRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x300284C7),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.send_rounded,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final sessionsAsync = ref.watch(chatSessionsListProvider);
            final currentSelected =
                ref.read(coachControllerProvider.notifier).selectedDate;

            return DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.35,
              maxChildSize: 0.88,
              expand: false,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 38,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4CEBF),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Header with Icon, Title & Close Button
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFBAE6FD), width: 1.2),
                              ),
                              child: const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lịch sử hội thoại AstroCoach',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    'Xem lại hoặc chuyển phiên tư vấn dinh dưỡng',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppColors.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 1,
                              shadowColor: const Color(0x15000000),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                customBorder: const CircleBorder(),
                                child: const Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Icon(Icons.close_rounded, size: 18, color: AppColors.onSurfaceVariant),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFE5E0D8), height: 1, thickness: 1),
                        const SizedBox(height: 12),

                        // Session Cards
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
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0F9FF),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                                        ),
                                        child: const Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          size: 34,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Chưa có cuộc trò chuyện nào trước đó.',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Các phiên tư vấn dinh dưỡng hàng ngày sẽ tự động lưu tại đây.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return ListView.separated(
                                controller: scrollController,
                                itemCount: sessions.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final s = sessions[index];
                                  final dateStr = s['date'] as String? ?? '';
                                  final count = s['message_count'] as int? ?? 0;
                                  final lastMsg = s['last_message'] as String? ?? '';
                                  final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                  final isToday = dateStr == todayStr;
                                  final isSelected = (currentSelected == null && isToday) ||
                                      (currentSelected == dateStr);

                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        ref.read(coachControllerProvider.notifier).selectSessionDate(
                                              isToday ? null : dateStr,
                                            );
                                        Navigator.pop(context);
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        padding: const EdgeInsets.all(13),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : const Color(0xFFE5E0D8),
                                            width: isSelected ? 1.8 : 1.2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? const Color(0xFFBAE6FD)
                                                  : const Color(0xFFD4CEBF),
                                              offset: const Offset(0, 2.5),
                                              blurRadius: 0,
                                            ),
                                            const BoxShadow(
                                              color: Color(0x061E2337),
                                              offset: Offset(0, 4),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? const Color(0xFFE0F2FE)
                                                        : const Color(0xFFFAF8F5),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    isToday ? Icons.today_rounded : Icons.calendar_today_rounded,
                                                    size: 15,
                                                    color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          isToday ? 'Hôm nay ($dateStr)' : dateStr,
                                                          style: GoogleFonts.outfit(
                                                            fontWeight: FontWeight.w800,
                                                            fontSize: 13.5,
                                                            color: isSelected ? AppColors.primary : AppColors.onSurface,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      if (isSelected) ...[
                                                        const SizedBox(width: 6),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFE0F2FE),
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          child: Text(
                                                            'Đang xem',
                                                            style: GoogleFonts.inter(
                                                              fontSize: 9.5,
                                                              fontWeight: FontWeight.w700,
                                                              color: const Color(0xFF0284C7),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF0F9FF),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                                                  ),
                                                  child: Text(
                                                    '$count tin nhắn',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFF0284C7),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Tooltip(
                                                  message: 'Xoá cuộc trò chuyện',
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        HapticFeedback.lightImpact();
                                                        _confirmDeleteSession(dateStr);
                                                      },
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Container(
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFFFF1F2),
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(color: const Color(0xFFFECDD3), width: 1),
                                                        ),
                                                        child: const Icon(
                                                          Icons.delete_outline_rounded,
                                                          size: 16,
                                                          color: AppColors.error,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (lastMsg.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFAF8F5),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: const Color(0xFFF0EBE1), width: 1),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.chat_bubble_outline_rounded,
                                                      size: 12,
                                                      color: AppColors.onSurfaceVariant,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        lastMsg,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.inter(
                                                          fontSize: 11.5,
                                                          color: AppColors.onSurfaceVariant,
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
