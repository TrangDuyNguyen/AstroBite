import '../models/guild.dart';

abstract class GuildRepository {
  Future<Guild?> getUserGuild(String userId);
  Stream<Guild?> watchUserGuild(String userId);
  Future<Guild> createGuild({
    required String name,
    required String description,
    required String avatarPlanet,
    required String ownerId,
    required String ownerDisplayName,
  });
  Future<Guild> joinGuildByCode({
    required String inviteCode,
    required String userId,
    required String userDisplayName,
  });
  Future<void> leaveGuild({
    required String guildId,
    required String userId,
  });
  Future<void> addStarlightContribution({
    required String guildId,
    required String userId,
    int xp = 50,
  });
  Future<void> sendNudge({
    required String guildId,
    required String senderId,
    required String targetUserId,
  });
  Future<Guild> updateGuildInfo({
    required String guildId,
    required String actorId,
    required String name,
    required String description,
    required String avatarPlanet,
  });
  Future<void> disbandGuild({
    required String guildId,
    required String actorId,
  });
  Future<void> kickMember({
    required String guildId,
    required String actorId,
    required String targetUserId,
  });
  Future<void> updateMemberRole({
    required String guildId,
    required String actorId,
    required String targetUserId,
    required String newRole,
  });
  Future<void> transferLeadership({
    required String guildId,
    required String currentLeaderId,
    required String newLeaderId,
  });
}
