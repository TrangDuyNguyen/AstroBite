import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/guilds/data/repositories/mock_guild_repository.dart';
import 'package:astrobite/features/guilds/presentation/controllers/guild_controller.dart';
import 'package:astrobite/features/guilds/presentation/pages/guild_page.dart';
import 'package:astrobite/features/guilds/presentation/widgets/member_action_sheet.dart';
import 'package:astrobite/features/guilds/presentation/widgets/planetary_challenge_card.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

void main() {
  group('GuildPage Widget Tests (Gate 4 & Gate 6 Visual Verification)', () {
    testWidgets('renders active guild state with challenge card and member tiles',
        (tester) async {
      final repo = MockGuildRepository(seedDefaultData: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            guildRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: GuildPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Header & AppBar
      expect(find.text('Bang Hội Vũ Trụ'), findsOneWidget);
      expect(find.text('Vệ Binh Sao Hỏa'), findsOneWidget);
      expect(find.text('MARS01'), findsOneWidget);

      // Verify Planetary Challenge Card
      expect(find.byType(PlanetaryChallengeCard), findsOneWidget);
      expect(find.textContaining('CHIẾN DỊCH TUẦN'), findsOneWidget);
      expect(find.textContaining('34500 / 50000 XP'), findsOneWidget);

      // Verify Members Leaderboard
      expect(find.text('BẢNG XẾP HẠNG ĐÓNG GÓP'), findsOneWidget);
      expect(find.text('Lan (Leader)'), findsOneWidget);
      expect(find.text('Bạn (Me)'), findsOneWidget);
      expect(find.byType(Clay3DStar), findsWidgets); // MVP 3D clay star
      expect(find.text('850 XP'), findsOneWidget);

      // Verify Nudge button exists for other member
      expect(find.byKey(const Key('nudge_btn_user_001')), findsOneWidget);

      // Tap Nudge button
      await tester.tap(find.byKey(const Key('nudge_btn_user_001')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Đã gửi lời nhắc giữ Streak'), findsOneWidget);
    });

    testWidgets('renders empty state when user has no guild', (tester) async {
      final repo = MockGuildRepository(seedDefaultData: false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            guildRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: GuildPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Gia Nhập Bang Hội Vũ Trụ'), findsOneWidget);
      expect(find.byKey(const Key('create_guild_button')), findsOneWidget);
      expect(find.byKey(const Key('join_guild_button')), findsOneWidget);
    });

    testWidgets('opens rules dialog when info icon tapped', (tester) async {
      final repo = MockGuildRepository(seedDefaultData: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            guildRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: GuildPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('guild_info_button')));
      await tester.pumpAndSettle();

      expect(find.text('Thể Lệ Thử Thách'), findsOneWidget);
      expect(find.text('Đã Hiểu'), findsOneWidget);

      await tester.tap(find.text('Đã Hiểu'));
      await tester.pumpAndSettle();

      expect(find.text('Thể Lệ Thử Thách'), findsNothing);
    });

    testWidgets('opens guild governance settings sheet when settings button tapped',
        (tester) async {
      final repo = MockGuildRepository(seedDefaultData: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            guildRepositoryProvider.overrideWithValue(repo),
            currentUserIdProvider.overrideWithValue('user_001'),
          ],
          child: const MaterialApp(
            home: GuildPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('guild_settings_button')));
      await tester.pumpAndSettle();

      expect(find.text('Cài Đặt Bang Hội'), findsOneWidget);
      expect(find.text('Chỉnh sửa thông tin Bang Hội'), findsOneWidget);
      expect(find.text('Sao chép mã mời bạn bè'), findsOneWidget);
    });

    testWidgets('opens member action sheet when member tile tapped', (tester) async {
      final repo = MockGuildRepository(seedDefaultData: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            guildRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: GuildPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on member "Lan (Leader)"
      await tester.tap(find.text('Lan (Leader)'));
      await tester.pumpAndSettle();

      expect(find.text('Nhắc nhở giữ streak'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(MemberActionSheet),
          matching: find.text('12 ngày streak'),
        ),
        findsOneWidget,
      );
      expect(find.text('850 XP tuần'), findsOneWidget);
    });
  });
}
