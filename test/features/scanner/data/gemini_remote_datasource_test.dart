import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/scanner/data/datasources/gemini_remote_datasource.dart';

void main() {
  group('GeminiRemoteDatasource Tests', () {
    test('throws StateError when no API key is configured', () async {
      final datasource = GeminiRemoteDatasource(
        apiKeyResolver: () async => '',
      );

      final dummyBytes = Uint8List.fromList([0, 1, 2, 3]);

      expect(
        () => datasource.analyzeFoodImage(dummyBytes),
        throwsA(isA<StateError>()),
      );
    });
  });
}
