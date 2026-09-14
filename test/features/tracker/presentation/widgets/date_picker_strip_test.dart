import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/widgets/date_picker_strip.dart';

void main() {
  group('DatePickerStrip Widget Tests', () {
    testWidgets('renders 7 days and updates selectedDateProvider on tap', (tester) async {
      late WidgetRef capturedRef;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  capturedRef = ref;
                  return const DatePickerStrip();
                },
              ),
            ),
          ),
        ),
      );

      // Verify 7 day items rendered
      final dayFinder = find.byType(InkWell);
      expect(dayFinder, findsNWidgets(7));

      // Today's day number should be visible
      final today = DateTime.now();
      expect(find.text('${today.day}'), findsWidgets);

      // Tap the first day item (6 days ago)
      await tester.tap(dayFinder.first);
      await tester.pumpAndSettle();

      // Verify selectedDateProvider is updated
      final selected = capturedRef.read(selectedDateProvider);
      final expectedFirstDay = today.subtract(const Duration(days: 6));
      expect(selected.day, expectedFirstDay.day);
      expect(selected.month, expectedFirstDay.month);
      expect(selected.year, expectedFirstDay.year);
    });
  });
}
