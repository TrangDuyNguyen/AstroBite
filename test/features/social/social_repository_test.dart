import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/social/data/repositories/social_repository.dart';
import 'package:astrobite/features/social/presentation/controllers/social_controller.dart';


void main() {
  group('SocialRepository Tests', () {
    late SocialRepository repository;

    setUp(() {
      repository = SocialRepository(myAstroId: '#ASTRO-8821');
    });

    tearDown(() {
      repository.dispose();
    });

    test('watchLeaderboard emits initial sorted list with ranks', () async {
      final entries = await repository.watchLeaderboard().first;

      expect(entries.isNotEmpty, isTrue);
      // Verify sorted descending by streak
      for (int i = 0; i < entries.length - 1; i++) {
        expect(entries[i].streak >= entries[i + 1].streak, isTrue);
        expect(entries[i].rank, equals(i + 1));
      }
    });

    test('addFriend adds new friend and re-emits sorted list', () async {
      await repository.addFriend('#NEW-1234');
      final entries = await repository.watchLeaderboard().first;

      final added = entries.firstWhere((e) => e.astroId == '#NEW-1234');
      expect(added.name, contains('NEW-1234'));
      expect(added.streak, equals(1));
    });

    test('addFriend rejects empty id', () async {
      expect(
        () => repository.addFriend('   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('addFriend rejects adding oneself', () async {
      expect(
        () => repository.addFriend('#ASTRO-8821'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('addFriend rejects duplicate friends', () async {
      expect(
        () => repository.addFriend('#AST-0042'),
        throwsA(isA<StateError>()),
      );
    });

    test('nudgeFriend marks friend as nudged for today', () async {
      final result = await repository.nudgeFriend('#AST-0042');
      expect(result, isTrue);

      final entries = await repository.watchLeaderboard().first;
      final alex = entries.firstWhere((e) => e.astroId == '#AST-0042');
      expect(alex.isNudgedToday, isTrue);
    });

    test('nudgeFriend rejects double nudging on the same day (anti-spam)', () async {
      await repository.nudgeFriend('#AST-0042');

      expect(
        () => repository.nudgeFriend('#AST-0042'),
        throwsA(isA<StateError>()),
      );
    });

    test('nudgeFriend rejects nudging oneself', () async {
      expect(
        () => repository.nudgeFriend('#ASTRO-8821'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('SocialController Tests', () {
    late SocialRepository repository;
    late SocialController controller;

    setUp(() {
      repository = SocialRepository(myAstroId: '#ASTRO-8821');
      controller = SocialController(repository);
    });

    tearDown(() {
      repository.dispose();
    });

    test('addFriend sets success message on valid input', () async {
      final success = await controller.addFriend('#COOL-9999');
      expect(success, isTrue);
      expect(controller.state.successMessage, contains('#COOL-9999'));
      expect(controller.state.errorMessage, isNull);
    });

    test('addFriend sets error message on self add', () async {
      final success = await controller.addFriend('#ASTRO-8821');
      expect(success, isFalse);
      expect(controller.state.errorMessage, contains('chính mình'));
    });

    test('nudgeFriend sets success message', () async {
      final success = await controller.nudgeFriend('#AST-0042', 'AlexD');
      expect(success, isTrue);
      expect(controller.state.successMessage, contains('AlexD'));
    });
  });
}
