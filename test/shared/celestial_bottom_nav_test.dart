import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
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
      expect(find.text(AppStrings.navToday), findsOneWidget);
      expect(find.text(AppStrings.navCoach), findsOneWidget);
      expect(find.text(AppStrings.navInsights), findsOneWidget);
      expect(find.text(AppStrings.navProfile), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.nightlight_outlined), findsOneWidget);
      expect(find.byIcon(Icons.smart_toy_outlined), findsOneWidget);
      expect(find.byIcon(Icons.photo_camera_rounded), findsOneWidget);
      expect(find.byIcon(Icons.analytics_outlined), findsOneWidget);
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

      await tester.tap(find.text(AppStrings.navCoach));
      await tester.pumpAndSettle();

      expect(mockRouter.activeIndex, equals(1));

      await tester.tap(find.text(AppStrings.navInsights));
      await tester.pumpAndSettle();

      expect(mockRouter.activeIndex, equals(2));

      await tester.tap(find.text(AppStrings.navProfile));
      await tester.pumpAndSettle();

      expect(mockRouter.activeIndex, equals(3));
    });

    testWidgets('renders BackdropFilter for glassmorphic dock and camera FAB', (tester) async {
      final mockRouter = MockTabsRouter(initialIndex: 0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CelestialBottomNav(tabsRouter: mockRouter),
          ),
        ),
      );

      // Verify BackdropFilter glassmorphism exists
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Verify Camera FAB has inkwell & scanFood semantics
      expect(find.byIcon(Icons.photo_camera_rounded), findsOneWidget);
      expect(find.bySemanticsLabel(AppStrings.scanFood), findsOneWidget);
    });
  });
}
