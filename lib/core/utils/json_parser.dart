import 'dart:convert';

/// Defensive JSON parser for Gemini API responses.
/// Handles common issues: markdown wrappers, extra text, malformed JSON.
class JsonParser {
  const JsonParser._();

  /// Attempt to extract and parse JSON from a raw Gemini response string.
  /// Returns null if parsing fails.
  static Map<String, dynamic>? tryParseGeminiResponse(String raw) {
    try {
      // Step 1: Try direct parse
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      // Step 2: Try stripping markdown code fences
      final stripped = _stripMarkdownFences(raw);
      try {
        return jsonDecode(stripped) as Map<String, dynamic>;
      } catch (_) {
        // Step 3: Try extracting JSON object from surrounding text
        final extracted = _extractJsonObject(raw);
        if (extracted != null) {
          try {
            return jsonDecode(extracted) as Map<String, dynamic>;
          } catch (_) {
            return null;
          }
        }
        return null;
      }
    }
  }

  static String _stripMarkdownFences(String input) {
    var result = input.trim();
    // Remove ```json ... ``` or ``` ... ```
    final fencePattern = RegExp(r'^```(?:json)?\s*\n?(.*?)\n?\s*```$', dotAll: true);
    final match = fencePattern.firstMatch(result);
    if (match != null) {
      result = match.group(1)?.trim() ?? result;
    }
    return result;
  }

  static String? _extractJsonObject(String input) {
    final start = input.indexOf('{');
    final end = input.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return input.substring(start, end + 1);
    }
    return null;
  }
}
