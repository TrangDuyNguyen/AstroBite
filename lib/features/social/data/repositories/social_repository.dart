import 'dart:async';
import 'package:astrobite/features/social/data/datasources/social_remote_datasource.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';

/// Repository quản lý Bảng Xếp Hạng & Tương Tác Bạn Bè (Social & Leaderboard) — ASTRO-020 & ASTRO-021
class SocialRepository {
  final String myAstroId;
  final String currentUserId;
  final String currentUserName;
  final SocialRemoteDatasource? _remoteDatasource;

  final StreamController<List<LeaderboardEntry>> _controller =
      StreamController<List<LeaderboardEntry>>.broadcast();

  final List<LeaderboardEntry> _entries = [];
  StreamSubscription<List<LeaderboardEntry>>? _remoteSubscription;

  SocialRepository({
    this.myAstroId = '#ASTRO-8821',
    this.currentUserId = 'user_me',
    this.currentUserName = 'TrangNguyen (Bạn)',
    SocialRemoteDatasource? remoteDatasource,
    List<LeaderboardEntry>? initialEntries,
  }) : _remoteDatasource = remoteDatasource {
    if (initialEntries != null && initialEntries.isNotEmpty) {
      _entries.addAll(initialEntries);
      _sortAndEmit();
    } else if (remoteDatasource == null) {
      _seedDefaultData();
      _sortAndEmit();
    } else {
      _initRemote();
    }
  }

  void _initRemote() {
    // Upsert bản thân lên leaderboard Firestore
    final me = LeaderboardEntry(
      uid: currentUserId,
      name: currentUserName,
      astroId: myAstroId,
      streak: 42,
      rank: 1,
      isMe: true,
      goalAchievedToday: true,
    );
    _remoteDatasource?.upsertUserLeaderboardEntry(me).catchError((_) {});

    // Lắng nghe dữ liệu real-time từ Firestore
    _remoteSubscription = _remoteDatasource
        ?.watchLeaderboard(currentUserId)
        .listen((remoteEntries) {
      if (remoteEntries.isNotEmpty) {
        _entries
          ..clear()
          ..addAll(remoteEntries);
        _controller.add(List.unmodifiable(_entries));
      }
    }, onError: (_) {
      if (_entries.isEmpty) {
        _seedDefaultData();
        _sortAndEmit();
      }
    });
  }

  void _seedDefaultData() {
    _entries.addAll([
      const LeaderboardEntry(
        uid: 'user_01',
        name: 'AlexD',
        astroId: '#AST-0042',
        streak: 45,
        rank: 1,
        goalAchievedToday: false,
      ),
      LeaderboardEntry(
        uid: currentUserId,
        name: currentUserName,
        astroId: myAstroId,
        streak: 42,
        rank: 2,
        isMe: true,
        goalAchievedToday: true,
      ),
      const LeaderboardEntry(
        uid: 'user_02',
        name: 'JohnSmith',
        astroId: '#AST-9912',
        streak: 30,
        rank: 3,
        goalAchievedToday: true,
      ),
      const LeaderboardEntry(
        uid: 'user_03',
        name: 'AstroDev',
        astroId: '#AST-3310',
        streak: 12,
        rank: 4,
        goalAchievedToday: false,
      ),
      const LeaderboardEntry(
        uid: 'user_04',
        name: 'LazyPanda',
        astroId: '#AST-1002',
        streak: 5,
        rank: 5,
        goalAchievedToday: false,
      ),
    ]);
  }

  void _sortAndEmit() {
    _entries.sort((a, b) => b.streak.compareTo(a.streak));
    for (int i = 0; i < _entries.length; i++) {
      _entries[i] = _entries[i].copyWith(rank: i + 1);
    }
    _controller.add(List.unmodifiable(_entries));
  }

  /// Lắng nghe bảng xếp hạng cập nhật thời gian thực
  Stream<List<LeaderboardEntry>> watchLeaderboard() async* {
    if (_entries.isNotEmpty) {
      yield List.unmodifiable(_entries);
    }
    yield* _controller.stream;
  }

  /// Thêm bạn bè mới qua mã Astro ID
  Future<void> addFriend(String astroId) async {
    final cleanId = astroId.trim().toUpperCase();
    final formattedId = cleanId.startsWith('#') ? cleanId : '#$cleanId';

    if (cleanId.isEmpty) {
      throw ArgumentError('Mã Astro ID không được để trống.');
    }

    if (formattedId == myAstroId) {
      throw ArgumentError('Bạn không thể tự kết bạn với chính mình.');
    }

    final exists = _entries.any((e) => e.astroId.toUpperCase() == formattedId);
    if (exists) {
      throw StateError('Phi hành gia này đã có trong danh sách bạn bè.');
    }

    if (_remoteDatasource != null) {
      final remoteFriend = await _remoteDatasource!.findUserByAstroId(formattedId);
      final friendToAdd = remoteFriend ??
          LeaderboardEntry(
            uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
            name: 'Phi hành gia $formattedId',
            astroId: formattedId,
            streak: 1,
            rank: _entries.length + 1,
            goalAchievedToday: false,
          );

      await _remoteDatasource!.addFriend(
        currentUserId: currentUserId,
        friendEntry: friendToAdd,
      );
      _entries.add(friendToAdd);
    } else {
      await Future.delayed(const Duration(milliseconds: 150));
      final newFriend = LeaderboardEntry(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Phi hành gia $formattedId',
        astroId: formattedId,
        streak: 1,
        rank: _entries.length + 1,
        goalAchievedToday: false,
      );
      _entries.add(newFriend);
    }

    _sortAndEmit();
  }

  /// Gửi tín hiệu Streak Nudge (Cứu Streak) qua FCM & Firestore
  Future<bool> nudgeFriend(String astroId) async {
    final cleanId = astroId.trim().toUpperCase();
    final formattedId = cleanId.startsWith('#') ? cleanId : '#$cleanId';

    final index = _entries.indexWhere((e) => e.astroId.toUpperCase() == formattedId);
    if (index == -1) {
      throw ArgumentError('Không tìm thấy người bạn này trong danh sách.');
    }

    final target = _entries[index];
    if (target.isMe) {
      throw ArgumentError('Không thể tự nhắc nhở chính mình.');
    }

    if (target.isNudgedToday) {
      throw StateError('Bạn đã gửi nhắc nhở cho người bạn này hôm nay.');
    }

    if (_remoteDatasource != null) {
      final alreadyNudged = await _remoteDatasource!.hasNudgedToday(
        senderId: currentUserId,
        targetUserId: target.uid,
      );
      if (alreadyNudged) {
        throw StateError('Bạn đã gửi nhắc nhở cho người bạn này hôm nay.');
      }

      await _remoteDatasource!.sendNudge(
        senderId: currentUserId,
        senderName: currentUserName,
        senderAstroId: myAstroId,
        targetUserId: target.uid,
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 120));
    }

    _entries[index] = target.copyWith(isNudgedToday: true);
    _sortAndEmit();
    return true;
  }

  void dispose() {
    _remoteSubscription?.cancel();
    _controller.close();
  }
}
