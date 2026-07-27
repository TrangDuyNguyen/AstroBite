import 'dart:typed_data';
import '../../data/models/scan_result_dto.dart';

abstract class FoodScanRepository {
  Future<int> getTodayScanCount(String userId, String date);
  Future<void> incrementScanCount(String userId, String date);
  Future<ScanResultDto?> scanFoodImage(Uint8List imageBytes);
}
