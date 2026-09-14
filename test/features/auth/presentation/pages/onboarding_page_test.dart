import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/presentation/pages/onboarding_page.dart';

void main() {
  group('OnboardingPage Widget Tests', () {
    testWidgets('renders Step 1 (Gender selection) initially', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bước 1 / 5'), findsOneWidget);
      expect(find.text('Giới tính sinh học của bạn?'), findsOneWidget);
      expect(find.text('Nam'), findsOneWidget);
      expect(find.text('Nữ'), findsOneWidget);
      expect(find.text('Tiếp tục'), findsOneWidget);
    });

    testWidgets('navigates to Step 2 when tapping Tiếp tục', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();

      expect(find.text('Bước 2 / 5'), findsOneWidget);
      expect(find.text('Năm sinh & Chiều cao'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('can navigate back from Step 2 to Step 1', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Forward to Step 2
      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();
      expect(find.text('Bước 2 / 5'), findsOneWidget);

      // Back to Step 1
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();
      expect(find.text('Bước 1 / 5'), findsOneWidget);
    });
  });
}
