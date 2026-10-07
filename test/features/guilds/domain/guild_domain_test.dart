import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/guilds/domain/models/guild.dart';
import 'package:astrobite/features/guilds/domain/models/guild_member.dart';
import 'package:astrobite/features/guilds/domain/models/planetary_challenge.dart';

void main() {
  group('Guild Domain Models Tests (Gate 4 & Gate 6)', () {
    test('PlanetaryChallenge calculates progressPercentage correctly', () {
      final challenge = PlanetaryChallenge(
        id: 'c1',
        planetTheme: 'mars',
        title: 'Sao Hỏa 50,000 XP',
        targetValue: 50000,
        currentValue: 25000,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
      );

      expect(challenge.progressPercentage, equals(0.5));
      expect(challenge.isCompleted, isFalse);

      final completedChallenge = challenge.copyWith(currentValue: 50000);
      expect(completedChallenge.progressPercentage, equals(1.0));
      expect(completedChallenge.isCompleted, isTrue);
    });

    test('PlanetaryChallenge JSON serialization works both ways', () {
      final challenge = PlanetaryChallenge(
        id: 'c1',
        planetTheme: 'venus',
        title: 'Chiến Dịch Sao Kim',
        targetValue: 30000,
        currentValue: 15000,
        startDate: DateTime.parse('2026-10-07T00:00:00.000Z'),
        endDate: DateTime.parse('2026-10-14T00:00:00.000Z'),
      );

      final json = challenge.toJson();
      final fromJson = PlanetaryChallenge.fromJson(json);

      expect(fromJson.id, equals('c1'));
      expect(fromJson.planetTheme, equals('venus'));
      expect(fromJson.title, equals('Chiến Dịch Sao Kim'));
      expect(fromJson.targetValue, equals(30000));
      expect(fromJson.currentValue, equals(15000));
    });

    test('GuildMember recognizes leader role and serializes correctly', () {
      final leader = GuildMember(
        userId: 'u1',
        displayName: 'Lan Leader',
        role: 'leader',
        weeklyContributionXp: 500,
        currentStreak: 10,
        lastLoggedAt: DateTime.now(),
        joinedAt: DateTime.now(),
      );

      expect(leader.isLeader, isTrue);

      final member = leader.copyWith(role: 'member');
      expect(member.isLeader, isFalse);

      final json = leader.toJson();
      final fromJson = GuildMember.fromJson(json);
      expect(fromJson.displayName, equals('Lan Leader'));
      expect(fromJson.role, equals('leader'));
      expect(fromJson.weeklyContributionXp, equals(500));
    });

    test('Guild detects isFull when memberCount >= 20', () {
      final guild = Guild(
        id: 'g1',
        name: 'Vệ Binh Sao Hỏa',
        description: 'Ăn sạch sống khỏe',
        inviteCode: 'MARS01',
        ownerId: 'u1',
        memberCount: 20,
        memberIds: List.generate(20, (i) => 'u$i'),
        createdAt: DateTime.now(),
      );

      expect(guild.isFull, isTrue);

      final notFullGuild = guild.copyWith(memberCount: 19);
      expect(notFullGuild.isFull, isFalse);
    });
  });
}
