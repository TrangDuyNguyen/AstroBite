import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';
import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import 'package:astrobite/features/gamification/presentation/widgets/cosmic_streak_badge.dart';
import 'package:astrobite/features/gamification/presentation/widgets/streak_detail_sheet.dart';

void main() {
  testWidgets('CosmicStreakBadge renders streak count and opens detail sheet on tap', (tester) async {
    final streak = StreakRecord(
      currentStreak: 5,
      longestStreak: 7,
      starlightShields: 1,
      lastActiveDate: '2026-09-19',
      unlockedBadgeIds: const ['starlight_novice'],
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          streakNotifierProvider.overrideWith(() => _FakeStreakNotifier(streak)),
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: const [CosmicStreakBadge()],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify badge content
    expect(find.text('5'), findsOneWidget);
    expect(find.text('🔥'), findsOneWidget);
    expect(find.byIcon(Icons.shield_moon_rounded), findsOneWidget);

    // Tap to open sheet
    await tester.tap(find.byType(CosmicStreakBadge));
    await tester.pumpAndSettle();

    // Verify sheet opened
    expect(find.byType(StreakDetailSheet), findsOneWidget);
    expect(find.text('Tiểu Vũ Trụ Dinh Dưỡng'), findsOneWidget);
    expect(find.text('Chuỗi Hiện Tại'), findsOneWidget);
    expect(find.text('Huy Hiệu Vũ Trụ'), findsOneWidget);
  });
}

class _FakeStreakNotifier extends StreakNotifier {
  _FakeStreakNotifier(this._record);
  final StreakRecord _record;

  @override
  Future<StreakRecord> build() async => _record;
}
