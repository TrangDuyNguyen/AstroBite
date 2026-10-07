import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_guild_repository.dart';
import '../../domain/models/guild.dart';
import '../../domain/repositories/guild_repository.dart';

final guildRepositoryProvider = Provider<GuildRepository>((ref) {
  final repo = MockGuildRepository();
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});

final currentUserIdProvider = Provider<String>((ref) {
  return 'current_user';
});

final currentUserGuildStreamProvider = StreamProvider<Guild?>((ref) {
  final repo = ref.watch(guildRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return repo.watchUserGuild(userId);
});

class GuildUiState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const GuildUiState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  GuildUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return GuildUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class GuildController extends StateNotifier<GuildUiState> {
  final GuildRepository _repository;
  final String _currentUserId;

  GuildController(this._repository, this._currentUserId)
      : super(const GuildUiState());

  Future<bool> createGuild({
    required String name,
    required String description,
    required String avatarPlanet,
    String ownerDisplayName = 'Bạn (Leader)',
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.createGuild(
        name: name,
        description: description,
        avatarPlanet: avatarPlanet,
        ownerId: _currentUserId,
        ownerDisplayName: ownerDisplayName,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Tạo Bang Hội thành công!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ArgumentError: ', '').replaceAll('StateError: ', ''),
      );
      return false;
    }
  }

  Future<bool> joinGuild(String inviteCode, {String userDisplayName = 'Bạn'}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final guild = await _repository.joinGuildByCode(
        inviteCode: inviteCode,
        userId: _currentUserId,
        userDisplayName: userDisplayName,
      );
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Gia nhập bang hội ${guild.name} thành công!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ArgumentError: ', '').replaceAll('StateError: ', ''),
      );
      return false;
    }
  }

  Future<void> logMealContribution({int xp = 50}) async {
    final guild = await _repository.getUserGuild(_currentUserId);
    if (guild == null) return;
    await _repository.addStarlightContribution(
      guildId: guild.id,
      userId: _currentUserId,
      xp: xp,
    );
  }

  Future<void> sendNudge(String targetUserId) async {
    final guild = await _repository.getUserGuild(_currentUserId);
    if (guild == null) return;
    await _repository.sendNudge(
      guildId: guild.id,
      senderId: _currentUserId,
      targetUserId: targetUserId,
    );
    state = state.copyWith(
      successMessage: 'Đã gửi lời nhắc giữ Streak tới đồng đội!',
    );
  }

  Future<void> leaveGuild() async {
    final guild = await _repository.getUserGuild(_currentUserId);
    if (guild == null) return;
    await _repository.leaveGuild(guildId: guild.id, userId: _currentUserId);
    state = state.copyWith(successMessage: 'Đã rời bang hội');
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

final guildControllerProvider =
    StateNotifierProvider<GuildController, GuildUiState>((ref) {
  final repo = ref.watch(guildRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return GuildController(repo, userId);
});
