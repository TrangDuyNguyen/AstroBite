/// Single water consumption entry
class WaterEntry {
  const WaterEntry({
    required this.id,
    required this.timestamp,
    required this.amountMl,
    this.note,
  });

  final String id;
  final DateTime timestamp;
  final int amountMl;
  final String? note;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'amountMl': amountMl,
        if (note != null) 'note': note,
      };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
        id: json['id'] as String? ?? '',
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
        amountMl: (json['amountMl'] as num?)?.toInt() ?? 0,
        note: json['note'] as String?,
      );
}

/// Daily aggregated water intake log
class WaterDayLog {
  const WaterDayLog({
    required this.id,
    required this.date,
    required this.currentMl,
    required this.targetMl,
    required this.entries,
    required this.updatedAt,
  });

  final String id;
  final String date;
  final int currentMl;
  final int targetMl;
  final List<WaterEntry> entries;
  final DateTime updatedAt;

  double get progress => targetMl > 0 ? (currentMl / targetMl).clamp(0.0, 3.0) : 0.0;
  int get progressPercent => (progress * 100).round();
  bool get isGoalReached => currentMl >= targetMl && targetMl > 0;
  int get remainingMl => (targetMl - currentMl).clamp(0, targetMl);

  WaterDayLog addIntake(int amount, {DateTime? timestamp, String? note}) {
    final now = timestamp ?? DateTime.now();
    final newEntry = WaterEntry(
      id: '${now.millisecondsSinceEpoch}',
      timestamp: now,
      amountMl: amount,
      note: note,
    );
    return WaterDayLog(
      id: id,
      date: date,
      currentMl: currentMl + amount,
      targetMl: targetMl,
      entries: [...entries, newEntry],
      updatedAt: now,
    );
  }

  factory WaterDayLog.initial({required String date, int targetMl = 2000}) {
    return WaterDayLog(
      id: date.replaceAll('-', ''),
      date: date,
      currentMl: 0,
      targetMl: targetMl,
      entries: const [],
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'currentMl': currentMl,
        'targetMl': targetMl,
        'entries': entries.map((e) => e.toJson()).toList(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory WaterDayLog.fromJson(Map<String, dynamic> json) => WaterDayLog(
        id: json['id'] as String? ?? '',
        date: json['date'] as String? ?? '',
        currentMl: (json['currentMl'] as num?)?.toInt() ?? 0,
        targetMl: (json['targetMl'] as num?)?.toInt() ?? 2000,
        entries: (json['entries'] as List<dynamic>?)
                ?.map((e) => WaterEntry.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : DateTime.now(),
      );
}
