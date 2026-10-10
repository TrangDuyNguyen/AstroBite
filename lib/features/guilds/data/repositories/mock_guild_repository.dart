import 'dart:async';
import '../../domain/models/guild.dart';
import '../../domain/models/planetary_challenge.dart';
import '../../domain/repositories/guild_repository.dart';
import 'guild_mock_seeds.dart';

class MockGuildRepository implements GuildRepository {
  final Map<String, Guild> _guilds = {};
  final StreamController<Guild?> _guildStreamController =
      StreamController<Guild?>.broadcast();

  MockGuildRepository({bool seedDefaultData = true}) {
    if (seedDefaultData) {
      final guild = GuildMockSeeds.buildDefaultGuild();
      _guilds[guild.id] = guild;
    }
  }

  @override
  Future<Guild?> getUserGuild(String userId) async {
    for (final guild in _guilds.values) {
      if (guild.memberIds.contains(userId)) return guild;
    }
    return null;
  }

  @override
  Stream<Guild?> watchUserGuild(String userId) {
    Future.microtask(() async {
      final guild = await getUserGuild(userId);
      _guildStreamController.add(guild);
    });
    return _guildStreamController.stream;
  }

  @override
  Future<Guild> createGuild({
    required String name,
    required String description,
    required String avatarPlanet,
    required String ownerId,
    required String ownerDisplayName,
  }) async {
    GuildMockSeeds.validateGuildName(name);

    final existing = await getUserGuild(ownerId);
    if (existing != null) {
      await leaveGuild(guildId: existing.id, userId: ownerId);
    }

    final code = GuildMockSeeds.generateInviteCode();
    final now = DateTime.now();
    final leader = GuildMockSeeds.buildNewMember(
      userId: ownerId,
      displayName: ownerDisplayName,
      now: now,
      role: 'leader',
      xp: 50,
    );

    final challenge = GuildMockSeeds.buildInitialChallenge(
      avatarPlanet: avatarPlanet,
      now: now,
    );

    final newGuild = Guild(
      id: 'guild_${now.millisecondsSinceEpoch}',
      name: name.trim(),
      description: description.trim(),
      avatarPlanet: avatarPlanet,
      inviteCode: code,
      ownerId: ownerId,
      memberCount: 1,
      memberIds: [ownerId],
      totalStarlightXp: 50,
      activeChallenge: challenge,
      members: [leader],
      createdAt: now,
    );

    _guilds[newGuild.id] = newGuild;
    _guildStreamController.add(newGuild);
    return newGuild;
  }

  @override
  Future<Guild> joinGuildByCode({
    required String inviteCode,
    required String userId,
    required String userDisplayName,
  }) async {
    final cleanCode = inviteCode.trim().toUpperCase();
    if (cleanCode.length != 6) {
      throw ArgumentError('Mã mời phải gồm đúng 6 ký tự');
    }

    Guild? targetGuild;
    for (final guild in _guilds.values) {
      if (guild.inviteCode == cleanCode) {
        targetGuild = guild;
        break;
      }
    }

    if (targetGuild == null) {
      throw ArgumentError('Không tìm thấy Bang hội với mã mời này');
    }
    if (targetGuild.isFull) {
      throw StateError('Bang hội đã đạt tối đa 20 thành viên');
    }
    if (targetGuild.memberIds.contains(userId)) return targetGuild;

    final now = DateTime.now();
    final newMember = GuildMockSeeds.buildNewMember(
      userId: userId,
      displayName: userDisplayName,
      now: now,
    );

    final updatedMembers = [...targetGuild.members, newMember];
    final updatedGuild = targetGuild.copyWith(
      memberCount: updatedMembers.length,
      memberIds: [...targetGuild.memberIds, userId],
      members: updatedMembers,
    );

    _guilds[updatedGuild.id] = updatedGuild;
    _guildStreamController.add(updatedGuild);
    return updatedGuild;
  }

  @override
  Future<void> leaveGuild({
    required String guildId,
    required String userId,
  }) async {
    final guild = _guilds[guildId];
    if (guild == null) return;

    final updatedMembers = guild.members.where((m) => m.userId != userId).toList();
    final updatedIds = guild.memberIds.where((id) => id != userId).toList();

    if (updatedMembers.isEmpty) {
      _guilds.remove(guildId);
      _guildStreamController.add(null);
    } else {
      final updatedGuild = guild.copyWith(
        memberCount: updatedMembers.length,
        memberIds: updatedIds,
        members: updatedMembers,
      );
      _guilds[guildId] = updatedGuild;
      _guildStreamController.add(null);
    }
  }

