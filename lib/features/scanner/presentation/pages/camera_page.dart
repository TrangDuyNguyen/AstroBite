import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import 'package:astrobite/shared/widgets/skeleton_loader.dart';
import '../../domain/usecases/scan_food_usecase.dart';
import '../controllers/scanner_controller.dart';
import '../widgets/scanning_viewfinder.dart';

@RoutePage()
class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  final _imagePicker = ImagePicker();
  Uint8List? _previewBytes;

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.selectionClick();
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() => _previewBytes = bytes);
      await _processImage(bytes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể mở camera/thư viện: $e'),
            action: SnackBarAction(
              label: 'Thử lại',
              onPressed: () => _pickImage(source),
            ),
          ),
        );
      }
    }
  }

  Future<void> _processImage(Uint8List bytes) async {
    final result = await ref.read(scannerControllerProvider.notifier).scanImage(bytes);

    if (!mounted || result == null) return;

    switch (result) {
      case ScanSuccess(:final result):
        context.router.push(ScanReviewRoute(scanResult: result, imageBytes: bytes));
      case QuotaExceeded():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.quotaExceeded)),
        );
      case NotFoodResult():
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Không nhận diện được món ăn'),
            content: const Text(AppStrings.notFood),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Chụp lại'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.router.push(const ManualEntryRoute());
                },
                child: const Text('Nhập tay'),
              ),
            ],
          ),
        );
      case ScanError(:final message):
        if (message.contains('Chưa cấu hình Gemini API Key') ||
            message.contains('API_KEY_INVALID') ||
            message.contains('API key not valid') ||
            message.contains('firebasevertexai') ||
            message.contains('Firebase AI Logic API') ||
            message.contains('disabled')) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.vpn_key_rounded, color: AppColors.tertiary),
                  SizedBox(width: AppValues.spacing8),
                  Text('Cần Gemini API Key'),
                ],
              ),
              content: const Text(
                'Để quét món ăn bằng AI miễn phí (không cần thẻ tín dụng), bạn cần cài đặt Gemini API Key từ Google AI Studio (aistudio.google.com).\n\n'
                'Bạn có thể dán Key ngay bây giờ hoặc sử dụng tính năng Nhập tay.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.router.push(const ManualEntryRoute());
                  },
                  child: const Text('Nhập tay'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Đóng'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    GeminiApiKeyDialog.show(context);
                  },
                  icon: const Icon(Icons.vpn_key, size: 18),
                  label: const Text('Cài đặt Key'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
    }
  }

  void _showScanningTips() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppValues.radius12)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mẹo chụp ảnh món ăn chuẩn AI',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppValues.spacing12),
            const _TipItem(
              icon: Icons.lightbulb_outline,
              text: 'Đảm bảo đủ ánh sáng, tránh bóng đổ tối che khuất thức ăn.',
            ),
            const SizedBox(height: AppValues.spacing8),
            const _TipItem(
              icon: Icons.crop_free,
              text: 'Đặt trọn vẹn đĩa ăn vào trong khung ngắm trung tâm.',
            ),
            const SizedBox(height: AppValues.spacing8),
            const _TipItem(
              icon: Icons.restaurant,
              text: 'Nếu đĩa có nhiều món, chụp góc từ trên xuống (top-down view).',
            ),
            const SizedBox(height: AppValues.spacing16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Đã hiểu'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scannerControllerProvider);
    final isScanning = scanState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(AppStrings.scanFood),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Mẹo quét',
            onPressed: _showScanningTips,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Instruction header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.screenPadding,
                vertical: AppValues.spacing8,
              ),
              child: Text(
                isScanning
                    ? 'Gemini 2.0 Flash đang phân tích món ăn...'
                    : 'Hướng máy ảnh vào đĩa thức ăn và bấm nút chụp',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isScanning ? AppColors.primary : AppColors.onSurfaceVariant,
                      fontWeight: isScanning ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),

            // Scanning Viewfinder area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.spacing16),
                child: isScanning && _previewBytes == null
                    ? const ScanSkeletonLoader()
                    : ScanningViewfinder(
                        isScanning: isScanning,
                        child: _previewBytes != null
                            ? Image.memory(
                                _previewBytes!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
              ),
            ),

            // Scanning loader indicator overlay when image is displayed
            if (isScanning && _previewBytes != null) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
                child: LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainer,
                ),
              ),
              const SizedBox(height: AppValues.spacing8),
            ],

            // Bottom Shutter & Picker Control Panel
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.screenPadding,
                vertical: AppValues.spacing24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppValues.spacing24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gallery Pick Button
                  IconButton.filledTonal(
                    onPressed: isScanning ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    iconSize: 28,
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(AppValues.spacing12),
                    ),
                  ),

                  // Big Glowing Shutter Button (COMP-01 / specs: 72pt diameter)
                  GestureDetector(
                    onTap: isScanning ? null : () => _pickImage(ImageSource.camera),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isScanning
                            ? AppColors.onSurfaceVariant.withValues(alpha: 0.3)
                            : AppColors.primary,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 4,
                        ),
                        boxShadow: isScanning
                            ? null
                            : [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 32,
                          color: isScanning ? AppColors.onSurfaceVariant : Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Manual Entry shortcut button
                  IconButton.filledTonal(
                    onPressed: isScanning
                        ? null
                        : () => context.router.push(const ManualEntryRoute()),
                    icon: const Icon(Icons.edit_note_outlined),
                    iconSize: 28,
                    tooltip: 'Nhập tay',
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(AppValues.spacing12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppValues.spacing12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
