import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/guilds/data/datasources/guild_remote_datasource.dart';
import 'package:astrobite/features/guilds/data/repositories/guild_repository_impl.dart';
import 'package:astrobite/features/guilds/domain/models/guild.dart';

class FakeGuildRemoteDatasource implements GuildRemoteDatasource {
  final Map<String, Guild> guilds = {};
  final StreamController<Guild?> streamController = StreamController<Guild?>.broadcast();
  final List<Map<String, dynamic>> sentNudges = [];

  @override
  Future<Guild?> getUserGuild(String userId) async {
    for (final guild in guilds.values) {
      if (guild.memberIds.contains(userId)) return guild;
    }
    return null;
  }

  @override
  Stream<Guild?> watchUserGuild(String userId) {
    return streamController.stream;
  }

  @override
  Future<Guild?> findGuildByInviteCode(String inviteCode) async {
    for (final guild in guilds.values) {
      if (guild.inviteCode == inviteCode.trim().toUpperCase()) return guild;
    }
    return null;
  }

  @override
  Future<void> saveGuild(Guild guild) async {
    guilds[guild.id] = guild;
    streamController.add(guild);
  }

  @override
  Future<void> deleteGuild(String guildId) async {
    guilds.remove(guildId);
    streamController.add(null);
  }

  @override
  Future<void> sendGuildNudge({
    required String guildId,
    required String senderId,
    required String targetUserId,
  }) async {
    sentNudges.add({
      'guildId': guildId,
      'senderId': senderId,
      'targetUserId': targetUserId,
    });
  }

  void dispose() {
    streamController.close();
  }
}

void main() {
  group('GuildRepositoryImpl Tests (ASTRO-022 Real Backend)', () {
    late FakeGuildRemoteDatasource fakeRemote;
    late GuildRepositoryImpl repository;

    setUp(() {
      fakeRemote = FakeGuildRemoteDatasource();
      repository = GuildRepositoryImpl(remoteDatasource: fakeRemote);
    });

    tearDown(() {
      fakeRemote.dispose();
    });

    test('createGuild enforces name validation and saves new guild with leader', () async {
      expect(
        () => repository.createGuild(
          name: 'ab',
          description: 'Too short',
          avatarPlanet: 'mars',
          ownerId: 'owner_1',
          ownerDisplayName: 'Leader One',
        ),
        throwsA(isA<ArgumentError>()),
      );

      final guild = await repository.createGuild(
        name: 'Vệ Binh Mặt Trời',
        description: 'Khám phá vũ trụ',
        avatarPlanet: 'jupiter',
        ownerId: 'owner_1',
        ownerDisplayName: 'Leader One',
      );

      expect(guild.name, equals('Vệ Binh Mặt Trời'));
      expect(guild.ownerId, equals('owner_1'));
      expect(guild.inviteCode.length, equals(6));
      expect(guild.members.first.role, equals('leader'));
      expect(fakeRemote.guilds.containsKey(guild.id), isTrue);
    });

    test('joinGuildByCode validates invite code and adds member', () async {
      final created = await repository.createGuild(
        name: 'Chiến Binh Sao Kim',
        description: 'Venus squad',
        avatarPlanet: 'venus',
        ownerId: 'leader_1',
        ownerDisplayName: 'Venus Leader',
      );

      expect(
        () => repository.joinGuildByCode(
          inviteCode: '123',
          userId: 'user_2',
          userDisplayName: 'Cadet Two',
        ),
        throwsA(isA<ArgumentError>()),
      );

      final joined = await repository.joinGuildByCode(
        inviteCode: created.inviteCode,
        userId: 'user_2',
        userDisplayName: 'Cadet Two',
      );

      expect(joined.memberCount, equals(2));
      expect(joined.memberIds.contains('user_2'), isTrue);
      expect(joined.members.any((m) => m.userId == 'user_2'), isTrue);
    });

    test('addStarlightContribution increments member XP and challenge progress', () async {
      final created = await repository.createGuild(
        name: 'Vệ Binh Sao Hỏa',
        description: 'Mars squad',
        avatarPlanet: 'mars',
        ownerId: 'leader_1',
        ownerDisplayName: 'Leader',
      );

      await repository.addStarlightContribution(
        guildId: created.id,
        userId: 'leader_1',
        xp: 100,
      );

      final updated = await repository.getUserGuild('leader_1');
      expect(updated, isNotNull);
      expect(updated!.totalStarlightXp, equals(150)); // 50 initial + 100
      expect(updated.members.first.weeklyContributionXp, equals(150));
      expect(updated.activeChallenge?.currentValue, equals(150));
    });

    test('sendNudge records nudge event in remote datasource', () async {
      await repository.sendNudge(
        guildId: 'guild_100',
        senderId: 'user_me',
        targetUserId: 'user_friend',
      );

      expect(fakeRemote.sentNudges.length, equals(1));
      expect(fakeRemote.sentNudges.first['targetUserId'], equals('user_friend'));
    });

    test('updateGuildInfo checks permissions and updates metadata', () async {
      final created = await repository.createGuild(
        name: 'Cụm Tinh Cầu Alpha',
        description: 'Old desc',
        avatarPlanet: 'saturn',
        ownerId: 'leader_1',
        ownerDisplayName: 'Leader 1',
      );

      expect(
        () => repository.updateGuildInfo(
          guildId: created.id,
          actorId: 'stranger_9',
          name: 'New Name',
          description: 'New desc',
          avatarPlanet: 'saturn',
        ),
        throwsA(isA<ArgumentError>()),
      );

      final updated = await repository.updateGuildInfo(
        guildId: created.id,
        actorId: 'leader_1',
        name: 'Cụm Tinh Cầu Beta',
        description: 'New desc',
        avatarPlanet: 'saturn',
      );

      expect(updated.name, equals('Cụm Tinh Cầu Beta'));
    });

    test('transferLeadership promotes successor to leader and current to elder', () async {
      final created = await repository.createGuild(
        name: 'Thiên Hà Xanh',
        description: 'Galaxy',
        avatarPlanet: 'neptune',
        ownerId: 'leader_1',
        ownerDisplayName: 'Old Leader',
      );

      await repository.joinGuildByCode(
        inviteCode: created.inviteCode,
        userId: 'cadet_2',
        userDisplayName: 'New Leader',
      );

      await repository.transferLeadership(
        guildId: created.id,
        currentLeaderId: 'leader_1',
        newLeaderId: 'cadet_2',
      );

      final afterTransfer = await repository.getUserGuild('cadet_2');
      expect(afterTransfer!.ownerId, equals('cadet_2'));
      expect(afterTransfer.findMember('cadet_2')?.role, equals('leader'));
      expect(afterTransfer.findMember('leader_1')?.role, equals('elder'));
    });

    test('disbandGuild deletes guild completely from remote', () async {
      final created = await repository.createGuild(
        name: 'Bang Giải Tán',
        description: 'To disband',
        avatarPlanet: 'mars',
        ownerId: 'leader_1',
        ownerDisplayName: 'Leader',
      );

      await repository.disbandGuild(guildId: created.id, actorId: 'leader_1');
      final guild = await repository.getUserGuild('leader_1');
      expect(guild, isNull);
    });
  });
}
