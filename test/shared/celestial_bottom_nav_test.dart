import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/shared/widgets/celestial_bottom_nav.dart';

class MockTabsRouter extends ChangeNotifier implements TabsRouter {
  MockTabsRouter({int initialIndex = 0}) : _activeIndex = initialIndex;

  int _activeIndex = 0;

  @override
  int get activeIndex => _activeIndex;

  @override
  void setActiveIndex(int index, {bool notify = true}) {
    _activeIndex = index;
    if (notify) notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('CelestialBottomNav Widget Tests', () {
    testWidgets('renders all 4 tabs and center Camera FAB', (tester) async {
      final mockRouter = MockTabsRouter(initialIndex: 0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CelestialBottomNav(tabsRouter: mockRouter),
          ),
        ),
      );

      // Verify labels
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('AstroCoach'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
      expect(find.byIcon(Icons.smart_toy_outlined), findsOneWidget);
      expect(find.byIcon(Icons.photo_camera_rounded), findsOneWidget);
      expect(find.byIcon(Icons.insights_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
    });

    testWidgets('tapping tab updates activeIndex on tabsRouter', (tester) async {
      final mockRouter = MockTabsRouter(initialIndex: 0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CelestialBottomNav(tabsRouter: mockRouter),
          ),
        ),
      );

      await tester.tap(find.text('AstroCoach'));
      await tester.pumpAndSettle();

      expect(mockRouter.activeIndex, equals(1));

      await tester.tap(find.text('Insights'));
      await tester.pumpAndSettle();

      expect(mockRouter.activeIndex, equals(2));

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(mockRouter.activeIndex, equals(3));
    });
  });
}