  @override
  Future<void> addStarlightContribution({
    required String guildId,
    required String userId,
    int xp = 50,
  }) async {
    final guild = _guilds[guildId];
    if (guild == null) return;

    final updatedMembers = guild.members.map((m) {
      if (m.userId == userId) {
        return m.copyWith(
          weeklyContributionXp: m.weeklyContributionXp + xp,
          lastLoggedAt: DateTime.now(),
        );
      }
      return m;
    }).toList();

    PlanetaryChallenge? updatedChallenge = guild.activeChallenge;
    if (updatedChallenge != null) {
      final newCurrent = updatedChallenge.currentValue + xp;
      updatedChallenge = updatedChallenge.copyWith(
        currentValue: newCurrent,
        status: newCurrent >= updatedChallenge.targetValue ? 'completed' : 'active',
      );
    }

    final updatedGuild = guild.copyWith(
      totalStarlightXp: guild.totalStarlightXp + xp,
      members: updatedMembers,
      activeChallenge: updatedChallenge,
    );

    _guilds[guildId] = updatedGuild;
    _guildStreamController.add(updatedGuild);
  }

  @override
  Future<void> sendNudge({
    required String guildId,
    required String senderId,
    required String targetUserId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<Guild> updateGuildInfo({
    required String guildId,
    required String actorId,
    required String name,
    required String description,
    required String avatarPlanet,
  }) async {
    final guild = _guilds[guildId];
    if (guild == null) throw ArgumentError('Không tìm thấy bang hội');
    if (!guild.canEditGuild(actorId)) {
      throw StateError('Chỉ Trưởng Bang hoặc Phó Bang mới có quyền chỉnh sửa thông tin');
    }
    GuildMockSeeds.validateGuildName(name);

    final updated = guild.copyWith(
      name: name.trim(),
      description: description.trim(),
      avatarPlanet: avatarPlanet,
    );
    _guilds[guildId] = updated;
    _guildStreamController.add(updated);
    return updated;
  }

  @override
  Future<void> disbandGuild({
    required String guildId,
    required String actorId,
  }) async {
    final guild = _guilds[guildId];
    if (guild == null) return;
    if (!guild.canDisbandGuild(actorId)) {
      throw StateError('Chỉ Trưởng Bang mới có quyền giải tán bang hội');
    }

    _guilds.remove(guildId);
    _guildStreamController.add(null);
  }

  @override
  Future<void> kickMember({
    required String guildId,
    required String actorId,
    required String targetUserId,
  }) async {
    final guild = _guilds[guildId];
    if (guild == null) return;
    if (!guild.canKick(actorId, targetUserId)) {
      throw StateError('Bạn không có quyền trục xuất thành viên này');
    }

    final updatedMembers =
        guild.members.where((m) => m.userId != targetUserId).toList();
    final updatedIds =
        guild.memberIds.where((id) => id != targetUserId).toList();

    final updated = guild.copyWith(
      memberCount: updatedMembers.length,
      memberIds: updatedIds,
      members: updatedMembers,
    );
    _guilds[guildId] = updated;
    _guildStreamController.add(updated);
  }

  @override
  Future<void> updateMemberRole({
    required String guildId,
    required String actorId,
    required String targetUserId,
    required String newRole,
  }) async {
    final guild = _guilds[guildId];
    if (guild == null) return;
    if (!guild.canPromoteOrDemote(actorId)) {
      throw StateError('Chỉ Trưởng Bang mới có quyền bổ nhiệm chức vụ');
    }

    final updatedMembers = guild.members.map((m) {
      if (m.userId == targetUserId) {
        return m.copyWith(role: newRole);
      }
      return m;
    }).toList();

    final updated = guild.copyWith(members: updatedMembers);
    _guilds[guildId] = updated;
    _guildStreamController.add(updated);
  }

  @override
  Future<void> transferLeadership({
    required String guildId,
    required String currentLeaderId,
    required String newLeaderId,
  }) async {
    final guild = _guilds[guildId];
    if (guild == null) return;
    if (!guild.canTransferLeadership(currentLeaderId)) {
      throw StateError('Chỉ Trưởng Bang đương nhiệm mới có quyền kế thừa bang hội');
    }

    final newLeaderMember = guild.findMember(newLeaderId);
    if (newLeaderMember == null) {
      throw ArgumentError('Thành viên kế nhiệm không thuộc bang hội này');
    }

    final updatedMembers = guild.members.map((m) {
      if (m.userId == newLeaderId) {
        return m.copyWith(role: 'leader');
      } else if (m.userId == currentLeaderId) {
        return m.copyWith(role: 'elder');
      }
      return m;
    }).toList();

    final updated = guild.copyWith(
      ownerId: newLeaderId,
      members: updatedMembers,
    );
    _guilds[guildId] = updated;
    _guildStreamController.add(updated);
  }

  void dispose() {
    _guildStreamController.close();
  }
}
