import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrobite/features/tracker/data/repositories/water_repository_impl.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/controllers/water_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late WaterRepositoryImpl fakeRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fakeRepo = WaterRepositoryImpl();

    container = ProviderContainer(
      overrides: [
        waterRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('WaterController Tests', () {
    test('initial controller state is AsyncData(null)', () {
      final state = container.read(waterControllerProvider);
      expect(state.value, isNull);
      expect(state.isLoading, isFalse);
    });

    test('addWater logs intake and updates controller state', () async {
      final controller = container.read(waterControllerProvider.notifier);

      await controller.addWater(250, note: 'Morning water');

      final state = container.read(waterControllerProvider);
      expect(state.hasValue, isTrue);
      expect(state.value?.currentMl, 250);
      expect(state.value?.entries.length, 1);
      expect(state.value?.entries.first.amountMl, 250);
    });

    test('consecutive addWater calls accumulate intake accurately', () async {
      final controller = container.read(waterControllerProvider.notifier);

      await controller.addWater(250);
      await controller.addWater(500);

      final state = container.read(waterControllerProvider);
      expect(state.value?.currentMl, 750);
      expect(state.value?.entries.length, 2);
    });

    test('setDailyTarget updates daily goal successfully', () async {
      final controller = container.read(waterControllerProvider.notifier);

      await controller.setDailyTarget(2500);

      final today = container.read(todayDateProvider);
      final log = await fakeRepo.getDailyWater(userId: 'guest_user', date: today);
      expect(log.targetMl, 2500);
    });
  });
}
