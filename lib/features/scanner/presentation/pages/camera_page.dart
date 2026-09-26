import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
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
import '../../domain/scanner_providers.dart';
import '../../domain/usecases/scan_food_usecase.dart';
import '../controllers/scanner_controller.dart';
import '../widgets/scanning_viewfinder.dart';

@RoutePage()
class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage>
    with WidgetsBindingObserver {
  final _imagePicker = ImagePicker();
  CameraController? _cameraController;
  Uint8List? _previewBytes;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _cameraController = null;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      if (cameras.isEmpty) {
        return;
      }

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
      });
    } catch (_) {
      // Ignored
    }
  }

  Future<void> _captureOrPickImage() async {
    HapticFeedback.heavyImpact();
    final controller = _cameraController;
    if (controller != null && controller.value.isInitialized) {
      try {
        final XFile file = await controller.takePicture();
        final bytes = await file.readAsBytes();
        if (!mounted) return;
        setState(() => _previewBytes = bytes);
        await _processImage(bytes);
        return;
      } catch (_) {
        // Fallback to ImagePicker if native capture fails
      }
    }
    await _pickImage(ImageSource.camera);
  }

  Future<void> _toggleTorch() async {
    HapticFeedback.selectionClick();
    final controller = _cameraController;
    if (controller != null && controller.value.isInitialized) {
      try {
        final nextTorch = !_isTorchOn;
        await controller.setFlashMode(
          nextTorch ? FlashMode.torch : FlashMode.off,
        );
        if (mounted) setState(() => _isTorchOn = nextTorch);
        return;
      } catch (_) {
        // Ignored, fallback to local state toggle
      }
    }
    setState(() => _isTorchOn = !_isTorchOn);
  }

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.selectionClick();
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        maxWidth: 720,
        maxHeight: 720,
        imageQuality: 75,
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
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _previewBytes = null);
                },
                child: const Text('Chụp lại'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.router.push(ManualEntryRoute());
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
                    context.router.push(ManualEntryRoute());
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
        } else if (message.contains('503') ||
            message.contains('UNAVAILABLE') ||
            message.contains('high demand') ||
            message.contains('capacity')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 5),
              content: const Text(
                'Máy chủ AI hiện đang quá tải (503). Vui lòng bấm "Thử lại" sau giây lát.',
              ),
              action: SnackBarAction(
                label: 'Thử lại',
                textColor: AppColors.primary,
                onPressed: () {
                  if (_previewBytes != null) {
                    _processImage(_previewBytes!);
                  }
                },
              ),
            ),
          );
        } else {
          final friendlyMessage = _formatErrorMessage(message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(friendlyMessage),
              action: _previewBytes != null
                  ? SnackBarAction(
                      label: 'Thử lại',
                      textColor: AppColors.primary,
                      onPressed: () => _processImage(_previewBytes!),
                    )
                  : null,
            ),
          );
        }
    }
  }

  String _formatErrorMessage(String rawMessage) {
    if (rawMessage.contains('GenerativeAIException') || rawMessage.contains('{')) {
      if (rawMessage.contains('503') || rawMessage.contains('UNAVAILABLE')) {
        return 'Máy chủ AI tạm thời quá tải. Vui lòng thử lại sau giây lát.';
      }
      if (rawMessage.contains('429') || rawMessage.contains('RESOURCE_EXHAUSTED')) {
        return 'Đã vượt giới hạn gọi AI tạm thời. Vui lòng thử lại sau ít phút.';
      }
      return 'Không thể kết nối đến máy chủ AI. Vui lòng thử lại.';
    }
    return rawMessage;
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
        backgroundColor: AppColors.surface.withValues(alpha: 0.75),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppStrings.scanFood,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: AppValues.spacing8),
                const Icon(Icons.auto_awesome, size: 14, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF38BDF8),
                  ),
                ),
                const SizedBox(width: AppValues.spacing4),
                const Text(
                  'Gemini Vision AI 2.0 • Active',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF38BDF8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: _isTorchOn ? AppColors.tertiary : AppColors.onSurfaceVariant,
            ),
            tooltip: 'Đèn Flash',
            onPressed: _toggleTorch,
          ),
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
            // Instruction header & Daily Quota Indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.screenPadding,
                vertical: AppValues.spacing8,
              ),
              child: Column(
                children: [
                  Text(
                    isScanning
                        ? '✨ AI đang giải mã cấu trúc món ăn...'
                        : 'Hướng máy ảnh vào đĩa thức ăn và bấm nút chụp',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isScanning ? AppColors.primary : AppColors.onSurfaceVariant,
                          fontWeight: isScanning ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                  const SizedBox(height: AppValues.spacing8),
                  Consumer(
                    builder: (context, ref, _) {
                      final scanCountAsync = ref.watch(todayScanCountProvider);
                      final count = scanCountAsync.valueOrNull ?? 0;
                      final remaining = (AppValues.maxDailyScans - count).clamp(0, AppValues.maxDailyScans);
                      final isOverLimit = count >= AppValues.maxDailyScans;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppValues.spacing12,
                          vertical: AppValues.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: isOverLimit
                              ? AppColors.error.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppValues.radius12),
                          border: Border.all(
                            color: isOverLimit
                                ? AppColors.error.withValues(alpha: 0.4)
                                : AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: isOverLimit ? AppColors.error : AppColors.primary,
                            ),
                            const SizedBox(width: AppValues.spacing4),
                            Text(
                              isOverLimit
                                  ? 'Đã hết lượt quét hôm nay (10/10)'
                                  : 'Còn lại $remaining/${AppValues.maxDailyScans} lượt quét hôm nay',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isOverLimit ? AppColors.error : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
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
                        child: _buildViewfinderChild(),
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
                    onTap: isScanning ? null : _captureOrPickImage,
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
                        : () => context.router.push(ManualEntryRoute()),
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

  Widget? _buildViewfinderChild() {
    if (_previewBytes != null) {
      return Image.memory(
        _previewBytes!,
        fit: BoxFit.cover,
      );
    }

    final controller = _cameraController;
    if (controller != null && controller.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.radius12),
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.previewSize?.height ?? 1,
              height: controller.value.previewSize?.width ?? 1,
              child: CameraPreview(controller),
            ),
          ),
        ),
      );
    }

    return null;
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
