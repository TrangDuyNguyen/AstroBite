import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/theme/app_icons.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';
import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import 'package:astrobite/features/gamification/presentation/widgets/cosmic_streak_badge.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/widgets/celestial_time_avatar.dart';
import 'package:astrobite/features/tracker/presentation/widgets/dashboard_app_bar.dart';

void main() {
  group('DashboardAppBar Widget Tests', () {
    testWidgets('renders all visual elements matching Figma screenshot', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeStreak = StreakRecord(
        currentStreak: 2,
        longestStreak: 5,
        starlightShields: 1,
        lastActiveDate: '2026-09-27',
        unlockedBadgeIds: const ['streak_2'],
        updatedAt: DateTime.now(),
      );

      final sundayDate = DateTime(2026, 9, 27); // Chủ Nhật, 27 Th09

      bool profileTapped = false;
      bool recipesTapped = false;
      bool dateTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedDateProvider.overrideWith((ref) => sundayDate),
            streakNotifierProvider.overrideWith(() => _FakeStreakNotifier(fakeStreak)),
          ],
          child: MaterialApp(
            home: Scaffold(
              appBar: DashboardAppBar(
                onProfileTap: () => profileTapped = true,
                onRecipesTap: () => recipesTapped = true,
                onDateTap: () => dateTapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. CelestialTimeAvatar
      expect(find.byType(CelestialTimeAvatar), findsOneWidget);

      // 2. Title "Hôm nay"
      expect(find.text(AppStrings.todayOverview), findsOneWidget);

      // 3. Subtitle "Chủ Nhật, 27 Th09" and dropdown arrow
      expect(find.text('Chủ Nhật, 27 Th09'), findsOneWidget);
      expect(find.byIcon(AppIcons.arrowDown), findsOneWidget);

      // 4. Recipe menu book icon
      expect(find.byIcon(AppIcons.book), findsOneWidget);

      // 5. CosmicStreakBadge with count 2 and shield
      expect(find.byType(CosmicStreakBadge), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('🔥'), findsOneWidget);
      expect(find.byIcon(AppIcons.shield), findsOneWidget);

      // 6. Test callback taps
      await tester.tap(find.byType(CelestialTimeAvatar));
      expect(profileTapped, isTrue);

      await tester.tap(find.byIcon(AppIcons.book));
      expect(recipesTapped, isTrue);

      await tester.tap(find.byIcon(AppIcons.arrowDown));
      expect(dateTapped, isTrue);
    });
  });
}

class _FakeStreakNotifier extends StreakNotifier {
  _FakeStreakNotifier(this._record);
  final StreakRecord _record;

  @override
  Future<StreakRecord> build() async => _record;
}
