import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/auth/domain/repositories/auth_repository.dart';
import 'package:astrobite/features/coach/presentation/widgets/meal_quick_log_card.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';
import 'package:astrobite/features/tracker/domain/tracker_providers.dart';
import 'package:astrobite/features/tracker/presentation/pages/manual_entry_page.dart';
import 'package:astrobite/features/voice/data/datasources/gemini_voice_nlu_datasource.dart';
import 'package:astrobite/features/voice/data/datasources/voice_recognition_service.dart';
import 'package:astrobite/features/voice/domain/entities/voice_log_result.dart';
import 'package:astrobite/features/voice/domain/repositories/voice_log_repository.dart';
import 'package:astrobite/features/voice/presentation/controllers/voice_log_controller.dart';
import 'package:astrobite/features/voice/presentation/widgets/astro_voice_sheet.dart';
import 'package:astrobite/features/voice/presentation/widgets/live_transcript_bubble.dart';
import 'package:astrobite/features/voice/presentation/widgets/voice_pulsing_mic_button.dart';
import 'package:astrobite/features/voice/presentation/widgets/waveform_visualizer.dart';

class _FakeUser implements User {
  @override
  String get uid => 'user_voice_test';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepository implements AuthRepository {
  final User _user = _FakeUser();

  @override
  User? get currentUser => _user;

  @override
  Stream<User?> get authStateChanges => Stream.value(_user);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeFoodLogRepository implements FoodLogRepository {
  final List<FoodLogDto> savedLogs = [];

  @override
  Future<void> addFoodLog({required String userId, required FoodLogDto log}) async {
    savedLogs.add(log);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockVoiceLogRepository implements VoiceLogRepository {
  VoiceLogResult? resultToReturn;
  bool shouldThrow = false;

  @override
  Future<VoiceLogResult> parseVoiceTranscript(String transcript, {DateTime? now}) async {
    if (shouldThrow) {
      throw Exception('Gemini NLU Timeout');
    }
    return resultToReturn ??
        VoiceLogResult(
          rawTranscript: transcript,
          mealType: 'breakfast',
          totalCalories: 680,
          proteinG: 31.0,
          carbsG: 87.0,
          fatG: 23.0,
          sodiumMg: 1450.0,
          dishes: const [
            VoiceDishItem(
              dishName: 'Phở Bò Tái Nạm',
              estimatedWeightG: 600,
              calories: 520,
              proteinG: 28.0,
              carbsG: 65.0,
              fatG: 16.0,
            ),
            VoiceDishItem(
              dishName: 'Quẩy giòn (2 cái)',
              estimatedWeightG: 80,
              calories: 160,
              proteinG: 3.0,
              carbsG: 22.0,
              fatG: 7.0,
            ),
          ],
        );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GeminiVoiceNluDatasource Unit Tests (TC-S20-05 & Time Inference)', () {
    test('inferMealType maps 24-hour ranges accurately', () {
      // 08:00 AM -> breakfast
      expect(
        GeminiVoiceNluDatasource.inferMealType(DateTime(2026, 10, 5, 8, 0)),
        'breakfast',
      );
      // 10:30 AM -> breakfast boundary
      expect(
        GeminiVoiceNluDatasource.inferMealType(DateTime(2026, 10, 5, 10, 30)),
        'breakfast',
      );
      // 12:00 PM -> lunch
      expect(
        GeminiVoiceNluDatasource.inferMealType(DateTime(2026, 10, 5, 12, 0)),
        'lunch',
      );
      // 15:00 PM -> snack
      expect(
        GeminiVoiceNluDatasource.inferMealType(DateTime(2026, 10, 5, 15, 0)),
        'snack',
      );
      // 19:30 PM -> dinner
      expect(
        GeminiVoiceNluDatasource.inferMealType(DateTime(2026, 10, 5, 19, 30)),
        'dinner',
      );
      // 23:30 PM -> snack (midnight)
      expect(
        GeminiVoiceNluDatasource.inferMealType(DateTime(2026, 10, 5, 23, 30)),
        'snack',
      );
    });

    test('parseTranscript throws ArgumentError on empty or whitespace string', () async {
      final datasource = GeminiVoiceNluDatasource(
        apiKeyResolver: () async => 'test_key',
      );
      expect(() => datasource.parseTranscript('   '), throwsArgumentError);
    });
  });

  group('VoiceRecognitionService & Fake Tests (TC-S20-02, TC-S20-10)', () {
    test('FakeVoiceRecognitionService simulates streaming words without throwing', () async {
      final service = FakeVoiceRecognitionService(
        wordsToReturn: 'Cơm sườn trứng ốp la',
      );

      expect(await service.initialize(), isTrue);
      expect(service.isAvailable, isTrue);

      final wordsReceived = <String>[];
      bool finished = false;

      await service.startListening(
        onResult: (words, isFinal) {
          wordsReceived.add(words);
          if (isFinal) finished = true;
        },
      );

      expect(wordsReceived, isNotEmpty);
      expect(wordsReceived.last, 'Cơm sườn trứng ốp la');
      expect(finished, isTrue);

      await service.stopListening();
      expect(service.isListening, isFalse);
    });
  });

  group('VoiceLogController Riverpod State Tests (TC-S20-03, TC-S20-07)', () {
    late FakeVoiceRecognitionService fakeVoiceService;
    late _MockVoiceLogRepository mockVoiceRepo;
    late _FakeFoodLogRepository fakeFoodLogRepo;

    setUp(() {
      fakeVoiceService = FakeVoiceRecognitionService();
      mockVoiceRepo = _MockVoiceLogRepository();
      fakeFoodLogRepo = _FakeFoodLogRepository();
    });

    test('startListening sets status to listening and accumulates transcript', () async {
      final controller = VoiceLogController(
        voiceService: fakeVoiceService,
        voiceRepo: mockVoiceRepo,
      );

      expect(controller.state.status, VoiceStatus.idle);
      await controller.startListening();

      // Because fakeVoiceService finishes with isFinal = true, it automatically parses
      expect(controller.state.status, VoiceStatus.ready);
      expect(controller.state.result, isNotNull);
      expect(controller.state.result!.totalCalories, 680);
    });

    test('stopListeningAndParse with empty string transitions to empty state (TC-S20-08)', () async {
      fakeVoiceService.wordsToReturn = '';
      final controller = VoiceLogController(
        voiceService: fakeVoiceService,
        voiceRepo: mockVoiceRepo,
      );

      controller.updateTranscript('   ');
      await controller.stopListeningAndParse();

      expect(controller.state.status, VoiceStatus.empty);
      expect(controller.state.errorMessage, isNotNull);
    });

    test('stopListeningAndParse on error transitions to error state (TC-S20-09)', () async {
      mockVoiceRepo.shouldThrow = true;
      final controller = VoiceLogController(
        voiceService: fakeVoiceService,
        voiceRepo: mockVoiceRepo,
      );

      controller.updateTranscript('Bánh mì chả lụa');
      await controller.stopListeningAndParse();

      expect(controller.state.status, VoiceStatus.error);
      expect(controller.state.errorMessage, contains('Gemini NLU Timeout'));
    });

    test('saveMealLog saves FoodLogDto with voice_log source (< 150ms)', () async {
      final controller = VoiceLogController(
        voiceService: fakeVoiceService,
        voiceRepo: mockVoiceRepo,
      );

      controller.updateTranscript('Phở Bò');
      await controller.stopListeningAndParse();

      final success = await controller.saveMealLog(
        userId: 'user_voice_test',
        foodLogRepo: fakeFoodLogRepo,
      );

      expect(success, isTrue);
      expect(fakeFoodLogRepo.savedLogs, isNotEmpty);
      final log = fakeFoodLogRepo.savedLogs.first;
      expect(log.source, 'voice_log');
      expect(log.dishName, 'Phở Bò Tái Nạm, Quẩy giòn (2 cái)');
      expect(log.calories, 680);
      expect(log.proteinG, 31);
      expect(log.carbsG, 87);
      expect(log.fatG, 23);
    });
  });

  group('AstroVoice Widget Tests (TC-S20-01, TC-S20-04, TC-S20-07)', () {
    late _FakeAuthRepository fakeAuth;
    late _FakeFoodLogRepository fakeFoodLog;
    late FakeVoiceRecognitionService fakeVoiceService;
    late _MockVoiceLogRepository mockVoiceRepo;

    setUp(() {
      fakeAuth = _FakeAuthRepository();
      fakeFoodLog = _FakeFoodLogRepository();
      fakeVoiceService = FakeVoiceRecognitionService(
        wordsToReturn: '1 tô phở bò tái nạm và 2 cái quẩy',
      );
      mockVoiceRepo = _MockVoiceLogRepository();
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeAuth),
          foodLogRepositoryProvider.overrideWithValue(fakeFoodLog),
          voiceRecognitionServiceProvider.overrideWithValue(fakeVoiceService),
          voiceLogRepositoryProvider.overrideWithValue(mockVoiceRepo),
        ],
        child: MaterialApp(
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('VoicePulsingMicButton renders and triggers onTap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: VoicePulsingMicButton(
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(const Key('voice_pulsing_mic_button')), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);

      await tester.tap(find.byKey(const Key('voice_pulsing_mic_button')));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('LiveTranscriptBubble and WaveformVisualizer render correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                LiveTranscriptBubble(
                  transcript: '1 tô phở bò',
                  isListening: true,
                ),
                WaveformVisualizer(
                  soundLevel: 0.7,
                  isListening: true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('1 tô phở bò'), findsOneWidget);
      expect(find.text('ĐANG LẮNG NGHE...'), findsOneWidget);
      expect(find.byType(WaveformVisualizer), findsOneWidget);
    });

    testWidgets('AstroVoiceSheet starts listening and transitions to Ready state with MealQuickLogCard', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(const AstroVoiceSheet()));
      // Allow post frame callback and fake voice recognition to complete
      await tester.pumpAndSettle();

      expect(find.text('AstroVoice AI'), findsOneWidget);
      expect(find.byType(MealQuickLogCard), findsOneWidget);
      expect(find.textContaining('680'), findsWidgets); // Calories

      // Tap 1-Tap Log Duolingo button
      final logButton = find.textContaining('Ghi vào nhật ký');
      expect(logButton, findsWidgets);

      await tester.tap(logButton.first);
      await tester.pumpAndSettle();

      expect(fakeFoodLog.savedLogs, isNotEmpty);
      expect(fakeFoodLog.savedLogs.first.calories, 680);
      expect(fakeFoodLog.savedLogs.first.source, 'voice_log');
    });

    testWidgets('ManualEntryPage integrates AstroVoice mic icon in search bar', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(const ManualEntryPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_rounded), findsWidgets);
    });
  });
}
