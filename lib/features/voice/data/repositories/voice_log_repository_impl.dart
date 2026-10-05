import '../../domain/entities/voice_log_result.dart';
import '../../domain/repositories/voice_log_repository.dart';
import '../datasources/gemini_voice_nlu_datasource.dart';

class VoiceLogRepositoryImpl implements VoiceLogRepository {
  VoiceLogRepositoryImpl({GeminiVoiceNluDatasource? datasource})
      : _datasource = datasource ?? GeminiVoiceNluDatasource();

  final GeminiVoiceNluDatasource _datasource;

  @override
  Future<VoiceLogResult> parseVoiceTranscript(
    String transcript, {
    DateTime? now,
  }) {
    return _datasource.parseTranscript(transcript, now: now);
  }
}
