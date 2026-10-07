import 'package:flutter/foundation.dart';

@immutable
class GuildMember {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String role; // 'leader', 'elder', 'member'
  final int weeklyContributionXp;
  final int currentStreak;
  final DateTime lastLoggedAt;
  final DateTime joinedAt;

  const GuildMember({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.role = 'member',
    this.weeklyContributionXp = 0,
    this.currentStreak = 0,
    required this.lastLoggedAt,
    required this.joinedAt,
  });

  bool get isLeader => role == 'leader';

  GuildMember copyWith({
    String? userId,
    String? displayName,
    String? avatarUrl,
    String? role,
    int? weeklyContributionXp,
    int? currentStreak,
    DateTime? lastLoggedAt,
    DateTime? joinedAt,
  }) {
    return GuildMember(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      weeklyContributionXp: weeklyContributionXp ?? this.weeklyContributionXp,
      currentStreak: currentStreak ?? this.currentStreak,
      lastLoggedAt: lastLoggedAt ?? this.lastLoggedAt,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'display_name': displayName,
    'avatar_url': avatarUrl,
    'role': role,
    'weekly_contribution_xp': weeklyContributionXp,
    'current_streak': currentStreak,
    'last_logged_at': lastLoggedAt.toIso8601String(),
    'joined_at': joinedAt.toIso8601String(),
  };

  factory GuildMember.fromJson(Map<String, dynamic> json) {
    return GuildMember(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'member',
      weeklyContributionXp: json['weekly_contribution_xp'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      lastLoggedAt: json['last_logged_at'] != null
          ? DateTime.parse(json['last_logged_at'] as String)
          : DateTime.now(),
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : DateTime.now(),
    );
  }
}
