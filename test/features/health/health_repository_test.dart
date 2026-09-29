import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/health/data/health_repository.dart';

void main() {
  group('HealthRepository Tests (RSK-007 & RSK-008 Mitigation)', () {
    late HealthRepository repository;

    setUp(() {
      repository = HealthRepository();
    });

    test('platformName reflects current OS appropriately', () {
      final name = repository.platformName;
      if (Platform.isIOS) {
        expect(name, equals('Apple Health'));
      } else if (Platform.isAndroid) {
        expect(name, equals('Health Connect'));
      } else {
        expect(name, equals('Health'));
      }
    });

    test('isAvailable returns safely without throwing exceptions on any platform', () async {
      final available = await repository.isAvailable();
      expect(available, isA<bool>());
    });

    test('requestPermissions and hasPermissions degrade gracefully without native plugin crashes', () async {
      // RSK-007: App must not crash when native permissions are requested or missing
      final granted = await repository.requestPermissions();
      expect(granted, isFalse);

      final hasPerm = await repository.hasPermissions();
      expect(hasPerm, isFalse);
    });

    test('getTodayActivity returns safe fallback object when unlinked or offline', () async {
      // RSK-007: Graceful degradation with zeroed data instead of throwing or hanging
      final activity = await repository.getTodayActivity();
      expect(activity.steps, equals(0));
      expect(activity.activeEnergyBurned, equals(0));
      expect(activity.workouts, isEmpty);
      expect(activity.totalWorkoutCalories, equals(0));
    });

    test('writeDietaryEnergy returns false gracefully without throwing unhandled exceptions', () async {
      // RSK-008: Abstract wrapper catches/avoids unsupported write attempts
      final success = await repository.writeDietaryEnergy(450.0, DateTime.now());
      expect(success, isFalse);
    });
  });
}
