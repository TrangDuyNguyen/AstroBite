import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/leaderboard_entry.dart';

abstract class SocialRemoteDatasource {
  Future<void> upsertUserLeaderboardEntry(LeaderboardEntry entry);
  Stream<List<LeaderboardEntry>> watchLeaderboard(String currentUserId);
  Future<LeaderboardEntry?> findUserByAstroId(String astroId);
  Future<void> addFriend({
    required String currentUserId,
    required LeaderboardEntry friendEntry,
  });
  Future<void> sendNudge({
    required String senderId,
    required String senderName,
    required String senderAstroId,
    required String targetUserId,
  });
  Future<bool> hasNudgedToday({
    required String senderId,
    required String targetUserId,
  });
}

class SocialRemoteDatasourceImpl implements SocialRemoteDatasource {
  final FirebaseFirestore _firestore;

  SocialRemoteDatasourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> upsertUserLeaderboardEntry(LeaderboardEntry entry) async {
    final docRef = _firestore.collection('social_leaderboard').doc(entry.uid);
    await docRef.set({
      'uid': entry.uid,
      'name': entry.name,
      'astroId': entry.astroId,
      'streak': entry.streak,
      'goalAchievedToday': entry.goalAchievedToday,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Stream<List<LeaderboardEntry>> watchLeaderboard(String currentUserId) {
    return _firestore
        .collection('social_leaderboard')
        .orderBy('streak', descending: true)
        .limit(50)
        .snapshots()
        .asyncMap((snapshot) async {
      final entries = <LeaderboardEntry>[];
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final data = doc.data();
        final uid = data['uid'] as String? ?? doc.id;
        final isMe = uid == currentUserId;

        bool isNudgedToday = false;
        if (!isMe) {
          final nudgeDoc = await _firestore
              .collection('social_leaderboard')
              .doc(uid)
              .collection('nudges')
              .doc(currentUserId)
              .get();

          if (nudgeDoc.exists) {
            final ts = nudgeDoc.data()?['timestamp'] as int? ?? 0;
            if (ts >= startOfDay) {
              isNudgedToday = true;
            }
          }
        }

        entries.add(LeaderboardEntry(
          uid: uid,
          name: data['name'] as String? ?? 'Phi hành gia',
          astroId: data['astroId'] as String? ?? '#AST-0000',
          streak: (data['streak'] as num?)?.toInt() ?? 0,
          rank: i + 1,
          isMe: isMe,
          goalAchievedToday: data['goalAchievedToday'] as bool? ?? false,
          isNudgedToday: isNudgedToday,
        ));
      }
      return entries;
    });
  }

  @override
  Future<LeaderboardEntry?> findUserByAstroId(String astroId) async {
    final cleanId = astroId.trim().toUpperCase();
    final formattedId = cleanId.startsWith('#') ? cleanId : '#$cleanId';

    final query = await _firestore
        .collection('social_leaderboard')
        .where('astroId', isEqualTo: formattedId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;
    final data = doc.data();
    return LeaderboardEntry(
      uid: data['uid'] as String? ?? doc.id,
      name: data['name'] as String? ?? 'Phi hành gia',
      astroId: formattedId,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
      rank: 0,
      goalAchievedToday: data['goalAchievedToday'] as bool? ?? false,
    );
  }

  @override
  Future<void> addFriend({
    required String currentUserId,
    required LeaderboardEntry friendEntry,
  }) async {
    final batch = _firestore.batch();

    final myFriendRef = _firestore
        .collection('social_leaderboard')
        .doc(currentUserId)
        .collection('friends')
        .doc(friendEntry.uid);

    batch.set(myFriendRef, {
      'uid': friendEntry.uid,
      'name': friendEntry.name,
      'astroId': friendEntry.astroId,
      'streak': friendEntry.streak,
      'addedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<void> sendNudge({
    required String senderId,
    required String senderName,
    required String senderAstroId,
    required String targetUserId,
  }) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;

    final batch = _firestore.batch();

    // 1. Record under social_leaderboard/{targetUserId}/nudges/{senderId}
    final leaderboardNudgeRef = _firestore
        .collection('social_leaderboard')
        .doc(targetUserId)
        .collection('nudges')
        .doc(senderId);

    batch.set(leaderboardNudgeRef, {
      'senderId': senderId,
      'senderName': senderName,
      'senderAstroId': senderAstroId,
      'timestamp': nowMs,
    });

    // 2. Record under users/{targetUserId}/nudges (triggers Cloud Function for push notification)
    final userNudgeRef = _firestore
        .collection('users')
        .doc(targetUserId)
        .collection('nudges')
        .doc();

    batch.set(userNudgeRef, {
      'senderId': senderId,
      'senderName': senderName,
      'senderAstroId': senderAstroId,
      'timestamp': nowMs,
    });

    await batch.commit();
  }

  @override
  Future<bool> hasNudgedToday({
    required String senderId,
    required String targetUserId,
  }) async {
    final doc = await _firestore
        .collection('social_leaderboard')
        .doc(targetUserId)
        .collection('nudges')
        .doc(senderId)
        .get();

    if (!doc.exists) return false;
    final ts = doc.data()?['timestamp'] as int? ?? 0;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    return ts >= startOfDay;
  }
}

