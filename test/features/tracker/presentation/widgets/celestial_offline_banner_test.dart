import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/widgets/celestial_offline_banner.dart';
import 'package:astrobite/features/tracker/presentation/widgets/sync_status_badge.dart';

void main() {
  group('CelestialOfflineBanner & SyncStatusBadge Tests', () {
    testWidgets('banner is hidden when isOfflineProvider is false', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineProvider.overrideWith((ref) => false),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CelestialOfflineBanner(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Chế độ ngoại tuyến'), findsNothing);
    });

    testWidgets('banner is displayed when isOfflineProvider is true', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOfflineProvider.overrideWith((ref) => true),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CelestialOfflineBanner(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Chế độ ngoại tuyến'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.sync), findsOneWidget);
    });

    testWidgets('SyncStatusBadge renders pending, failed, and hides on synced', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SyncStatusBadge(syncStatus: 'pending_sync'),
                SyncStatusBadge(syncStatus: 'failed'),
                SyncStatusBadge(syncStatus: 'synced'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.cloud_done_rounded), findsNothing); // Hidden when synced
    });
  });
}
