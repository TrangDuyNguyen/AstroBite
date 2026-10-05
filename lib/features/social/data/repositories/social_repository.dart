import 'dart:async';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';

/// Repository quản lý Bảng Xếp Hạng & Tương Tác Bạn Bè (Social & Leaderboard) — Gate 4
class SocialRepository {
  final String myAstroId;
  final StreamController<List<LeaderboardEntry>> _controller =
      StreamController<List<LeaderboardEntry>>.broadcast();

  final List<LeaderboardEntry> _entries = [];

  SocialRepository({
    this.myAstroId = '#ASTRO-8821',
    List<LeaderboardEntry>? initialEntries,
  }) {
    if (initialEntries != null && initialEntries.isNotEmpty) {
      _entries.addAll(initialEntries);
    } else {
      _seedDefaultData();
    }
    _sortAndEmit();
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
        uid: 'user_me',
        name: 'TrangNguyen (Bạn)',
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
    // Sắp xếp giảm dần theo streak
    _entries.sort((a, b) => b.streak.compareTo(a.streak));
    // Gán lại thứ hạng
    for (int i = 0; i < _entries.length; i++) {
      _entries[i] = _entries[i].copyWith(rank: i + 1);
    }
    _controller.add(List.unmodifiable(_entries));
  }

  /// Lắng nghe bảng xếp hạng cập nhật thời gian thực
  Stream<List<LeaderboardEntry>> watchLeaderboard() async* {
    yield List.unmodifiable(_entries);
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

    // Giả lập độ trễ mạng kiểm tra backend < 300ms
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
    _sortAndEmit();
  }

  /// Gửi tín hiệu Streak Nudge (Cứu Streak) qua FCM
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

    // Giả lập gọi Cloud Function gửi FCM < 200ms
    await Future.delayed(const Duration(milliseconds: 120));

    _entries[index] = target.copyWith(isNudgedToday: true);
    _sortAndEmit();
    return true;
  }

  void dispose() {
    _controller.close();
  }
}
