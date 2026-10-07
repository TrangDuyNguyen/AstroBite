import 'dart:async';
import 'dart:math';
import '../../domain/models/guild.dart';
import '../../domain/models/guild_member.dart';
import '../../domain/models/planetary_challenge.dart';
import '../../domain/repositories/guild_repository.dart';

class MockGuildRepository implements GuildRepository {
  final Map<String, Guild> _guilds = {};
  final StreamController<Guild?> _guildStreamController =
      StreamController<Guild?>.broadcast();

  MockGuildRepository({bool seedDefaultData = true}) {
    if (seedDefaultData) {
      _seedDefaultGuild();
    }
  }

  void _seedDefaultGuild() {
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

    final guild = Guild(
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

    _guilds[guild.id] = guild;
  }

  @override
  Future<Guild?> getUserGuild(String userId) async {
    for (final guild in _guilds.values) {
      if (guild.memberIds.contains(userId)) {
        return guild;
      }
    }
    return null;
  }

  @override
  Stream<Guild?> watchUserGuild(String userId) {
    // Emit initial
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
    final trimmedName = name.trim();
    if (trimmedName.length < 3 || trimmedName.length > 30) {
      throw ArgumentError('Tên bang hội phải từ 3 đến 30 ký tự');
    }

    // If user is already in a guild, leave previous guild to create new one
    final existing = await getUserGuild(ownerId);
    if (existing != null) {
      await leaveGuild(guildId: existing.id, userId: ownerId);
    }

    final code = _generateInviteCode();
    final now = DateTime.now();
    final leader = GuildMember(
      userId: ownerId,
      displayName: ownerDisplayName,
      role: 'leader',
      weeklyContributionXp: 50,
      currentStreak: 1,
      lastLoggedAt: now,
      joinedAt: now,
    );

    final challenge = PlanetaryChallenge(
      id: 'challenge_${DateTime.now().millisecondsSinceEpoch}',
      planetTheme: avatarPlanet,
      title: 'Khám Phá Hành Tinh: 50,000 Kcal Lành Mạnh',
      targetValue: 50000,
      currentValue: 50,
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      status: 'active',
    );

    final newGuild = Guild(
      id: 'guild_${DateTime.now().millisecondsSinceEpoch}',
      name: trimmedName,
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

    if (targetGuild.memberIds.contains(userId)) {
      return targetGuild;
    }

    final now = DateTime.now();
    final newMember = GuildMember(
      userId: userId,
      displayName: userDisplayName,
      role: 'member',
      weeklyContributionXp: 0,
      currentStreak: 1,
      lastLoggedAt: now,
      joinedAt: now,
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
    // Simulate nudge action
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
    if (guild == null) {
      throw ArgumentError('Không tìm thấy bang hội');
    }
    if (!guild.canEditGuild(actorId)) {
      throw StateError('Chỉ Trưởng Bang hoặc Phó Bang mới có quyền chỉnh sửa thông tin');
    }
    final trimmedName = name.trim();
    if (trimmedName.length < 3 || trimmedName.length > 30) {
      throw ArgumentError('Tên bang hội phải từ 3 đến 30 ký tự');
    }

    final updated = guild.copyWith(
      name: trimmedName,
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
        return m.copyWith(role: 'elder'); // Cựu thủ lĩnh lùi về làm Phó Bang / Trưởng lão
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

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void dispose() {
    _guildStreamController.close();
  }
}
