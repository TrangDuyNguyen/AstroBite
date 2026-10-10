import 'dart:math';
import '../../domain/models/guild.dart';
import '../../domain/models/guild_member.dart';
import '../../domain/models/planetary_challenge.dart';

/// Seed data generator and helper builders for [MockGuildRepository].
class GuildMockSeeds {
  const GuildMockSeeds._();

  static String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  static void validateGuildName(String name) {
    final trimmed = name.trim();
    if (trimmed.length < 3 || trimmed.length > 30) {
      throw ArgumentError('Tên bang hội phải từ 3 đến 30 ký tự');
    }
  }

  static GuildMember buildNewMember({
    required String userId,
    required String displayName,
    required DateTime now,
    String role = 'member',
    int xp = 0,
  }) {
    return GuildMember(
      userId: userId,
      displayName: displayName,
      role: role,
      weeklyContributionXp: xp,
      currentStreak: 1,
      lastLoggedAt: now,
      joinedAt: now,
    );
  }

  static PlanetaryChallenge buildInitialChallenge({
    required String avatarPlanet,
    required DateTime now,
  }) {
    return PlanetaryChallenge(
      id: 'challenge_${now.millisecondsSinceEpoch}',
      planetTheme: avatarPlanet,
      title: 'Khám Phá Hành Tinh: 50,000 Kcal Lành Mạnh',
      targetValue: 50000,
      currentValue: 50,
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      status: 'active',
    );
  }

  static Guild buildDefaultGuild() {
    final now = DateTime.now();
    final defaultMembers = [
      GuildMember(
        userId: 'user_001',
        displayName: 'Lan (Leader)',
        role: 'leader',
        weeklyContributionXp: 850,
        currentStreak: 12,
        lastLoggedAt: now.subtract(const Duration(hours: 2)),
        joinedAt: now.subtract(const Duration(days: 14)),
      ),
      GuildMember(
        userId: 'current_user',
        displayName: 'Bạn (Me)',
        role: 'member',
        weeklyContributionXp: 600,
        currentStreak: 7,
        lastLoggedAt: now.subtract(const Duration(hours: 4)),
        joinedAt: now.subtract(const Duration(days: 10)),
      ),
      GuildMember(
        userId: 'user_003',
        displayName: 'Hoàng Dev',
        role: 'member',
        weeklyContributionXp: 450,
        currentStreak: 5,
        lastLoggedAt: now.subtract(const Duration(hours: 1)),
        joinedAt: now.subtract(const Duration(days: 8)),
      ),
      GuildMember(
        userId: 'user_004',
        displayName: 'Minh Tuấn',
        role: 'member',
        weeklyContributionXp: 300,
        currentStreak: 3,
        lastLoggedAt: now.subtract(const Duration(days: 1)),
        joinedAt: now.subtract(const Duration(days: 5)),
      ),
      GuildMember(
        userId: 'user_005',
        displayName: 'Hải Yến',
        role: 'member',
        weeklyContributionXp: 150,
        currentStreak: 2,
        lastLoggedAt: now.subtract(const Duration(hours: 18)),
        joinedAt: now.subtract(const Duration(days: 3)),
      ),
    ];

    final challenge = PlanetaryChallenge(
      id: 'challenge_sprint_21',
      planetTheme: 'mars',
      title: 'Chiến Dịch Sao Hỏa: 50,000 Kcal Lành Mạnh',
      targetMetric: 'clean_calories',
      targetValue: 50000,
      currentValue: 34500,
      startDate: now.subtract(const Duration(days: 3)),
      endDate: now.add(const Duration(days: 4)),
      status: 'active',
    );

    return Guild(
      id: 'guild_mars_explorers',
      name: 'Vệ Binh Sao Hỏa',
      description: 'Cùng nhau giảm cân, tích cực ăn sạch và không bỏ bữa!',
      avatarPlanet: 'mars',
      inviteCode: 'MARS01',
      ownerId: 'user_001',
      memberCount: defaultMembers.length,
      memberIds: defaultMembers.map((m) => m.userId).toList(),
      totalStarlightXp: 2350,
      activeChallenge: challenge,
      members: defaultMembers,
      createdAt: now.subtract(const Duration(days: 14)),
    );
  }
}
