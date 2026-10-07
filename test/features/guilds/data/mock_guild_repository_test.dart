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

    test('updateGuildInfo allows leader to edit info, forbids ordinary member', () async {
      final guild = (await repository.getUserGuild('current_user'))!;

      // Ordinary member tries to edit
      expect(
        () => repository.updateGuildInfo(
          guildId: guild.id,
          actorId: 'current_user', // ordinary member
          name: 'Tên Mới',
          description: 'Mô tả mới',
          avatarPlanet: 'jupiter',
        ),
        throwsA(isA<StateError>()),
      );

      // Leader edits successfully
      await repository.updateGuildInfo(
        guildId: guild.id,
        actorId: 'user_001', // leader
        name: 'Vệ Binh Sao Mộc',
        description: 'Mô tả mới toanh',
        avatarPlanet: 'jupiter',
      );

      final updated = (await repository.getUserGuild('current_user'))!;
      expect(updated.name, equals('Vệ Binh Sao Mộc'));
      expect(updated.description, equals('Mô tả mới toanh'));
      expect(updated.avatarPlanet, equals('jupiter'));
    });

    test('updateMemberRole promotes member to elder and demotes back', () async {
      final guild = (await repository.getUserGuild('current_user'))!;

      // Leader promotes current_user to elder
      await repository.updateMemberRole(
        guildId: guild.id,
        actorId: 'user_001',
        targetUserId: 'current_user',
        newRole: 'elder',
      );

      var updated = (await repository.getUserGuild('current_user'))!;
      var myMember = updated.findMember('current_user')!;
      expect(myMember.role, equals('elder'));
      expect(myMember.isElder, isTrue);

      // Leader demotes current_user back to member
      await repository.updateMemberRole(
        guildId: guild.id,
        actorId: 'user_001',
        targetUserId: 'current_user',
        newRole: 'member',
      );

      updated = (await repository.getUserGuild('current_user'))!;
      myMember = updated.findMember('current_user')!;
      expect(myMember.role, equals('member'));
      expect(myMember.isElder, isFalse);
    });

    test('transferLeadership transfers leader role and steps actor down to elder', () async {
      final guild = (await repository.getUserGuild('current_user'))!;

      await repository.transferLeadership(
        guildId: guild.id,
        currentLeaderId: 'user_001',
        newLeaderId: 'current_user',
      );

      final updated = (await repository.getUserGuild('current_user'))!;
      expect(updated.ownerId, equals('current_user'));
      expect(updated.findMember('current_user')!.isLeader, isTrue);
      expect(updated.findMember('user_001')!.isElder, isTrue);
      expect(updated.findMember('user_001')!.isLeader, isFalse);
    });

    test('kickMember removes member with permission checks', () async {
      final guild = (await repository.getUserGuild('current_user'))!;

      // Ordinary member cannot kick
      expect(
        () => repository.kickMember(
          guildId: guild.id,
          actorId: 'current_user',
          targetUserId: 'user_003',
        ),
        throwsA(isA<StateError>()),
      );

      // Leader kicks user_004
      await repository.kickMember(
        guildId: guild.id,
        actorId: 'user_001',
        targetUserId: 'user_004',
      );

      final updated = (await repository.getUserGuild('current_user'))!;
      expect(updated.memberIds.contains('user_004'), isFalse);
      expect(updated.findMember('user_004'), isNull);
      expect(updated.memberCount, equals(4));
    });

    test('disbandGuild deletes guild completely for all members', () async {
      final guild = (await repository.getUserGuild('current_user'))!;

      // Ordinary member cannot disband
      expect(
        () => repository.disbandGuild(
          guildId: guild.id,
          actorId: 'current_user',
        ),
        throwsA(isA<StateError>()),
      );

      // Leader disbands guild
      await repository.disbandGuild(
        guildId: guild.id,
        actorId: 'user_001',
      );

      final guildAfterDisband = await repository.getUserGuild('current_user');
      expect(guildAfterDisband, isNull);
    });
  });
}
