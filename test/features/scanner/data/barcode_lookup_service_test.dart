import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/scanner/data/barcode_lookup_service.dart';

void main() {
  group('BarcodeLookupService Unit Tests', () {
    setUp(() {
      BarcodeLookupService.clearCache();
    });

    test('lookupBarcode returns null immediately for empty or short barcodes', () async {
      final service = BarcodeLookupService();

      expect(await service.lookupBarcode(''), isNull);
      expect(await service.lookupBarcode('   '), isNull);
      expect(await service.lookupBarcode('123'), isNull);
    });

    test('clearCache resets in-memory cache without errors', () {
      expect(() => BarcodeLookupService.clearCache(), returnsNormally);
    });
  });
}
