import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/services/network_sync_coordinator.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';

class _FakeConnectivity implements Connectivity {
  final _controller = StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> current = [ConnectivityResult.wifi];

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => current;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _controller.stream;

  void emit(List<ConnectivityResult> results) {
    current = results;
    _controller.add(results);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeConnectivity fakeConnectivity;
  late NetworkSyncCoordinator coordinator;

  setUp(() {
    fakeConnectivity = _FakeConnectivity();
    container = ProviderContainer();
    coordinator = NetworkSyncCoordinator(
      ref: container.read(Provider((ref) => ref)),
      connectivity: fakeConnectivity,
    );
  });

  tearDown(() {
    coordinator.dispose();
    fakeConnectivity.dispose();
    container.dispose();
  });

  group('NetworkSyncCoordinator Tests (ASTRO-013)', () {
    test('initializes with online state when wifi is present', () async {
      fakeConnectivity.current = [ConnectivityResult.wifi];
      await coordinator.initialize();

      expect(container.read(isOfflineProvider), isFalse);
    });

    test('updates isOfflineProvider to true when connectivity becomes none', () async {
      await coordinator.initialize();

      fakeConnectivity.emit([ConnectivityResult.none]);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(isOfflineProvider), isTrue);
    });

    test('recovers from offline to online and updates isOfflineProvider to false', () async {
      await coordinator.initialize();

      // Go offline
      fakeConnectivity.emit([ConnectivityResult.none]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(isOfflineProvider), isTrue);

      // Reconnect online
      fakeConnectivity.emit([ConnectivityResult.mobile]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(isOfflineProvider), isFalse);
    });
  });
}

