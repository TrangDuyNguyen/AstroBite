import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/social/data/datasources/social_remote_datasource.dart';
import 'package:astrobite/features/social/data/repositories/social_repository.dart';
import 'package:astrobite/features/social/domain/entities/leaderboard_entry.dart';

class MockSocialRemoteDatasource implements SocialRemoteDatasource {
  final StreamController<List<LeaderboardEntry>> streamController =
      StreamController<List<LeaderboardEntry>>.broadcast();

  final List<LeaderboardEntry> remoteEntries = [];
  final List<String> nudgedUsers = [];
  LeaderboardEntry? userToFind;

  @override
  Future<void> upsertUserLeaderboardEntry(LeaderboardEntry entry) async {
    remoteEntries.removeWhere((e) => e.uid == entry.uid);
    remoteEntries.add(entry);
  }

  @override
  Stream<List<LeaderboardEntry>> watchLeaderboard(String currentUserId) {
    return streamController.stream;
  }

  @override
  Future<LeaderboardEntry?> findUserByAstroId(String astroId) async {
    if (userToFind != null && userToFind!.astroId == astroId) {
      return userToFind;
    }
    return null;
  }

  @override
  Future<void> addFriend({
    required String currentUserId,
    required LeaderboardEntry friendEntry,
  }) async {
    remoteEntries.add(friendEntry);
  }

  @override
  Future<void> sendNudge({
    required String senderId,
    required String senderName,
    required String senderAstroId,
    required String targetUserId,
  }) async {
    nudgedUsers.add(targetUserId);
  }

  @override
  Future<bool> hasNudgedToday({
    required String senderId,
    required String targetUserId,
  }) async {
    return nudgedUsers.contains(targetUserId);
  }

  void dispose() {
    streamController.close();
  }
}

void main() {
  group('SocialRepository Remote Integration Tests', () {
    late MockSocialRemoteDatasource mockRemote;
    late SocialRepository repository;

    setUp(() {
      mockRemote = MockSocialRemoteDatasource();
      repository = SocialRepository(
        myAstroId: '#AST-ME01',
        currentUserId: 'me_01',
        currentUserName: 'Me Tester',
        remoteDatasource: mockRemote,
      );
    });

    tearDown(() {
      repository.dispose();
      mockRemote.dispose();
    });

    test('upserts current user to remote datasource on init', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      expect(mockRemote.remoteEntries.any((e) => e.uid == 'me_01'), isTrue);
    });

    test('updates leaderboard when remote stream emits', () async {
      final emittedEntries = [
        const LeaderboardEntry(
          uid: 'user_star',
          name: 'StarGazer',
          astroId: '#AST-8888',
          streak: 50,
          rank: 1,
        ),
      ];

      mockRemote.streamController.add(emittedEntries);
      await Future.delayed(const Duration(milliseconds: 50));

      final current = await repository.watchLeaderboard().first;
      expect(current.any((e) => e.astroId == '#AST-8888'), isTrue);
    });

    test('addFriend uses remote search and persists to remote datasource', () async {
      mockRemote.userToFind = const LeaderboardEntry(
        uid: 'user_galaxy',
        name: 'GalaxyHero',
        astroId: '#AST-9999',
        streak: 15,
        rank: 2,
      );

      await repository.addFriend('#AST-9999');

      expect(mockRemote.remoteEntries.any((e) => e.astroId == '#AST-9999'), isTrue);
      final entries = await repository.watchLeaderboard().first;
      expect(entries.any((e) => e.astroId == '#AST-9999'), isTrue);
    });

    test('nudgeFriend calls remote sendNudge and prevents duplicate nudge', () async {
      mockRemote.streamController.add([
        const LeaderboardEntry(
          uid: 'user_target',
          name: 'TargetFriend',
          astroId: '#AST-5555',
          streak: 10,
          rank: 1,
          isNudgedToday: false,
        ),
      ]);
      await Future.delayed(const Duration(milliseconds: 50));

      final success = await repository.nudgeFriend('#AST-5555');
      expect(success, isTrue);
      expect(mockRemote.nudgedUsers.contains('user_target'), isTrue);

      // Attempt second nudge should be rejected
      expect(
        () => repository.nudgeFriend('#AST-5555'),
        throwsA(isA<StateError>()),
      );
    });
  });
}

