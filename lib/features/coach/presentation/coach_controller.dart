import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../data/coach_repository.dart';
import '../domain/chat_message.dart';

part 'coach_controller.g.dart';

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  return CoachRepository();
});

@riverpod
class CoachController extends _$CoachController {
  @override
  FutureOr<List<ChatMessage>> build() async {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return [];

    final repo = ref.read(coachRepositoryProvider);
    return repo.loadTodaySession(user.uid);
  }

  /// Sends a user message and receives AI response.
  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final repo = ref.read(coachRepositoryProvider);
    final currentMessages = state.valueOrNull ?? [];

    // Check daily limit
    final count = await repo.getTodayMessageCount(user.uid);
    if (count >= repo.maxMessagesPerDay) {
      throw Exception('daily_limit_reached');
    }

    final now = DateTime.now();
    // Add user message immediately
    final userMsg = ChatMessage(
      id: '${now.microsecondsSinceEpoch}_u',
      role: 'user',
      content: text,
      timestamp: now,
    );

    state = AsyncData(<ChatMessage>[...currentMessages, userMsg]);
    await repo.saveMessage(user.uid, userMsg);

    // Build meal context from today's tracker
    final mealContext = _buildMealContext();

    try {
      final response = await repo
          .sendMessage(
            userMessage: text,
            userId: user.uid,
            mealContext: mealContext,
            history: [...currentMessages, userMsg],
          )
          .timeout(const Duration(seconds: 15));

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
    } catch (e) {
      final errTime = DateTime.now();
      final errorMsg = ChatMessage(
        id: '${errTime.microsecondsSinceEpoch}_err',
        role: 'assistant',
        content: 'AI đang bận, vui lòng thử lại.',
        timestamp: errTime,
        isError: true,
      );
      state = AsyncData(<ChatMessage>[...state.valueOrNull ?? [], errorMsg]);
    }
  }

  /// Builds meal context string from today's tracker data.
  String _buildMealContext() {
    try {
      // ponytail: read from existing tracker providers when available
      // For now, return a safe default that doesn't crash
      return 'Chưa có dữ liệu bữa ăn hôm nay.';
    } catch (_) {
      return 'Không thể đọc dữ liệu bữa ăn.';
    }
  }
}
