import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/domain/chat_message.dart';
import 'package:astrobite/features/coach/presentation/coach_controller.dart';
import 'package:astrobite/features/coach/presentation/coach_page.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';

void main() {
  group('AstroCoach v2 Feature Tests', () {
    testWidgets('Renders Context Header Strip with remaining calories, macros, and sodium warning', (tester) async {
      const summary = DailySummary(
        date: '2026-09-24',
        totalCalories: 1350,
        targetCalories: 2000,
        totalProteinG: 82,
        targetProteinG: 110,
        totalCarbsG: 130,
        targetCarbsG: 175,
        totalFatG: 48,
        targetFatG: 60,
        totalSodiumMg: 1850.0,
        targetSodiumMg: 2000.0,
        logs: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coachControllerProvider.overrideWith(() => _MockCoachController([])),
            todaySummaryProvider.overrideWithValue(summary),
          ],
          child: const MaterialApp(
            home: CoachPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check AppBar
      expect(find.text('AstroCoach AI ✨'), findsOneWidget);
      expect(find.text('Online • Real-time Nutritionist'), findsOneWidget);

      // Check Context Header
      expect(find.text('Tổng quan dinh dưỡng hôm nay'), findsOneWidget);
      expect(find.text('Còn lại: 650 kcal'), findsOneWidget);
      expect(find.text('Carbs'), findsOneWidget);
      expect(find.text('130/175g'), findsOneWidget);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('82/110g'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);
      expect(find.text('48/60g'), findsOneWidget);

      // Check Sodium Warning
      expect(
        find.textContaining('Cảnh báo Natri: 1850mg / 2000mg'),
        findsOneWidget,
      );
    });

    testWidgets('Parses ```astrobite-meal block and renders Holographic Bento Meal Card', (tester) async {
      const rawMarkdownAiMessage = '''
Dựa vào nhật ký hôm nay, bạn còn thiếu 28g protein. Tôi đề xuất bữa tối sau:
```astrobite-meal
{
  "dishName": "Ức gà áp chảo quinoa & bông cải xanh",
  "calories": 420,
  "protein": 34,
  "carbs": 38,
  "fat": 8,
  "sodium": 210,
  "mealType": "dinner",
  "ingredients": ["150g ức gà", "100g quinoa", "80g bông cải"]
}
```
Chúc bạn ngon miệng!
''';

      final messages = [
        ChatMessage(
          id: 'ai_msg_1',
          role: 'assistant',
          content: rawMarkdownAiMessage,
          timestamp: DateTime(2026, 9, 24, 19, 45),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coachControllerProvider.overrideWith(() => _MockCoachController(messages)),
            todaySummaryProvider.overrideWithValue(
              const DailySummary(
                date: '2026-09-24',
                totalCalories: 1350,
                targetCalories: 2000,
                totalProteinG: 82,
                targetProteinG: 110,
                totalCarbsG: 130,
                targetCarbsG: 175,
                totalFatG: 48,
                targetFatG: 60,
                logs: [],
              ),
            ),
          ],
          child: const MaterialApp(
            home: CoachPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Conversational text should display without raw code block
      expect(
        find.textContaining('Dựa vào nhật ký hôm nay, bạn còn thiếu 28g protein.'),
        findsOneWidget,
      );
      expect(find.textContaining('```astrobite-meal'), findsNothing);

      // Holographic Bento Meal Card components
      expect(find.text('Ức gà áp chảo quinoa & bông cải xanh'), findsOneWidget);
      expect(find.text('420 kcal • 34g P • 38g C • 8g F'), findsOneWidget);
      expect(find.text('Đạm: 34g'), findsOneWidget);
      expect(find.text('Carbs: 38g'), findsOneWidget);
      expect(find.text('Béo: 8g'), findsOneWidget);
      expect(find.text('Natri: 210mg'), findsOneWidget);
      expect(find.textContaining('Thành phần: 150g ức gà, 100g quinoa, 80g bông cải'), findsOneWidget);

      // 1-Tap CTA button exists
      expect(find.text('1-Chạm'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Gracefully handles malformed astrobite-meal block as plain text', (tester) async {
      const malformedAiMessage = '''
Tôi đề xuất món này:
```astrobite-meal
{ "dishName": "Bún chả", "calories": invalid_syntax
```
Hãy thưởng thức nhé!
''';

      final messages = [
        ChatMessage(
          id: 'ai_msg_err',
          role: 'assistant',
          content: malformedAiMessage,
          timestamp: DateTime(2026, 9, 24, 20, 0),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coachControllerProvider.overrideWith(() => _MockCoachController(messages)),
            todaySummaryProvider.overrideWithValue(
              const DailySummary(
                date: '2026-09-24',
                totalCalories: 1000,
                targetCalories: 2000,
                totalProteinG: 50,
                targetProteinG: 100,
                totalCarbsG: 100,
                targetCarbsG: 200,
                totalFatG: 30,
                targetFatG: 60,
                logs: [],
              ),
            ),
          ],
          child: const MaterialApp(
            home: CoachPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // No exception and renders text content gracefully
      expect(find.textContaining('Tôi đề xuất món này:'), findsOneWidget);
    });

    testWidgets('Renders dynamic quick action chips and input bar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coachControllerProvider.overrideWith(() => _MockCoachController([])),
            todaySummaryProvider.overrideWithValue(
              const DailySummary(
                date: '2026-09-24',
                totalCalories: 1200,
                targetCalories: 2000,
                totalProteinG: 70,
                targetProteinG: 120,
                totalCarbsG: 120,
                targetCarbsG: 200,
                totalFatG: 40,
                targetFatG: 60,
                logs: [],
              ),
            ),
          ],
          child: const MaterialApp(
            home: CoachPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Quick action chips exist
      expect(find.byType(ActionChip), findsWidgets);

      // Input bar exists
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsOneWidget);
      expect(find.textContaining('AI gợi ý tham khảo, không thay thế chuyên gia y tế'), findsOneWidget);
    });

    testWidgets('When keyboard is opened, quick action chips and disclaimer hide to expand chat viewport', (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(() => tester.view.resetViewInsets());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coachControllerProvider.overrideWith(
              () => _MockCoachController([
                ChatMessage(
                  id: '1',
                  role: 'user',
                  content: 'Gợi ý bữa sáng',
                  timestamp: DateTime(2026, 9, 29, 8, 30),
                ),
              ]),
            ),
            todaySummaryProvider.overrideWith(
              (ref) => const DailySummary(
                date: '2026-09-24',
                totalCalories: 1200,
                targetCalories: 2000,
                totalProteinG: 70,
                targetProteinG: 120,
                totalCarbsG: 120,
                targetCarbsG: 200,
                totalFatG: 40,
                targetFatG: 60,
                logs: [],
              ),
            ),
          ],
          child: const MaterialApp(
            home: CoachPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Quick action chips and disclaimer are hidden
      expect(find.byType(ActionChip), findsNothing);
      expect(find.textContaining('AI gợi ý tham khảo, không thay thế chuyên gia y tế'), findsNothing);

      // Input bar still exists
      expect(find.byType(TextField), findsOneWidget);

      // Verify ListView has keyboard dismiss behavior
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.keyboardDismissBehavior, ScrollViewKeyboardDismissBehavior.onDrag);
    });

    testWidgets('Tapping History button opens bottom sheet with past conversation sessions and switches session', (tester) async {
      final mockSessions = [
        {
          'date': '2026-09-23',
          'message_count': 6,
          'last_message': 'Bạn nên uống đủ 2 lít nước hôm nay nhé!',
        },
        {
          'date': '2026-09-22',
          'message_count': 4,
          'last_message': 'Gợi ý bữa trưa cá hồi áp chảo.',
        },
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coachControllerProvider.overrideWith(() => _MockCoachController([])),
            chatSessionsListProvider.overrideWith((ref) => Future.value(mockSessions)),
            todaySummaryProvider.overrideWithValue(
              const DailySummary(
                date: '2026-09-24',
                totalCalories: 1000,
                targetCalories: 2000,
                totalProteinG: 60,
                targetProteinG: 120,
                totalCarbsG: 100,
                targetCarbsG: 200,
                totalFatG: 30,
                targetFatG: 60,
                logs: [],
              ),
            ),
          ],
          child: const MaterialApp(
            home: CoachPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // History button exists in AppBar
      final historyBtn = find.byIcon(Icons.history_rounded);
      expect(historyBtn, findsOneWidget);

      // Tap history button
      await tester.tap(historyBtn);
      await tester.pumpAndSettle();

      // Bottom sheet header
      expect(find.text('Lịch sử hội thoại AstroCoach'), findsOneWidget);

      // Sessions displayed
      expect(find.text('2026-09-23'), findsOneWidget);
      expect(find.text('6 tin nhắn'), findsOneWidget);
      expect(find.text('Bạn nên uống đủ 2 lít nước hôm nay nhé!'), findsOneWidget);
      expect(find.text('2026-09-22'), findsOneWidget);

      // Tap on past session
      await tester.tap(find.text('2026-09-23'));
      await tester.pumpAndSettle();

      // Bottom sheet closes and review notice banner appears
      expect(find.textContaining('Đang xem lại phiên: 2026-09-23'), findsOneWidget);
      expect(find.text('Hôm nay ↺'), findsOneWidget);

      // Tap "Hôm nay ↺" to return
      await tester.tap(find.text('Hôm nay ↺'));
      await tester.pumpAndSettle();

      // Banner is removed
      expect(find.textContaining('Đang xem lại phiên'), findsNothing);
    });

    testWidgets('Tapping delete button in history sheet displays confirmation dialog and triggers deletion', (tester) async {
      final mockMessages = [
        ChatMessage(
          id: 'msg_1',
          role: 'user',
          content: 'Tư vấn bữa tối',
          timestamp: DateTime.now(),
        ),
      ];
      final mockSessions = [
        {
          'date': '2026-09-24',
          'message_count': 1,
          'last_message': 'Tư vấn bữa tối',
        }
      ];
      final mockController = _MockCoachController(mockMessages);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            coachControllerProvider.overrideWith(() => mockController),
            chatSessionsListProvider.overrideWith((ref) => Future.value(mockSessions)),
            todaySummaryProvider.overrideWithValue(
              const DailySummary(
                date: '2026-09-24',
                totalCalories: 1000,
                targetCalories: 2000,
                totalProteinG: 60,
                targetProteinG: 120,
                totalCarbsG: 100,
                targetCarbsG: 200,
                totalFatG: 30,
                targetFatG: 60,
                logs: [],
              ),
            ),
          ],
          child: const MaterialApp(
            home: CoachPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open history sheet
      final historyBtn = find.byTooltip('Lịch sử hội thoại');
      expect(historyBtn, findsOneWidget);
      await tester.tap(historyBtn);
      await tester.pumpAndSettle();

      final deleteBtn = find.byTooltip('Xoá cuộc trò chuyện');
      expect(deleteBtn, findsOneWidget);

      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Confirmation dialog should be displayed
      expect(find.text('Xoá cuộc trò chuyện?'), findsOneWidget);
      expect(find.text('Xoá'), findsOneWidget);
      expect(find.text('Huỷ'), findsOneWidget);

      // Tap confirm "Xoá"
      await tester.tap(find.text('Xoá'));
      await tester.pumpAndSettle();

      expect(mockController.deleteCalled, isTrue);
      expect(find.text('🗑️ Đã xoá cuộc trò chuyện thành công.'), findsOneWidget);
    });
  });
}

class _MockCoachController extends CoachController {
  _MockCoachController(this._messages);
  final List<ChatMessage> _messages;
  String? _mockSelectedDate;
  bool deleteCalled = false;
  String? lastDeletedDate;

  @override
  String? get selectedDate => _mockSelectedDate;

  @override
  Future<List<ChatMessage>> build() async => _messages;

  @override
  Future<void> selectSessionDate(String? date) async {
    _mockSelectedDate = date;
    state = AsyncData(_messages);
  }

  @override
  Future<void> deleteSession([String? dateToDelete]) async {
    deleteCalled = true;
    lastDeletedDate = dateToDelete;
    state = const AsyncData([]);
  }
}
