import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/guild.dart';

abstract class GuildRemoteDatasource {
  Future<Guild?> getUserGuild(String userId);
  Stream<Guild?> watchUserGuild(String userId);
  Future<Guild?> findGuildByInviteCode(String inviteCode);
  Future<void> saveGuild(Guild guild);
  Future<void> deleteGuild(String guildId);
  Future<void> sendGuildNudge({
    required String guildId,
    required String senderId,
    required String targetUserId,
  });
}

class GuildRemoteDatasourceImpl implements GuildRemoteDatasource {
  final FirebaseFirestore _firestore;

  GuildRemoteDatasourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Guild?> getUserGuild(String userId) async {
    final query = await _firestore
        .collection('guilds')
        .where('member_ids', arrayContains: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return Guild.fromJson(query.docs.first.data());
  }

  @override
  Stream<Guild?> watchUserGuild(String userId) {
    return _firestore
        .collection('guilds')
        .where('member_ids', arrayContains: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return Guild.fromJson(snapshot.docs.first.data());
    });
  }

  @override
  Future<Guild?> findGuildByInviteCode(String inviteCode) async {
    final query = await _firestore
        .collection('guilds')
        .where('invite_code', isEqualTo: inviteCode.trim().toUpperCase())
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return Guild.fromJson(query.docs.first.data());
  }

  @override
  Future<void> saveGuild(Guild guild) async {
    await _firestore
        .collection('guilds')
        .doc(guild.id)
        .set(guild.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteGuild(String guildId) async {
    await _firestore.collection('guilds').doc(guildId).delete();
  }

  @override
  Future<void> sendGuildNudge({
    required String guildId,
    required String senderId,
    required String targetUserId,
  }) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final batch = _firestore.batch();

    final guildNudgeRef = _firestore
        .collection('guilds')
        .doc(guildId)
        .collection('nudges')
        .doc();

    batch.set(guildNudgeRef, {
      'guildId': guildId,
      'senderId': senderId,
      'targetUserId': targetUserId,
      'timestamp': nowMs,
    });

    final userNudgeRef = _firestore
        .collection('users')
        .doc(targetUserId)
        .collection('nudges')
        .doc();

    batch.set(userNudgeRef, {
      'guildId': guildId,
      'senderId': senderId,
      'targetUserId': targetUserId,
      'senderName': 'Đồng đội Bang hội',
      'timestamp': nowMs,
    });

    await batch.commit();
  }
}

