import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import '../data/coach_repository.dart';
import '../domain/chat_message.dart';

part 'coach_controller.g.dart';

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  return CoachRepository();
});

final chatSessionsListProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return [];
  final repo = ref.watch(coachRepositoryProvider);
  return repo.loadChatSessionsList(user.uid);
});

@riverpod
class CoachController extends _$CoachController {
  String? _selectedDate;
  String? get selectedDate => _selectedDate;

  @override
  FutureOr<List<ChatMessage>> build() async {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return [];

    final repo = ref.read(coachRepositoryProvider);
    return repo.loadTodaySession(user.uid);
  }

  /// Switches to review a past chat session by date, or pass null to return to today.
  Future<void> selectSessionDate(String? date) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    _selectedDate = date;
    state = const AsyncLoading();
    final repo = ref.read(coachRepositoryProvider);
    try {
      if (date == null) {
        state = AsyncData(await repo.loadTodaySession(user.uid));
      } else {
        state = AsyncData(await repo.loadSessionByDate(user.uid, date));
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Deletes a chat session by date, or deletes the active session if date is omitted.
  Future<void> deleteSession([String? dateToDelete]) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final targetDate = dateToDelete ?? _selectedDate ?? today;
    final repo = ref.read(coachRepositoryProvider);

    await repo.deleteSession(user.uid, targetDate);
    ref.invalidate(chatSessionsListProvider);

    final currentViewingDate = _selectedDate ?? today;
    if (targetDate == currentViewingDate) {
      if (_selectedDate != null) {
        _selectedDate = null;
        state = AsyncData(await repo.loadTodaySession(user.uid));
      } else {
        state = const AsyncData([]);
      }
    }
  }

  /// Sends a user message and receives AI response.
  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final repo = ref.read(coachRepositoryProvider);

    // Check daily limit
    final count = await repo.getTodayMessageCount(user.uid);
    if (count >= repo.maxMessagesPerDay) {
      throw Exception('daily_limit_reached');
    }

    final now = DateTime.now();
    final rawMessages = state.valueOrNull ?? [];
    final currentMessages = rawMessages.where((m) => !m.isError).toList();

    // Check if this is a retry of the last message (e.g. user tapped "Thử lại")
    final bool isRetry = currentMessages.isNotEmpty &&
        currentMessages.last.isUser &&
        currentMessages.last.content == text;

    final ChatMessage userMsg;
    final List<ChatMessage> historyForAi;

    if (isRetry) {
      userMsg = currentMessages.last;
      historyForAi = currentMessages.sublist(0, currentMessages.length - 1);
    } else {
      userMsg = ChatMessage(
        id: '${now.microsecondsSinceEpoch}_u',
        role: 'user',
        content: text,
        timestamp: now,
      );
      historyForAi = currentMessages;
      state = AsyncData(<ChatMessage>[...currentMessages, userMsg]);
      await repo.saveMessage(user.uid, userMsg);
    }

    // Build meal context from today's tracker
    final mealContext = _buildMealContext();

    const maxRetries = 1;
    const timeout = Duration(seconds: 35);

    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await repo
            .sendMessage(
              userMessage: text,
              userId: user.uid,
              mealContext: mealContext,
              history: historyForAi,
            )
            .timeout(timeout);

        final aiTime = DateTime.now();
        final aiMsg = ChatMessage(
          id: '${aiTime.microsecondsSinceEpoch}_a',
          role: 'assistant',
          content: response,
          timestamp: aiTime,
        );

        final updated = <ChatMessage>[...state.valueOrNull ?? [], aiMsg];
        state = AsyncData(updated);
        await repo.saveMessage(user.uid, aiMsg);
        return; // Success — exit retry loop
      } on TimeoutException {
        if (attempt < maxRetries) {
          await Future<void>.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        _addErrorMessage('Phản hồi quá lâu. Vui lòng thử lại.');
      } on InvalidApiKey {
        _addErrorMessage('API Key không hợp lệ. Kiểm tra cài đặt.');
        return; // No point retrying
      } on ServerException catch (e) {
        debugPrint('Gemini ServerException: ${e.message}');
        if (attempt < maxRetries) {
          await Future<void>.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        _addErrorMessage('Máy chủ AI đang quá tải. Vui lòng thử lại sau.');
      } on GenerativeAIException catch (e) {
        debugPrint('GenerativeAIException: ${e.message}');
        _addErrorMessage('Lỗi AI: ${e.message}');
        return; // Likely a non-retryable config error
      } catch (e, st) {
        debugPrint('Coach unexpected error: $e\n$st');
        if (attempt < maxRetries) {
          await Future<void>.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        _addErrorMessage('Có lỗi xảy ra. Vui lòng thử lại.');
      }
    }
  }

  /// Appends an error message bubble to the chat state.
  void _addErrorMessage(String content) {
    final errTime = DateTime.now();
    final errorMsg = ChatMessage(
      id: '${errTime.microsecondsSinceEpoch}_err',
      role: 'assistant',
      content: content,
      timestamp: errTime,
      isError: true,
    );
    state = AsyncData(<ChatMessage>[...state.valueOrNull ?? [], errorMsg]);
  }

  /// Removes all error messages from the current state (used before retry).
  void removeErrors() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.where((m) => !m.isError).toList());
  }

  /// Marks a meal recommendation message as logged.
  void markMessageLogged(String messageId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.map((msg) {
      if (msg.id == messageId) {
        return msg.copyWith(isLogged: true);
      }
      return msg;
    }).toList());
  }

  /// Builds meal context string from today's tracker, user profile, and streak data.
  String _buildMealContext() {
    try {
      final summary = ref.read(todaySummaryProvider);
      final profile = ref.read(userProfileStreamProvider).valueOrNull;
      final streak = ref.read(streakNotifierProvider).valueOrNull;

      final remaining = (summary.targetCalories - summary.totalCalories).clamp(0, 9999);
      final goal = profile?.fitnessGoal ?? 'Duy trì vóc dáng';
      final weight = profile?.weightKg ?? 70.0;
      final tdee = profile?.tdee ?? 2000;
      final streakDays = streak?.currentStreak ?? 0;

      final mealLogsText = summary.logs.isEmpty
          ? 'Hôm nay chưa ghi nhận món ăn nào.'
          : summary.logs
              .map((l) => '${l.dishName} (${l.calories} kcal, ${l.mealType})')
              .join(', ');

      return '''
[Hồ Sơ Tiểu Vũ Trụ Người Dùng]
- Mục tiêu cá nhân: $goal (Cân nặng: ${weight}kg, TDEE: $tdee kcal).
- Chuỗi ngày ăn sạch liên tiếp: $streakDays ngày.
- Tình trạng dinh dưỡng hôm nay (${summary.date}):
  + Đã nạp: ${summary.totalCalories} kcal / Chỉ tiêu: ${summary.targetCalories} kcal (Ngân sách calo còn lại: $remaining kcal).
  + Macro đã nạp: Protein ${summary.totalProteinG}g/${summary.targetProteinG}g, Carbs ${summary.totalCarbsG}g/${summary.targetCarbsG}g, Fat ${summary.totalFatG}g/${summary.targetFatG}g.
  + Vi chất đã nạp: Natri ${summary.totalSodiumMg.toInt()}mg / ${summary.targetSodiumMg.toInt()}mg.
  + Món đã ăn hôm nay: $mealLogsText
''';
    } catch (_) {
      return 'Chưa có dữ liệu bữa ăn hôm nay.';
    }
  }
}
