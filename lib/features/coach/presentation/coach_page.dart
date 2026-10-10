import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:astrobite/core/genui/catalog.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/coach/domain/astrobite_genui_catalog.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/controllers/tracker_controller.dart';
import 'package:astrobite/features/voice/presentation/controllers/voice_log_controller.dart';
import 'coach_controller.dart';
import 'widgets/coach_app_bar.dart';
import 'widgets/coach_message_list.dart';
import 'widgets/coach_context_header.dart';
import 'widgets/coach_empty_state.dart';
import 'widgets/coach_input_bar.dart';
import 'widgets/coach_quick_actions.dart';
import 'widgets/coach_session_banner.dart';

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
  bool _isListeningVoice = false;
  int _suggestionShuffleIndex = 0;
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
      if (_focusNode.hasFocus) _scrollToBottom();
    }
  }

  Future<void> _toggleVoiceDictation() async {
    final voiceService = ref.read(voiceRecognitionServiceProvider);
    if (_isListeningVoice) {
      await voiceService.stopListening();
      if (mounted) setState(() => _isListeningVoice = false);
      return;
    }

    HapticFeedback.mediumImpact();
    final hasPermission = await voiceService.initialize();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể truy cập Microphone để nhận diện giọng nói'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (!mounted) return;
    setState(() => _isListeningVoice = true);

    await voiceService.startListening(
      onResult: (words, isFinal) {
        if (!mounted) return;
        setState(() {
          _textController.text = words;
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: words.length),
          );
        });
        if (isFinal) {
          setState(() => _isListeningVoice = false);
          HapticFeedback.lightImpact();
        }
      },
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    if (_isListeningVoice) {
      ref.read(voiceRecognitionServiceProvider).stopListening();
    }
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
      if (_focusNode.hasFocus) _focusNode.unfocus();
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

    setState(() => _loggedMessageIds.add(messageId));
    ref.read(coachControllerProvider.notifier).markMessageLogged(messageId);
    await ref.read(trackerControllerProvider.notifier).addFoodLog(userId: user.uid, log: log);

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

    final selectedDate = ref.watch(coachControllerProvider.notifier).selectedDate;

    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      appBar: const CoachAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: AppColors.surface),
          ),
          Column(
            children: [
              CoachContextHeader(summary: summary),

              if (selectedDate != null)
                CoachSessionBanner(
                  selectedDate: selectedDate,
                  onResetToToday: () =>
                      ref.read(coachControllerProvider.notifier).selectSessionDate(null),
                ),

              Expanded(
                child: messagesAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (e, _) => Center(
                    child: Text('Lỗi: $e', style: const TextStyle(color: AppColors.onSurfaceVariant)),
                  ),
                  data: (messages) => messages.isEmpty
                      ? CoachEmptyState(summary: summary)
                      : CoachMessageList(
                          messages: messages,
                          scrollController: _scrollController,
                          isSending: _isSending,
                          hasPhysicalKeyboard: hasPhysicalKeyboard,
                          isInTabs: isInTabs,
                          loggedMessageIds: _loggedMessageIds,
                          genUiCatalog: _genUiCatalog,
                          onLogMeal: _logMealFromCoach,
                          onSendMessage: _sendMessage,
                          onRetry: (msg) {
                            final lastUserMsg = messages.lastWhere(
                              (m) => m.isUser,
                              orElse: () => msg,
                            );
                            if (lastUserMsg.isUser) {
                              ref.read(coachControllerProvider.notifier).removeErrors();
                              _sendMessage(lastUserMsg.content);
                            }
                          },
                        ),
                ),
              ),

              CoachQuickActions(
                isKeyboardOpen: isKeyboardOpen,
                isSending: _isSending,
                showSuggestions: _showSuggestions,
                summary: summary,
                shuffleIndex: _suggestionShuffleIndex,
                onShuffle: () => setState(() => _suggestionShuffleIndex++),
                onToggleShow: (show) => setState(() => _showSuggestions = show),
                onSelectPrompt: _sendMessage,
              ),

              Padding(
                padding: EdgeInsets.only(
                  bottom: hasPhysicalKeyboard ? 6 : (isInTabs ? 106 : (MediaQuery.paddingOf(context).bottom + 8)),
                ),
                child: CoachInputBar(
                  textController: _textController,
                  focusNode: _focusNode,
                  isSending: _isSending,
                  isListeningVoice: _isListeningVoice,
                  showSuggestions: _showSuggestions,
                  onToggleSuggestions: () => setState(() => _showSuggestions = !_showSuggestions),
                  onToggleVoice: _toggleVoiceDictation,
                  onSubmitted: _sendMessage,
                  onSend: () => _sendMessage(_textController.text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
