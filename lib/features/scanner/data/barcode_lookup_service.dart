import 'dart:convert';
import 'dart:io';
import 'models/scan_result_dto.dart';

/// Lightweight Open Food Facts REST client with in-memory caching.
/// Uses Dart standard library HttpClient for zero dependency footprint.
class BarcodeLookupService {
  BarcodeLookupService({HttpClient? client}) : _client = client;

  final HttpClient? _client;
  static final Map<String, ScanResultDto> _memoryCache = {};

  static const _endpointBase = 'https://world.openfoodfacts.org/api/v2/product';
  static const _userAgent = 'AstroBite-App/3.4.0 (contact@astrobite.app)';

  /// Lookup a food item by its standard barcode (EAN-13, UPC-A, Code 128).
  Future<ScanResultDto?> lookupBarcode(String barcode) async {
    final cleanBarcode = barcode.trim();
    if (cleanBarcode.isEmpty || cleanBarcode.length < 6) return null;

    // Check O(1) in-memory cache first
    if (_memoryCache.containsKey(cleanBarcode)) {
      return _memoryCache[cleanBarcode];
    }

    final client = _client ?? HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);

    try {
      final uri = Uri.parse('$_endpointBase/$cleanBarcode.json');
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 4));
      request.headers.set('User-Agent', _userAgent);
      request.headers.set('Accept', 'application/json');

      final response = await request.close().timeout(const Duration(seconds: 4));
      if (response.statusCode != 200) return null;

      final responseBody = await response.transform(utf8.decoder).join();
      final json = jsonDecode(responseBody) as Map<String, dynamic>;

      final status = (json['status'] as num?)?.toInt() ?? 0;
      if (status != 1 || json['product'] == null) return null;

      final product = json['product'] as Map<String, dynamic>;
      final resultDto = _mapProductToDto(cleanBarcode, product);
      if (resultDto != null) {
        _memoryCache[cleanBarcode] = resultDto;
      }
      return resultDto;
    } catch (_) {
      // Gracefully return null on network failure/timeout so fallback proceeds
      return null;
    } finally {
      if (_client == null) {
        client.close(force: false);
      }
    }
  }

  ScanResultDto? _mapProductToDto(String barcode, Map<String, dynamic> product) {
    final name = (product['product_name_vi'] as String?)?.trim().isNotEmpty == true
        ? product['product_name_vi'] as String
        : (product['product_name'] as String?)?.trim().isNotEmpty == true
            ? product['product_name'] as String
            : product['product_name_en'] as String? ?? 'Sản phẩm đóng gói';

    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

    // Prefer serving values if available, otherwise 100g values
    final servingQuantity = (product['serving_quantity'] as num?)?.toDouble() ?? 100.0;
    final servingWeightG = servingQuantity > 0 ? servingQuantity.round() : 100;

    final caloriesNum = nutriments['energy-kcal_serving'] as num? ??
        nutriments['energy-kcal_100g'] as num? ??
        nutriments['energy-kcal'] as num? ??
        0;
    final calories = caloriesNum.round();

    final proteinNum = nutriments['proteins_serving'] as num? ??
        nutriments['proteins_100g'] as num? ??
        0.0;
    final proteinG = proteinNum.round();

    final carbsNum = nutriments['carbohydrates_serving'] as num? ??
        nutriments['carbohydrates_100g'] as num? ??
        0.0;
    final carbsG = carbsNum.round();

    final fatNum = nutriments['fat_serving'] as num? ??
        nutriments['fat_100g'] as num? ??
        0.0;
    final fatG = fatNum.round();

    final sodiumNum = nutriments['sodium_serving'] as num? ??
        nutriments['sodium_100g'] as num? ??
        0.0;
    // Open Food Facts reports sodium in grams; convert to milligrams
    final sodiumMg = (sodiumNum.toDouble() * 1000).clamp(0.0, 50000.0);

    final fiberNum = nutriments['fiber_serving'] as num? ??
        nutriments['fiber_100g'] as num? ??
        0.0;
    final fiberG = fiberNum.toDouble();

    final sugarNum = nutriments['sugars_serving'] as num? ??
        nutriments['sugars_100g'] as num? ??
        0.0;
    final sugarG = sugarNum.toDouble();

    return ScanResultDto(
      isFood: true,
      totalCalories: calories,
      macros: MacroDto(
        proteinG: proteinG,
        carbsG: carbsG,
        fatG: fatG,
      ),
      sodiumMg: sodiumMg,
      fiberG: fiberG,
      sugarG: sugarG,
      dishes: [
        DishDto(
          dishName: name,
          confidenceScore: 0.98,
          estimatedWeightG: servingWeightG,
          calories: calories,
          carbsG: carbsG,
          proteinG: proteinG,
          fatG: fatG,
          sodiumMg: sodiumMg,
          fiberG: fiberG,
          sugarG: sugarG,
          hasBroth: false,
          brothCalories: 0,
          brothSodiumMg: 0.0,
          includeBroth: false,
          subItems: const [],
        ),
      ],
    );
  }

  /// Clear the memory cache (useful for testing or cache reset).
  static void clearCache() => _memoryCache.clear();
}
