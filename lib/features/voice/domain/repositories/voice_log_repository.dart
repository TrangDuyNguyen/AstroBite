import '../entities/voice_log_result.dart';

abstract class VoiceLogRepository {
  Future<VoiceLogResult> parseVoiceTranscript(String transcript, {DateTime? now});
}
