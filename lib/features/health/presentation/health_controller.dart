import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../data/health_repository.dart';
import '../domain/health_activity.dart';

part 'health_controller.g.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository();
});

@riverpod
class HealthConnectionController extends _$HealthConnectionController {
  @override
  FutureOr<bool> build() async {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return false;
    return ref.read(healthRepositoryProvider).isConnected(user.uid);
  }

  Future<bool> connect() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return false;

    final repo = ref.read(healthRepositoryProvider);

    // Request permissions from OS
    final granted = await repo.requestPermissions();
    if (!granted) return false;

    // Update Firestore
    await repo.setConnected(user.uid, true);
    state = const AsyncData(true);
    return true;
  }

  Future<void> disconnect() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    await ref.read(healthRepositoryProvider).setConnected(user.uid, false);
    state = const AsyncData(false);
  }
}

@riverpod
class HealthActivityController extends _$HealthActivityController {
  @override
  FutureOr<HealthActivity?> build() async {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return null;

    final repo = ref.read(healthRepositoryProvider);
    final connected = await repo.isConnected(user.uid);
    if (!connected) return null;

    return repo.getTodayActivity();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(healthRepositoryProvider).getTodayActivity();
    });
  }
}

@riverpod
class HealthWriteController extends _$HealthWriteController {
  @override
  FutureOr<bool> build() async {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return false;
    return ref.read(healthRepositoryProvider).isWriteEnabled(user.uid);
  }

  Future<void> toggle() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final current = state.valueOrNull ?? false;
    final newValue = !current;
    await ref.read(healthRepositoryProvider).setWriteEnabled(user.uid, newValue);
    state = AsyncData(newValue);
  }
}
