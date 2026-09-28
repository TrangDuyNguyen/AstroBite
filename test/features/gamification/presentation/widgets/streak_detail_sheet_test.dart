import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';
import 'package:astrobite/features/gamification/presentation/widgets/streak_detail_sheet.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

void main() {
  group('StreakDetailSheet Widget Tests', () {
    final testStreak = StreakRecord(
      currentStreak: 5,
      longestStreak: 12,
      starlightShields: 1,
      lastActiveDate: '2026-09-28',
      activeDates: const ['2026-09-24', '2026-09-25', '2026-09-26', '2026-09-27', '2026-09-28'],
      unlockedBadgeIds: const ['starlight_novice', 'protein_hunter'],
      updatedAt: DateTime.now(),
    );

    testWidgets('renders all core 3D metrics and celestial headers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakDetailSheet(streak: testStreak),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header and titles
      expect(find.text('Tiểu Vũ Trụ Dinh Dưỡng'), findsOneWidget);
      expect(find.text('Kỷ luật ăn sạch nuôi dưỡng năng lượng sinh học'), findsOneWidget);
      expect(find.text('TIỂU VŨ TRỤ KỶ LUẬT'), findsOneWidget);

      // Check 3 pillars metrics
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Chuỗi Hiện Tại'), findsOneWidget);
      expect(find.byType(Clay3DFlame), findsOneWidget);

      expect(find.text('12'), findsOneWidget);
      expect(find.text('Kỷ Lục Dài Nhất'), findsOneWidget);
      expect(find.byType(Clay3DStar), findsWidgets);

      expect(find.text('1/2'), findsOneWidget);
      expect(find.text('Khiên Tinh Tú'), findsOneWidget);
      expect(find.byType(Clay3DShield), findsWidgets);

      // Check shield banner
      expect(find.text('Khiên Tinh Tú Đang Bật'), findsOneWidget);
      expect(find.text('Khiên Tinh Tú đang bảo vệ chuỗi của bạn nếu lỡ quên log 1 ngày.'), findsOneWidget);
      expect(find.text('Còn 2 ngày chuỗi'), findsOneWidget);

      // Check cosmic badges header and status
      expect(find.text('Huy Hiệu Vũ Trụ'), findsOneWidget);
      expect(find.text('2/4 ĐÃ MỞ'), findsOneWidget);

      // Check unlocked badges
      expect(find.text('Tân Binh Tinh Tú'), findsOneWidget);
      expect(find.text('Thợ Săn Đạm Vũ Trụ'), findsOneWidget);
      expect(find.text('Đã Mở Khóa'), findsNWidgets(2));

      // Check locked badges
      expect(find.text('Thám Hiểm Pulsar'), findsOneWidget);
      expect(find.text('7 ngày chuỗi'), findsOneWidget);
      expect(find.text('Chiến Thần Siêu Tân Tinh'), findsOneWidget);
      expect(find.text('30 ngày chuỗi'), findsOneWidget);

      // Check action button
      expect(find.text('Tiếp Tục Kỷ Luật'), findsOneWidget);
    });

    testWidgets('tapping a badge opens the badge detail dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakDetailSheet(streak: testStreak),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll into view and tap on the unlocked 'Tân Binh Tinh Tú' badge
      await tester.ensureVisible(find.text('Tân Binh Tinh Tú'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tân Binh Tinh Tú'));
      await tester.pumpAndSettle();

      // Verify dialog is shown with badge description
      expect(find.text('ĐÃ ĐẠT ĐƯỢC'), findsOneWidget);
      expect(find.text('Thắp sáng tiểu vũ trụ với chuỗi 3 ngày ăn sạch liên tiếp.'), findsOneWidget);
      expect(find.text('Đã Hiểu'), findsOneWidget);

      // Tap 'Đã Hiểu' to close dialog
      await tester.tap(find.text('Đã Hiểu'));
      await tester.pumpAndSettle();

      expect(find.text('ĐÃ ĐẠT ĐƯỢC'), findsNothing);
    });
  });
}
