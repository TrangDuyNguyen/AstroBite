import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/services/push_notification_service.dart';

void main() {
  group('PushNotificationService Tests (ASTRO-021)', () {
    test('instantiates safely without throwing when Firebase is not initialized', () {
      final service = PushNotificationService();
      expect(service, isNotNull);
      service.dispose();
    });

    test('initialize returns null safely when messaging instance is absent', () async {
      final service = PushNotificationService(
        messaging: null,
        firestore: null,
      );

      final token = await service.initialize(userId: 'test_user');
      expect(token, isNull);
      service.dispose();
    });

    test('syncTokenToFirestore handles empty inputs without crashing', () async {
      final service = PushNotificationService(
        messaging: null,
        firestore: null,
      );

      // Should not throw
      await service.syncTokenToFirestore(userId: '', token: '');
      await service.syncTokenToFirestore(userId: 'uid', token: 'token');
      service.dispose();
    });
  });
}

