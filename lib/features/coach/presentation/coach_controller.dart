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
