import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/presentation/widgets/celestial_time_avatar.dart';

void main() {
  group('CelestialTimeAvatar Widget Tests', () {
    testWidgets('renders late night moon at 02:00', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialTimeAvatar(
              time: DateTime(2026, 9, 22, 2, 30),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
    });

    testWidgets('renders dawn twilight at 08:00', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialTimeAvatar(
              time: DateTime(2026, 9, 22, 8, 15),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wb_twilight), findsOneWidget);
    });

    testWidgets('renders daylight sun at 14:00', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialTimeAvatar(
              time: DateTime(2026, 9, 22, 14, 0),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wb_sunny_rounded), findsOneWidget);
    });

    testWidgets('renders twilight transition at 19:00', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialTimeAvatar(
              time: DateTime(2026, 9, 22, 19, 45),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wb_twilight_rounded), findsOneWidget);
    });

    testWidgets('renders starry night moon at 22:00', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialTimeAvatar(
              time: DateTime(2026, 9, 22, 22, 10),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.nights_stay), findsOneWidget);
    });

    testWidgets('triggers onTap callback when avatar is tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CelestialTimeAvatar(
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CelestialTimeAvatar));
      expect(tapped, isTrue);
    });
  });
}
