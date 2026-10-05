import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Dịch vụ xuất Widget thành Ảnh (PNG) và chia sẻ qua OS Native Share (Gate 4)
class ShareImageService {
  /// Chụp ảnh Widget [globalKey] và gọi Native Share Dialog
  static Future<void> captureAndShare(GlobalKey globalKey, {String shareText = 'Tiến độ ăn uống của tôi trên AstroBite! 🚀'}) async {
    try {
      // 1. Lấy RenderObject từ GlobalKey
      final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // 2. Render Widget thành Image (x3 pixel ratio cho độ nét cao)
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final buffer = byteData.buffer;

      // 3. Lấy thư mục tạm (Cache) để ghi file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/astrobite_share_${DateTime.now().millisecondsSinceEpoch}.png').create();
      
      // 4. Ghi file ảnh ra Storage
      await file.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      // 5. Kích hoạt Native Share Dialog (Android/iOS)
      final xFile = XFile(file.path);
      await SharePlus.instance.share(ShareParams(files: [xFile], text: shareText));



      // 6. Ponytail Clean-up: Xóa file ảnh sau khi share để triệt tiêu Memory Leak & rác Storage
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Lỗi Share Widget: $e');
    }
  }
}
