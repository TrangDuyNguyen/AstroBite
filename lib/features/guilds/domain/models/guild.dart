import 'package:flutter/foundation.dart';
import 'guild_member.dart';
import 'planetary_challenge.dart';

@immutable
class Guild {
  final String id;
  final String name;
  final String description;
  final String avatarPlanet; // 'mars', 'venus', 'jupiter', 'saturn', 'neptune'
  final String inviteCode;
  final String ownerId;
  final int memberCount;
  final List<String> memberIds;
  final int totalStarlightXp;
  final PlanetaryChallenge? activeChallenge;
  final List<GuildMember> members;
  final DateTime createdAt;

  const Guild({
    required this.id,
    required this.name,
    required this.description,
    this.avatarPlanet = 'mars',
    required this.inviteCode,
    required this.ownerId,
    required this.memberCount,
    required this.memberIds,
    this.totalStarlightXp = 0,
    this.activeChallenge,
    this.members = const [],
    required this.createdAt,
  });

  bool get isFull => memberCount >= 20;

  GuildMember? findMember(String userId) {
    try {
      return members.firstWhere((m) => m.userId == userId);
    } catch (_) {
      return null;
    }
  }

  Guild copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarPlanet,
    String? inviteCode,
    String? ownerId,
    int? memberCount,
    List<String>? memberIds,
    int? totalStarlightXp,
    PlanetaryChallenge? activeChallenge,
    List<GuildMember>? members,
    DateTime? createdAt,
  }) {
    return Guild(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarPlanet: avatarPlanet ?? this.avatarPlanet,
      inviteCode: inviteCode ?? this.inviteCode,
      ownerId: ownerId ?? this.ownerId,
      memberCount: memberCount ?? this.memberCount,
      memberIds: memberIds ?? this.memberIds,
      totalStarlightXp: totalStarlightXp ?? this.totalStarlightXp,
      activeChallenge: activeChallenge ?? this.activeChallenge,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'avatar_planet': avatarPlanet,
    'invite_code': inviteCode,
    'owner_id': ownerId,
    'member_count': memberCount,
    'member_ids': memberIds,
    'total_starlight_xp': totalStarlightXp,
    'active_challenge': activeChallenge?.toJson(),
    'members': members.map((m) => m.toJson()).toList(),
    'created_at': createdAt.toIso8601String(),
  };

  factory Guild.fromJson(Map<String, dynamic> json) {
    return Guild(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      avatarPlanet: json['avatar_planet'] as String? ?? 'mars',
      inviteCode: json['invite_code'] as String,
      ownerId: json['owner_id'] as String,
      memberCount: json['member_count'] as int? ?? 1,
      memberIds: (json['member_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      totalStarlightXp: json['total_starlight_xp'] as int? ?? 0,
      activeChallenge: json['active_challenge'] != null
          ? PlanetaryChallenge.fromJson(
              json['active_challenge'] as Map<String, dynamic>)
          : null,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => GuildMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}
