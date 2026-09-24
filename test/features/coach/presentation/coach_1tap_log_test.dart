import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/coach/domain/chat_message.dart';
import 'package:astrobite/features/coach/presentation/coach_controller.dart';
import 'package:astrobite/features/coach/presentation/coach_page.dart';

import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';

void main() {
  testWidgets('CoachPage renders 1-Tap meal suggestion card and strips hidden tag from text', (tester) async {
    const rawAiMessage =
        'Bạn nên ăn một đĩa ức gà áp chảo để bù đủ 30g protein nhé!<!--astrobite-meal:{"dishName":"Ức Gà Áp Chảo","calories":280,"protein":32,"carbs":5,"fat":6,"mealType":"dinner"}-->';

    final messages = [
      ChatMessage(
        id: 'msg_1',
        role: 'assistant',
        content: rawAiMessage,
        timestamp: DateTime(2026, 9, 19, 12, 30),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coachControllerProvider.overrideWith(() => _FakeCoachController(messages)),
          todaySummaryProvider.overrideWithValue(
            const DailySummary(
              date: '2026-09-19',
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

    // Verify natural message text is displayed without the raw tag
    expect(
      find.text('Bạn nên ăn một đĩa ức gà áp chảo để bù đủ 30g protein nhé!'),
      findsOneWidget,
    );
    expect(find.textContaining('<!--astrobite-meal'), findsNothing);

    // Verify 1-Tap meal suggestion card is rendered
    expect(find.text('Ức Gà Áp Chảo'), findsOneWidget);
    expect(find.text('280 kcal • 32g P • 5g C • 6g F'), findsOneWidget);
    expect(find.text('1-Chạm'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}

class _FakeCoachController extends CoachController {
  _FakeCoachController(this._messages);
  final List<ChatMessage> _messages;

  @override
  Future<List<ChatMessage>> build() async => _messages;
}
