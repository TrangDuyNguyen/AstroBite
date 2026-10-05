import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';
import 'package:astrobite/features/social/presentation/controllers/social_controller.dart';
import 'package:astrobite/features/social/presentation/pages/leaderboard_page.dart';

void main() {
  Widget createWidgetUnderTest({List<LeaderboardEntry>? entries}) {
    return ProviderScope(
      overrides: [
        if (entries != null)
          leaderboardStreamProvider.overrideWith(
            (ref) => Stream.value(entries),
          ),
      ],
      child: const MaterialApp(
        home: LeaderboardPage(),
      ),
    );
  }

  testWidgets('LeaderboardPage renders user Astro ID and leaderboard list',
      (WidgetTester tester) async {
    final mockEntries = [
      const LeaderboardEntry(
        uid: 'user_01',
        name: 'AlexD',
        astroId: '#AST-0042',
        streak: 45,
        rank: 1,
        goalAchievedToday: false,
      ),
      const LeaderboardEntry(
        uid: 'user_me',
        name: 'TrangNguyen (Bạn)',
        astroId: '#ASTRO-8821',
        streak: 42,
        rank: 2,
        isMe: true,
        goalAchievedToday: true,
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(entries: mockEntries));
    await tester.pump();

    // Verify Title
    expect(find.text('Bảng Xếp Hạng'), findsOneWidget);
    // Verify Astro ID Card
    expect(find.text('#ASTRO-8821'), findsWidgets);
    // Verify Friend names
    expect(find.text('AlexD'), findsOneWidget);
    expect(find.text('TrangNguyen (Bạn)'), findsOneWidget);
    // Verify Ranks
    expect(find.text('👑'), findsOneWidget);
    expect(find.text('🥈'), findsOneWidget);
  });

  testWidgets('LeaderboardPage renders Nudge button for friends who missed goal',
      (WidgetTester tester) async {
    final mockEntries = [
      const LeaderboardEntry(
        uid: 'user_01',
        name: 'AlexD',
        astroId: '#AST-0042',
        streak: 45,
        rank: 1,
        goalAchievedToday: false,
        isNudgedToday: false,
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(entries: mockEntries));
    await tester.pump();

    // AlexD hasn't achieved goal, so "Nhắc" button should be visible
    expect(find.text('Nhắc'), findsOneWidget);

    // Tap on Nudge button to show sheet
    await tester.tap(find.text('Nhắc'));
    await tester.pumpAndSettle();

    // Confirmation sheet should appear
    expect(find.text('Cứu Streak Bạn Bè'), findsOneWidget);
    expect(find.text('Gửi Tín Hiệu'), findsOneWidget);
  });

  testWidgets('LeaderboardPage renders empty state when no friends exist',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(entries: []));
    await tester.pump();

    expect(find.text('Bạn chưa có ai để so tài'), findsOneWidget);
    expect(find.text('Thêm Bạn Ngay'), findsOneWidget);
  });
}
