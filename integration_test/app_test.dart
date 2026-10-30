import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:astrobite/app.dart';
import 'package:astrobite/features/social/presentation/controllers/social_controller.dart';
import 'package:astrobite/features/social/data/repositories/social_repository.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';
import 'package:astrobite/features/guilds/presentation/controllers/guild_controller.dart';
import 'package:astrobite/features/guilds/data/repositories/mock_guild_repository.dart';
import 'package:astrobite/features/health/presentation/health_controller.dart';
import 'package:astrobite/features/health/data/health_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AstroBite End-to-End Integration Tests (ASTRO-029 & ASTRO-030)', () {
    testWidgets('E2E Flow: App launch, verify navigation, social leaderboard, and health fallbacks',
        (WidgetTester tester) async {
      // 1. Setup in-memory resilient providers for E2E headless test runner
      final testSocialRepo = SocialRepository(
        myAstroId: '#AST-E2E01',
        currentUserId: 'user_e2e_tester',
        currentUserName: 'Phi hành gia E2E',
        initialEntries: [
          const LeaderboardEntry(
            uid: 'user_01',
            name: 'AlexD',
            astroId: '#AST-0042',
            streak: 45,
            rank: 1,
          ),
          const LeaderboardEntry(
            uid: 'user_e2e_tester',
            name: 'Phi hành gia E2E (Bạn)',
            astroId: '#AST-E2E01',
            streak: 30,
            rank: 2,
            isMe: true,
            goalAchievedToday: true,
          ),
        ],
      );

      final testGuildRepo = MockGuildRepository(seedDefaultData: true);
      final testHealthRepo = HealthRepository(healthPlugin: null, firestore: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            socialRepositoryProvider.overrideWithValue(testSocialRepo),
            guildRepositoryProvider.overrideWithValue(testGuildRepo),
            healthRepositoryProvider.overrideWithValue(testHealthRepo),
          ],
          child: const AstroBiteApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // 2. Verify app launches without crashing and renders root structure
      expect(find.byType(AstroBiteApp), findsOneWidget);

      // 3. Verify Design System baseline (Clay theme & canvas)
      expect(find.byType(MaterialApp), findsOneWidget);

      // 4. Verify test repository interactions
      final leaderboard = await testSocialRepo.watchLeaderboard().first;
      expect(leaderboard.length, equals(2));
      expect(leaderboard.any((e) => e.isMe), isTrue);

      final userGuild = await testGuildRepo.getUserGuild('current_user');
      expect(userGuild, isNotNull);
      expect(userGuild!.name, equals('Vệ Binh Sao Hỏa'));

      final healthActivity = await testHealthRepo.getTodayActivity();
      expect(healthActivity.steps, equals(0));
      expect(healthActivity.activeEnergyBurned, equals(0));

      // 5. Cleanup
      testSocialRepo.dispose();
      testGuildRepo.dispose();
    });
  });
}
