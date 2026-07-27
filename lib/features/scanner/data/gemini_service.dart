import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:astrobite/core/utils/json_parser.dart';
import 'models/scan_result_dto.dart';

class GeminiService {
  GeminiService({GenerativeModel? model, String? apiKey})
      : _model = model ??
            GenerativeModel(
              model: 'gemini-1.5-flash',
              apiKey: apiKey ?? 'DEV_API_KEY',
            );

  final GenerativeModel _model;

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
  "dishes": [
    {
      "dish_name": "string",
      "confidence_score": float,
      "estimated_weight_g": integer,
      "calories": integer
    }
  ]
}

Contextual Rules:
1. Prioritize Vietnamese traditional food profiles and default ingredients.
2. If multiple items exist on one plate, segment them into the "dishes" array.
''';

  Future<ScanResultDto?> analyzeFoodImage(Uint8List imageBytes) async {
    final response = await _model.generateContent([
      Content.multi([
        TextPart(_systemPrompt),
        DataPart('image/jpeg', imageBytes),
      ]),
    ]);

    final text = response.text;
    if (text == null || text.isEmpty) return null;

    final jsonMap = JsonParser.tryParseGeminiResponse(text);
    if (jsonMap == null) return null;

    return ScanResultDto.fromJson(jsonMap);
  }
}
