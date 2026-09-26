import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/core/utils/json_parser.dart';
import '../models/scan_result_dto.dart';

/// Remote datasource that communicates directly with Google Gemini AI
/// via Google AI Studio API Key (Free tier, no credit card required).
class GeminiRemoteDatasource {
  GeminiRemoteDatasource({
    GenerativeModel? model,
    Future<String> Function()? apiKeyResolver,
  })  : _model = model,
        _apiKeyResolver = apiKeyResolver ?? GeminiApiKeyNotifier.getActiveKey;

  final GenerativeModel? _model;
  final Future<String> Function() _apiKeyResolver;

  static const _systemPrompt = '''
You are an expert nutritionist and computer vision AI specialized in Vietnamese cuisine and global food mapping.
Analyze the attached image and extract all identifiable food items, their estimated weights, and calculated nutritional profiles.

You MUST return a valid, minified JSON object matching the schema below. Do NOT wrap the JSON in markdown code blocks, do NOT include any introductory or concluding text.

Schema Definition:
{
  "is_food": boolean,
  "total_calories": integer,
  "macros": {
    "protein_g": integer,
    "carbs_g": integer,
    "fat_g": integer
  },
  "sodium_mg": float,
  "fiber_g": float,
  "sugar_g": float,
  "dishes": [
    {
      "dish_name": "string",
      "confidence_score": float,
      "estimated_weight_g": integer,
      "calories": integer,
      "carbs_g": integer,
      "protein_g": integer,
      "fat_g": integer,
      "sodium_mg": float,
      "fiber_g": float,
      "sugar_g": float
    }
  ]
}

Contextual Rules:
1. Prioritize Vietnamese traditional food profiles and default ingredients.
2. If multiple items exist on one plate or tray, segment each distinct item into the "dishes" array.
3. Provide accurate estimates for sodium (mg), dietary fiber (g), and sugars (g).
''';

  Future<ScanResultDto?> analyzeFoodImage(Uint8List imageBytes) async {
    if (_model != null) {
      return _generateWithModel(_model!, imageBytes);
    }

    final apiKey = await _apiKeyResolver();
    if (apiKey.isEmpty) {
      throw StateError(
        'Chưa cấu hình Gemini API Key.\n'
        'Vui lòng vào mục Hồ sơ để cài đặt API Key miễn phí từ Google AI Studio (aistudio.google.com) hoặc file .env.',
      );
    }

    // Prioritize active fast vision models with automatic fallback on demand spikes (503) or rate limits
    const candidateModels = [
      'gemini-3-flash-preview',
      'gemini-3.8-flash',
      'gemini-3.6-flash',
      'gemini-flash-latest',
      'gemini-3.5-flash',
    ];

    Object? lastError;
    for (final modelName in candidateModels) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
          ),
        );
        return await _generateWithModel(model, imageBytes);
      } catch (e) {
        lastError = e;
        final errStr = e.toString().toLowerCase();

        // If the API key is completely invalid or revoked, fail fast
        if (errStr.contains('api_key_invalid') ||
            errStr.contains('api key not valid') ||
            errStr.contains('key expired')) {
          rethrow;
        }

        // On capacity / high demand (503), quota / rate limit (429), timeout, or model errors,
        // automatically fallback to the next candidate model
        continue;
      }
    }

    if (lastError != null) throw lastError;
    return null;
  }

  Future<ScanResultDto?> _generateWithModel(
    GenerativeModel model,
    Uint8List imageBytes,
  ) async {
    final response = await model.generateContent([
      Content.multi([
        TextPart(_systemPrompt),
        DataPart('image/jpeg', imageBytes),
      ]),
    ]).timeout(const Duration(seconds: 14));

    final text = response.text;
    if (text == null || text.isEmpty) return null;

    final jsonMap = JsonParser.tryParseGeminiResponse(text);
    if (jsonMap == null) return null;

    return ScanResultDto.fromJson(jsonMap);
  }
}
