import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../domain/scanner_providers.dart';
import '../../domain/usecases/scan_food_usecase.dart';

final scannerControllerProvider =
    StateNotifierProvider.autoDispose<ScannerController, AsyncValue<ScanFoodResult?>>((ref) {
  return ScannerController(ref);
});

class ScannerController extends StateNotifier<AsyncValue<ScanFoodResult?>> {
  ScannerController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<ScanFoodResult?> scanImage(Uint8List bytes) async {
    final user = _ref.read(authRepositoryProvider).currentUser;
    if (user == null) return null;

    state = const AsyncLoading();
    final useCase = _ref.read(scanFoodUseCaseProvider);

    try {
      final result = await useCase.execute(
        userId: user.uid,
        imageBytes: bytes,
      );
      _ref.invalidate(todayScanCountProvider);
      state = AsyncData(result);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      return ScanError(e.toString());
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
