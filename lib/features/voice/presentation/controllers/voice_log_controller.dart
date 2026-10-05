import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/tracker/data/models/food_log_dto.dart';
import 'package:astrobite/features/tracker/domain/repositories/food_log_repository.dart';
import '../../data/datasources/voice_recognition_service.dart';
import '../../domain/entities/voice_log_result.dart';
import '../../domain/repositories/voice_log_repository.dart';
import '../../data/repositories/voice_log_repository_impl.dart';

enum VoiceStatus {
  idle,
  listening,
  parsing,
  ready,
  empty,
  error,
}

class VoiceLogState {
  const VoiceLogState({
    this.status = VoiceStatus.idle,
    this.liveTranscript = '',
    this.soundLevel = 0.0,
    this.result,
    this.errorMessage,
    this.isSaving = false,
  });

  final VoiceStatus status;
  final String liveTranscript;
  final double soundLevel;
  final VoiceLogResult? result;
  final String? errorMessage;
  final bool isSaving;

  VoiceLogState copyWith({
    VoiceStatus? status,
    String? liveTranscript,
    double? soundLevel,
    VoiceLogResult? result,
    String? errorMessage,
    bool? isSaving,
  }) {
    return VoiceLogState(
      status: status ?? this.status,
      liveTranscript: liveTranscript ?? this.liveTranscript,
      soundLevel: soundLevel ?? this.soundLevel,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Provider for VoiceRecognitionService
final voiceRecognitionServiceProvider = Provider<VoiceRecognitionService>((ref) {
  return SpeechToTextRecognitionService();
});

/// Provider for VoiceLogRepository
final voiceLogRepositoryProvider = Provider<VoiceLogRepository>((ref) {
  return VoiceLogRepositoryImpl();
});

/// Riverpod StateNotifier for managing the voice log lifecycle.
class VoiceLogController extends StateNotifier<VoiceLogState> {
  VoiceLogController({
    required VoiceRecognitionService voiceService,
    required VoiceLogRepository voiceRepo,
  })  : _voiceService = voiceService,
        _voiceRepo = voiceRepo,
        super(const VoiceLogState());

  final VoiceRecognitionService _voiceService;
  final VoiceLogRepository _voiceRepo;

  Future<void>? _pendingParse;
  Future<void>? get pendingParse => _pendingParse;

  Future<void> startListening() async {
    state = state.copyWith(
      status: VoiceStatus.listening,
      liveTranscript: '',
      soundLevel: 0.0,
      errorMessage: null,
    );

    await _voiceService.startListening(
      onResult: (words, isFinal) {
        state = state.copyWith(
          liveTranscript: words,
        );
        if (isFinal && words.trim().isNotEmpty) {
          _pendingParse = stopListeningAndParse();
        }
      },
      onSoundLevelChange: (level) {
        state = state.copyWith(soundLevel: level);
      },
    );

    if (_pendingParse != null) {
      await _pendingParse;
    }
  }

  Future<void> stopListeningAndParse() async {
    await _voiceService.stopListening();

    final text = state.liveTranscript.trim();
    if (text.isEmpty) {
      state = state.copyWith(
        status: VoiceStatus.empty,
        errorMessage: 'AstroBite chưa nghe rõ món bạn vừa nói.',
      );
      return;
    }

    state = state.copyWith(status: VoiceStatus.parsing);

    try {
      final res = await _voiceRepo.parseVoiceTranscript(text);
      state = state.copyWith(
        status: VoiceStatus.ready,
        result: res,
      );
    } catch (e) {
      state = state.copyWith(
        status: VoiceStatus.error,
        errorMessage: 'Không thể phân tích dinh dưỡng: $e',
      );
    }
  }

  Future<bool> saveMealLog({
    required String userId,
    required FoodLogRepository foodLogRepo,
  }) async {
    final res = state.result;
    if (res == null) return false;

    state = state.copyWith(isSaving: true);

    try {
      final now = DateTime.now();
      final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final logId = 'voice_${now.millisecondsSinceEpoch}';

      final log = FoodLogDto(
        id: logId,
        date: dateKey,
        mealType: res.mealType,
        dishName: res.primaryDishName,
        estimatedWeightG: res.totalWeightG > 0 ? res.totalWeightG : 100,
        calories: res.totalCalories,
        proteinG: res.proteinG.round(),
        carbsG: res.carbsG.round(),
        fatG: res.fatG.round(),
        sodiumMg: res.sodiumMg,
        confidenceScore: res.confidenceScore,
        source: 'voice_log',
        dishes: res.dishes.map((d) => d.toMap()).toList(),
      );

      await foodLogRepo.addFoodLog(userId: userId, log: log);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Lỗi khi lưu bữa ăn: $e',
      );
      return false;
    }
  }

  void cancel() {
    _voiceService.cancelListening();
    state = const VoiceLogState();
  }

  void updateTranscript(String text) {
    state = state.copyWith(liveTranscript: text);
  }
}

/// Provider for VoiceLogController
final voiceLogControllerProvider =
    StateNotifierProvider.autoDispose<VoiceLogController, VoiceLogState>((ref) {
  final voiceService = ref.watch(voiceRecognitionServiceProvider);
  final voiceRepo = ref.watch(voiceLogRepositoryProvider);
  return VoiceLogController(
    voiceService: voiceService,
    voiceRepo: voiceRepo,
  );
});
