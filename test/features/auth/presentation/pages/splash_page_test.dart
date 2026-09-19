import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/presentation/pages/splash_page.dart';
import 'package:astrobite/shared/widgets/cosmic_logo_badge.dart';
import 'login_page_test.dart';

void main() {
  group('SplashPage Widget Tests', () {
    testWidgets('renders brand elements, cosmic badge, and loading indicator',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
          ],
          child: const MaterialApp(
            home: SplashPage(),
          ),
        ),
      );

      // Advance initial frame
      await tester.pump();

      // Check CosmicLogoBadge and AppName
      expect(find.byType(CosmicLogoBadge), findsOneWidget);
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text('VŨ TRỤ DINH DƯỠNG THÔNG MINH'), findsOneWidget);
      expect(find.text('AI Food Scanner & Macro Tracker'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
