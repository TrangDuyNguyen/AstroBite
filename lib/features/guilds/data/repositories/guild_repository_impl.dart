import 'dart:async';
import '../../domain/models/guild.dart';
import '../../domain/models/planetary_challenge.dart';
import '../../domain/repositories/guild_repository.dart';
import '../datasources/guild_remote_datasource.dart';
import 'guild_mock_seeds.dart';

/// Triển khai thực tế của GuildRepository sử dụng Firestore — ASTRO-022
class GuildRepositoryImpl implements GuildRepository {
  final GuildRemoteDatasource _remoteDatasource;

  GuildRepositoryImpl({required GuildRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Guild?> getUserGuild(String userId) async {
    try {
      return await _remoteDatasource.getUserGuild(userId);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<Guild?> watchUserGuild(String userId) async* {
    try {
      await for (final guild in _remoteDatasource.watchUserGuild(userId)) {
        yield guild;
      }
    } catch (_) {
      yield null;
    }
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

    await _remoteDatasource.saveGuild(newGuild);
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

    final targetGuild = await _remoteDatasource.findGuildByInviteCode(cleanCode);
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

    await _remoteDatasource.saveGuild(updatedGuild);
    return updatedGuild;
  }

  @override
  Future<void> leaveGuild({
    required String guildId,
    required String userId,
  }) async {
    final guild = await _remoteDatasource.getUserGuild(userId);
    if (guild == null || guild.id != guildId) return;

    final updatedMembers = guild.members.where((m) => m.userId != userId).toList();
    final updatedIds = guild.memberIds.where((id) => id != userId).toList();

    if (updatedMembers.isEmpty) {
      await _remoteDatasource.deleteGuild(guildId);
    } else {
      final updatedGuild = guild.copyWith(
        memberCount: updatedMembers.length,
        memberIds: updatedIds,
        members: updatedMembers,
      );
      await _remoteDatasource.saveGuild(updatedGuild);
    }
  }

  @override
  Future<void> addStarlightContribution({
    required String guildId,
    required String userId,
    int xp = 50,
  }) async {
    final guild = await _remoteDatasource.getUserGuild(userId);
    if (guild == null || guild.id != guildId) return;

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

    await _remoteDatasource.saveGuild(updatedGuild);
  }

  @override
  Future<void> sendNudge({
    required String guildId,
    required String senderId,
    required String targetUserId,
  }) async {
    await _remoteDatasource.sendGuildNudge(
      guildId: guildId,
      senderId: senderId,
      targetUserId: targetUserId,
    );
  }

  @override
  Future<Guild> updateGuildInfo({
    required String guildId,
    required String actorId,
    required String name,
    required String description,
    required String avatarPlanet,
  }) async {
    final guild = await _remoteDatasource.getUserGuild(actorId);
    if (guild == null || guild.id != guildId) {
      throw ArgumentError('Không tìm thấy bang hội');
    }
    if (!guild.canEditGuild(actorId)) {
      throw StateError('Chỉ Trưởng Bang hoặc Phó Bang mới có quyền chỉnh sửa thông tin');
    }
    GuildMockSeeds.validateGuildName(name);

    final updated = guild.copyWith(
      name: name.trim(),
      description: description.trim(),
      avatarPlanet: avatarPlanet,
    );
    await _remoteDatasource.saveGuild(updated);
    return updated;
  }

  @override
  Future<void> disbandGuild({
    required String guildId,
    required String actorId,
  }) async {
    final guild = await _remoteDatasource.getUserGuild(actorId);
    if (guild == null || guild.id != guildId) return;
    if (!guild.canDisbandGuild(actorId)) {
      throw StateError('Chỉ Trưởng Bang mới có quyền giải tán bang hội');
    }

    await _remoteDatasource.deleteGuild(guildId);
  }

  @override
  Future<void> kickMember({
    required String guildId,
    required String actorId,
    required String targetUserId,
  }) async {
    final guild = await _remoteDatasource.getUserGuild(actorId);
    if (guild == null || guild.id != guildId) return;
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
    await _remoteDatasource.saveGuild(updated);
  }

  @override
  Future<void> updateMemberRole({
    required String guildId,
    required String actorId,
    required String targetUserId,
    required String newRole,
  }) async {
    final guild = await _remoteDatasource.getUserGuild(actorId);
    if (guild == null || guild.id != guildId) return;
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
    await _remoteDatasource.saveGuild(updated);
  }

  @override
  Future<void> transferLeadership({
    required String guildId,
    required String currentLeaderId,
    required String newLeaderId,
  }) async {
    final guild = await _remoteDatasource.getUserGuild(currentLeaderId);
    if (guild == null || guild.id != guildId) return;
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
    await _remoteDatasource.saveGuild(updated);
  }
}

