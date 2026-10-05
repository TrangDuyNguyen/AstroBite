import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Abstract interface for voice speech recognition (Ponytail clean abstraction).
abstract class VoiceRecognitionService {
  Future<bool> initialize();
  Future<void> startListening({
    required void Function(String words, bool isFinal) onResult,
    void Function(double soundLevel)? onSoundLevelChange,
  });
  Future<void> stopListening();
  Future<void> cancelListening();
  bool get isListening;
  bool get isAvailable;
}

/// Production implementation using on-device `speech_to_text`.
class SpeechToTextRecognitionService implements VoiceRecognitionService {
  SpeechToTextRecognitionService({stt.SpeechToText? speech})
      : _speech = speech ?? stt.SpeechToText();

  final stt.SpeechToText _speech;
  bool _isAvailable = false;

  @override
  bool get isListening => _speech.isListening;

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<bool> initialize() async {
    try {
      _isAvailable = await _speech.initialize(
        onError: (val) => debugPrint('AstroVoice Speech Error: $val'),
        onStatus: (val) => debugPrint('AstroVoice Speech Status: $val'),
      );
      return _isAvailable;
    } catch (e) {
      debugPrint('AstroVoice Initialize Error: $e');
      _isAvailable = false;
      return false;
    }
  }

  @override
  Future<void> startListening({
    required void Function(String words, bool isFinal) onResult,
    void Function(double soundLevel)? onSoundLevelChange,
  }) async {
    if (!_isAvailable) {
      final ok = await initialize();
      if (!ok) return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        onSoundLevelChange: onSoundLevelChange,
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          pauseFor: const Duration(milliseconds: 1200),
          localeId: 'vi_VN',
        ),
      );
    } catch (e) {
      debugPrint('AstroVoice Listen Error: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await _speech.stop();
    } catch (e) {
      debugPrint('AstroVoice Stop Error: $e');
    }
  }

  @override
  Future<void> cancelListening() async {
    try {
      await _speech.cancel();
    } catch (e) {
      debugPrint('AstroVoice Cancel Error: $e');
    }
  }
}

/// Fake service for unit and widget tests (Zero MissingPluginException).
class FakeVoiceRecognitionService implements VoiceRecognitionService {
  FakeVoiceRecognitionService({
    this.wordsToReturn = '1 tô phở bò tái nạm và 2 cái quẩy',
    this.shouldSucceed = true,
  });

  String wordsToReturn;
  bool shouldSucceed;
  bool _listening = false;

  @override
  bool get isListening => _listening;

  @override
  bool get isAvailable => shouldSucceed;

  @override
  Future<bool> initialize() async => shouldSucceed;

  @override
  Future<void> startListening({
    required void Function(String words, bool isFinal) onResult,
    void Function(double soundLevel)? onSoundLevelChange,
  }) async {
    if (!shouldSucceed) return;
    _listening = true;
    onSoundLevelChange?.call(0.8);
    // Simulate streaming words
    final parts = wordsToReturn.split(' ');
    String current = '';
    for (int i = 0; i < parts.length; i++) {
      current += (i == 0 ? '' : ' ') + parts[i];
      onResult(current, i == parts.length - 1);
    }
  }

  @override
  Future<void> stopListening() async {
    _listening = false;
  }

  @override
  Future<void> cancelListening() async {
    _listening = false;
  }
}
