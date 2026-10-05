import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/social/data/repositories/social_repository.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';

/// Provider cung cấp SocialRepository
final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  final repo = SocialRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// StreamProvider lắng nghe bảng xếp hạng thời gian thực
final leaderboardStreamProvider = StreamProvider<List<LeaderboardEntry>>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.watchLeaderboard();
});

/// State cho thao tác Social (kết bạn, nhắc nhở)
class SocialActionState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SocialActionState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  SocialActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return SocialActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

/// Controller quản lý tương tác kết bạn và nhắc nhở Streak
class SocialController extends StateNotifier<SocialActionState> {
  final SocialRepository _repository;

  SocialController(this._repository) : super(const SocialActionState());

  Future<bool> addFriend(String astroId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await _repository.addFriend(astroId);
      final cleanId = astroId.trim().toUpperCase();
      final formattedId = cleanId.startsWith('#') ? cleanId : '#$cleanId';
      state = state.copyWith(
        isLoading: false,
        successMessage: '🎉 Đã kết bạn thành công với $formattedId!',
      );
      return true;
    } catch (e) {
      final msg = e is ArgumentError
          ? e.message.toString()
          : (e is StateError ? e.message : 'Không thể kết bạn. Vui lòng thử lại.');
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    }
  }

  Future<bool> nudgeFriend(String astroId, String friendName) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await _repository.nudgeFriend(astroId);
      state = state.copyWith(
        isLoading: false,
        successMessage: '🚨 Đã gửi tín hiệu cứu Streak tới Phi hành gia $friendName!',
      );
      return true;
    } catch (e) {
      final msg = e is ArgumentError
          ? e.message.toString()
          : (e is StateError ? e.message : 'Không thể gửi nhắc nhở lúc này.');
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

final socialControllerProvider =
    StateNotifierProvider<SocialController, SocialActionState>((ref) {
  final repo = ref.watch(socialRepositoryProvider);
  return SocialController(repo);
});
