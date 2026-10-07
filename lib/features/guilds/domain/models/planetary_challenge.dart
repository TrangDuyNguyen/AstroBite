import 'package:flutter/foundation.dart';

@immutable
class PlanetaryChallenge {
  final String id;
  final String planetTheme; // 'mars', 'venus', 'jupiter', 'saturn', 'neptune'
  final String title;
  final String targetMetric; // 'clean_calories', 'logged_meals', 'streak_days'
  final int targetValue;
  final int currentValue;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'completed', 'expired'

  const PlanetaryChallenge({
    required this.id,
    required this.planetTheme,
    required this.title,
    this.targetMetric = 'clean_calories',
    required this.targetValue,
    this.currentValue = 0,
    required this.startDate,
    required this.endDate,
    this.status = 'active',
  });

  double get progressPercentage {
    if (targetValue <= 0) return 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  bool get isCompleted => status == 'completed' || currentValue >= targetValue;

  PlanetaryChallenge copyWith({
    String? id,
    String? planetTheme,
    String? title,
    String? targetMetric,
    int? targetValue,
    int? currentValue,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    return PlanetaryChallenge(
      id: id ?? this.id,
      planetTheme: planetTheme ?? this.planetTheme,
      title: title ?? this.title,
      targetMetric: targetMetric ?? this.targetMetric,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'planet_theme': planetTheme,
    'title': title,
    'target_metric': targetMetric,
    'target_value': targetValue,
    'current_value': currentValue,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'status': status,
  };

  factory PlanetaryChallenge.fromJson(Map<String, dynamic> json) {
    return PlanetaryChallenge(
      id: json['id'] as String,
      planetTheme: json['planet_theme'] as String? ?? 'mars',
      title: json['title'] as String,
      targetMetric: json['target_metric'] as String? ?? 'clean_calories',
      targetValue: json['target_value'] as int? ?? 50000,
      currentValue: json['current_value'] as int? ?? 0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : DateTime.now().add(const Duration(days: 7)),
      status: json['status'] as String? ?? 'active',
    );
  }
}
