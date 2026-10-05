/// Thực thể Bảng Xếp Hạng Bạn Bè (Leaderboard Entry) — Gate 4
class LeaderboardEntry {
  final String uid;
  final String name;
  final String astroId;
  final int streak;
  final int rank;
  final bool isMe;
  final bool goalAchievedToday;
  final bool isNudgedToday;

  const LeaderboardEntry({
    required this.uid,
    required this.name,
    required this.astroId,
    required this.streak,
    required this.rank,
    this.isMe = false,
    this.goalAchievedToday = false,
    this.isNudgedToday = false,
  });

  LeaderboardEntry copyWith({
    String? uid,
    String? name,
    String? astroId,
    int? streak,
    int? rank,
    bool? isMe,
    bool? goalAchievedToday,
    bool? isNudgedToday,
  }) {
    return LeaderboardEntry(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      astroId: astroId ?? this.astroId,
      streak: streak ?? this.streak,
      rank: rank ?? this.rank,
      isMe: isMe ?? this.isMe,
      goalAchievedToday: goalAchievedToday ?? this.goalAchievedToday,
      isNudgedToday: isNudgedToday ?? this.isNudgedToday,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'astroId': astroId,
      'streak': streak,
      'rank': rank,
      'isMe': isMe,
      'goalAchievedToday': goalAchievedToday,
      'isNudgedToday': isNudgedToday,
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      astroId: map['astroId'] as String? ?? '',
      streak: map['streak'] as int? ?? 0,
      rank: map['rank'] as int? ?? 0,
      isMe: map['isMe'] as bool? ?? false,
      goalAchievedToday: map['goalAchievedToday'] as bool? ?? false,
      isNudgedToday: map['isNudgedToday'] as bool? ?? false,
    );
  }
}
