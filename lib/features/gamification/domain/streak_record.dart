import 'dart:math';

/// Celestial milestone badge definition.
class CosmicBadge {
  const CosmicBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredDays,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredDays;

  static const starlightNovice = CosmicBadge(
    id: 'starlight_novice',
    title: 'Tân Binh Tinh Tú',
    description: 'Thắp sáng tiểu vũ trụ với chuỗi 3 ngày ăn sạch liên tiếp.',
    icon: '✨',
    requiredDays: 3,
  );

  static const pulsarPioneer = CosmicBadge(
    id: 'pulsar_pioneer',
    title: 'Thám Hiểm Pulsar',
    description: 'Duy trì nhịp xung năng lượng bền bỉ trong 7 ngày liên tiếp.',
    icon: '🪐',
    requiredDays: 7,
  );

  static const supernovaTitan = CosmicBadge(
    id: 'supernova_titan',
    title: 'Chiến Thần Siêu Tân Tinh',
    description: 'Bùng nổ chuyển hóa dinh dưỡng đỉnh cao suốt 30 ngày kỷ luật.',
    icon: '🌟',
    requiredDays: 30,
  );

  static const proteinHunter = CosmicBadge(
    id: 'protein_hunter',
    title: 'Thợ Săn Đạm Vũ Trụ',
    description: 'Nạp đủ 100% mục tiêu Protein chuẩn liên tiếp.',
    icon: '⚡',
    requiredDays: 5,
  );

  static const List<CosmicBadge> allBadges = [
    starlightNovice,
    pulsarPioneer,
    proteinHunter,
    supernovaTitan,
  ];
}

/// Domain entity representing a user's clean-eating streak and gamification state.
class StreakRecord {
  const StreakRecord({
    required this.currentStreak,
    required this.longestStreak,
    this.lastActiveDate,
    this.starlightShields = 1,
    this.activeDates = const [],
    this.unlockedBadgeIds = const [],
    required this.updatedAt,
    this.lastShieldConsumed = false,
  });

  final int currentStreak;
  final int longestStreak;
  final String? lastActiveDate;
  final int starlightShields;
  final List<String> activeDates;
  final List<String> unlockedBadgeIds;
  final DateTime updatedAt;
  final bool lastShieldConsumed;

  bool get hasActiveStreak => currentStreak > 0;
  bool get hasShield => starlightShields > 0;

  /// Formats a DateTime to standardized yyyy-MM-dd format.
  static String formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Calculates day difference between two yyyy-MM-dd strings.
  static int _daysBetween(String date1, String date2) {
    final d1 = DateTime.parse(date1);
    final d2 = DateTime.parse(date2);
    final diff = d2.difference(d1).inHours / 24.0;
    return diff.round();
  }

  /// Evaluates and produces a new [StreakRecord] upon logging a meal on [logDateStr].
  StreakRecord recordMeal(String logDateStr) {
    final newActiveDates = Set<String>.from(activeDates)..add(logDateStr);
    final sortedDates = newActiveDates.toList()..sort();

    // Case 1: First log ever
    if (lastActiveDate == null) {
      final newBadges = List<String>.from(unlockedBadgeIds);
      return copyWith(
        currentStreak: 1,
        longestStreak: max(longestStreak, 1),
        lastActiveDate: logDateStr,
        activeDates: sortedDates,
        unlockedBadgeIds: newBadges,
        updatedAt: DateTime.now(),
        lastShieldConsumed: false,
      );
    }

    // Case 2: Same day log -> no streak count increase
    final gap = _daysBetween(lastActiveDate!, logDateStr);
    if (gap <= 0) {
      return copyWith(
        activeDates: sortedDates,
        updatedAt: DateTime.now(),
        lastShieldConsumed: false,
      );
    }

    int nextStreak = currentStreak;
    int nextShields = starlightShields;
    bool shieldUsed = false;

    if (gap == 1) {
      // Consecutive day: natural increment
      nextStreak += 1;
    } else if (gap == 2 && starlightShields > 0) {
      // Missed 1 day, but saved by Starlight Shield!
      nextShields -= 1;
      nextStreak += 1;
      shieldUsed = true;
    } else {
      // Streak broken
      nextStreak = 1;
    }

    // Award bonus shield on 7-day milestones (capped at 2)
    if (nextStreak > 0 && nextStreak % 7 == 0 && nextStreak > currentStreak) {
      nextShields = min(2, nextShields + 1);
    }

    // Check badge unlocks
    final updatedBadgeIds = List<String>.from(unlockedBadgeIds);
    if (nextStreak >= 3 && !updatedBadgeIds.contains(CosmicBadge.starlightNovice.id)) {
      updatedBadgeIds.add(CosmicBadge.starlightNovice.id);
    }
    if (nextStreak >= 7 && !updatedBadgeIds.contains(CosmicBadge.pulsarPioneer.id)) {
      updatedBadgeIds.add(CosmicBadge.pulsarPioneer.id);
    }
    if (nextStreak >= 30 && !updatedBadgeIds.contains(CosmicBadge.supernovaTitan.id)) {
      updatedBadgeIds.add(CosmicBadge.supernovaTitan.id);
    }

    return copyWith(
      currentStreak: nextStreak,
      longestStreak: max(longestStreak, nextStreak),
      lastActiveDate: logDateStr,
      starlightShields: nextShields,
      activeDates: sortedDates,
      unlockedBadgeIds: updatedBadgeIds,
      updatedAt: DateTime.now(),
      lastShieldConsumed: shieldUsed,
    );
  }

  StreakRecord copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastActiveDate,
    int? starlightShields,
    List<String>? activeDates,
    List<String>? unlockedBadgeIds,
    DateTime? updatedAt,
    bool? lastShieldConsumed,
  }) {
    return StreakRecord(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      starlightShields: starlightShields ?? this.starlightShields,
      activeDates: activeDates ?? this.activeDates,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      updatedAt: updatedAt ?? this.updatedAt,
      lastShieldConsumed: lastShieldConsumed ?? this.lastShieldConsumed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActiveDate': lastActiveDate,
      'starlightShields': starlightShields,
      'activeDates': activeDates,
      'unlockedBadgeIds': unlockedBadgeIds,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory StreakRecord.fromMap(Map<String, dynamic> map) {
    return StreakRecord(
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (map['longestStreak'] as num?)?.toInt() ?? 0,
      lastActiveDate: map['lastActiveDate'] as String?,
      starlightShields: (map['starlightShields'] as num?)?.toInt() ?? 1,
      activeDates: (map['activeDates'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      unlockedBadgeIds: (map['unlockedBadgeIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  factory StreakRecord.initial() {
    return StreakRecord(
      currentStreak: 0,
      longestStreak: 0,
      starlightShields: 1,
      activeDates: const [],
      unlockedBadgeIds: const [],
      updatedAt: DateTime.now(),
    );
  }
}
