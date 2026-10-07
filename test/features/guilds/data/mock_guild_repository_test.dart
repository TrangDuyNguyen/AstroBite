import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/guilds/data/repositories/mock_guild_repository.dart';

void main() {
  group('MockGuildRepository Tests (BVA & Concurrency)', () {
    late MockGuildRepository repository;

    setUp(() {
      repository = MockGuildRepository(seedDefaultData: true);
    });

    tearDown(() {
      repository.dispose();
    });

    test('getUserGuild finds seeded default guild for current_user', () async {
      final guild = await repository.getUserGuild('current_user');
      expect(guild, isNotNull);
      expect(guild!.name, equals('Vệ Binh Sao Hỏa'));
      expect(guild.inviteCode, equals('MARS01'));
      expect(guild.memberCount, equals(5));
      expect(guild.activeChallenge, isNotNull);
    });

    test('createGuild enforces 3-30 character name boundary validation', () async {
      final emptyRepo = MockGuildRepository(seedDefaultData: false);

      // TC-NAME-02: 2 chars (too short)
      expect(
        () => emptyRepo.createGuild(
          name: 'AB',
          description: 'Desc',
          avatarPlanet: 'mars',
          ownerId: 'new_user',
          ownerDisplayName: 'New User',
        ),
        throwsA(isA<ArgumentError>()),
      );

      // TC-NAME-03: 3 chars (valid min)
      final validGuild = await emptyRepo.createGuild(
        name: 'ABC',
        description: 'Desc',
        avatarPlanet: 'mars',
        ownerId: 'new_user',
        ownerDisplayName: 'New User',
      );
      expect(validGuild.name, equals('ABC'));
      expect(validGuild.inviteCode.length, equals(6));
      expect(validGuild.memberCount, equals(1));
    });

    test('joinGuildByCode enforces 6 character invite code boundary', () async {
      // TC-CODE-02: 5 chars (too short)
      expect(
        () => repository.joinGuildByCode(
          inviteCode: 'MARS1',
          userId: 'stranger',
          userDisplayName: 'Stranger',
        ),
        throwsA(isA<ArgumentError>()),
      );

      // TC-CODE-06: Non-existent code
      expect(
        () => repository.joinGuildByCode(
          inviteCode: 'NOT_EX',
          userId: 'stranger',
          userDisplayName: 'Stranger',
        ),
        throwsA(isA<ArgumentError>()),
      );

      // TC-CODE-03: lowercase auto-uppercase & successful join
      final joined = await repository.joinGuildByCode(
        inviteCode: 'mars01',
        userId: 'stranger',
        userDisplayName: 'Stranger',
      );
      expect(joined.memberCount, equals(6));
      expect(joined.memberIds.contains('stranger'), isTrue);
    });

    test('addStarlightContribution auto increments XP atomically', () async {
      final initialGuild = await repository.getUserGuild('current_user');
      final initialTotal = initialGuild!.totalStarlightXp;
      final initialChallengeCurrent = initialGuild.activeChallenge!.currentValue;

      await repository.addStarlightContribution(
        guildId: initialGuild.id,
        userId: 'current_user',
        xp: 50,
      );

      final updatedGuild = await repository.getUserGuild('current_user');
      expect(updatedGuild!.totalStarlightXp, equals(initialTotal + 50));
      expect(updatedGuild.activeChallenge!.currentValue,
          equals(initialChallengeCurrent + 50));

      final myMember = updatedGuild.findMember('current_user');
      expect(myMember, isNotNull);
      expect(myMember!.weeklyContributionXp, equals(650));
    });

    test('leaveGuild removes member and clears guild for user', () async {
      final initialGuild = await repository.getUserGuild('current_user');
      expect(initialGuild, isNotNull);

      await repository.leaveGuild(
        guildId: initialGuild!.id,
        userId: 'current_user',
      );

      final guildAfterLeave = await repository.getUserGuild('current_user');
      expect(guildAfterLeave, isNull);
    });
  });
}
