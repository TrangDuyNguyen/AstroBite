import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
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
        final isMissingKey = message.contains('Chưa cấu hình Gemini API Key');
        final isInvalidKey = message.contains('API_KEY_INVALID') ||
            message.contains('API key not valid') ||
            message.contains('firebasevertexai') ||
            message.contains('Firebase AI Logic API') ||
            message.contains('disabled');
            
        if (isMissingKey || isInvalidKey) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.vpn_key_rounded, color: AppColors.tertiary),
                  const SizedBox(width: AppValues.spacing8),
                  Text(isInvalidKey ? 'Gemini API Key Không Hợp Lệ' : 'Cần Gemini API Key'),
                ],
              ),
              content: Text(
                isInvalidKey 
                    ? 'Key API bạn đang sử dụng không hợp lệ hoặc đã hết hạn.\n\nVui lòng kiểm tra lại Key trong file .env hoặc tạo Key mới (phải bắt đầu bằng AIzaSy...) từ Google AI Studio.'
                    : 'Để quét món ăn bằng AI miễn phí (không cần thẻ tín dụng), bạn cần cài đặt Gemini API Key từ Google AI Studio (aistudio.google.com).\n\nBạn có thể dán Key ngay bây giờ hoặc sử dụng tính năng Nhập tay.',
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppValues.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.outline.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F6FD),
                    borderRadius: BorderRadius.circular(AppValues.radius12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                  ),
                  child: const Clay3DStar(size: 22),
                ),
                const SizedBox(width: AppValues.spacing12),
                Text(
                  'Mẹo chụp ảnh món ăn chuẩn AI',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing16),
            const _TipItem(
              icon: Icons.lightbulb_rounded,
              badgeColor: Color(0xFFFFF7ED),
              iconColor: AppColors.tertiary,
              text: 'Đảm bảo đủ ánh sáng, tránh bóng đổ tối che khuất thức ăn.',
            ),
            const SizedBox(height: AppValues.spacing12),
            const _TipItem(
              icon: Icons.crop_free_rounded,
              badgeColor: Color(0xFFE5F6FD),
              iconColor: AppColors.primary,
              text: 'Đặt trọn vẹn đĩa ăn vào trong khung ngắm trung tâm.',
            ),
            const SizedBox(height: AppValues.spacing12),
            const _TipItem(
              icon: Icons.restaurant_rounded,
              badgeColor: Color(0xFFE8F9D8),
              iconColor: AppColors.brandGreen,
              text: 'Nếu đĩa có nhiều món, chụp góc từ trên xuống (top-down view).',
            ),
            const SizedBox(height: AppValues.spacing20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppValues.spacing48),
                  ),
                  elevation: 3,
                  shadowColor: AppColors.brandGreen.withValues(alpha: 0.4),
                ),
                child: const Text(
                  'Đã hiểu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
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
        backgroundColor: AppColors.surface.withValues(alpha: 0.85),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: ClayIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              size: 40,
              borderRadius: 14,
              tooltip: 'Quay lại',
              onPressed: () => context.router.maybePop(),
            ),
          ),
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
                const Clay3DStar(size: 16),
              ],
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: Color(0xFF0284C7),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Gemini Vision AI 2.0 • Active',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF0369A1),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ClayIconButton(
            icon: _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            size: 40,
            borderRadius: 14,
            backgroundColor: _isTorchOn ? const Color(0xFFFFF7ED) : AppColors.surfaceContainer,
            iconColor: _isTorchOn ? AppColors.tertiary : AppColors.onSurfaceVariant,
            tooltip: 'Đèn Flash',
            onPressed: _toggleTorch,
          ),
          const SizedBox(width: AppValues.spacing8),
          ClayIconButton(
            icon: Icons.help_outline_rounded,
            size: 40,
            borderRadius: 14,
            iconColor: AppColors.onSurfaceVariant,
            tooltip: 'Mẹo quét',
            onPressed: _showScanningTips,
          ),
          const SizedBox(width: 12),
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
                          horizontal: AppValues.spacing16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isOverLimit
                              ? const Color(0xFFFFF1F2)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(AppValues.spacing48),
                          border: Border.all(
                            color: isOverLimit
                                ? const Color(0xFFFECDD3)
                                : const Color(0xFFBBF7D0),
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A1E2337),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isOverLimit
                                ? const ClayMorphIcon(
                                    icon: Icons.error_outline_rounded,
                                    size: 15,
                                    color: AppColors.error,
                                  )
                                : const Clay3DStar(size: 15),
                            const SizedBox(width: 6),
                            Text(
                              isOverLimit
                                  ? 'Đã hết lượt quét hôm nay (10/10)'
                                  : 'Còn lại $remaining/${AppValues.maxDailyScans} lượt quét hôm nay',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isOverLimit ? AppColors.error : const Color(0xFF15803D),
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

            // Bottom Shutter & Picker Control Panel (Tactile Claymorphic Dock)
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppValues.screenPadding,
                AppValues.spacing16,
                AppValues.screenPadding,
                AppValues.spacing24,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.outline.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C1E2337),
                    blurRadius: 20,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gallery Pick Button (Tactile Ceramic Clay Button)
                  _TactileActionButton(
                    icon: Icons.photo_library_rounded,
                    contractIcon: Icons.photo_library_outlined,
                    iconColor: AppColors.primary,
                    backgroundColor: const Color(0xFFF0F9FF),
                    iconSize: 26,
                    tooltip: 'Chọn từ thư viện',
                    onPressed: isScanning ? null : () => _pickImage(ImageSource.gallery),
                  ),

                  // Big Duolingo 3D Tactile Shutter Button (78pt diameter)
                  _TactileShutterButton(
                    isScanning: isScanning,
                    onTap: _captureOrPickImage,
                  ),

                  // Manual Entry shortcut button (Tactile Ceramic Clay Button)
                  _TactileActionButton(
                    icon: Icons.edit_note_rounded,
                    contractIcon: Icons.edit_note_outlined,
                    iconColor: AppColors.tertiary,
                    backgroundColor: const Color(0xFFFFF7ED),
                    iconSize: 28,
                    tooltip: 'Nhập tay',
                    onPressed: isScanning
                        ? null
                        : () => context.router.push(ManualEntryRoute()),
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
  const _TipItem({
    required this.icon,
    required this.text,
    this.badgeColor,
    this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color? badgeColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = iconColor ?? AppColors.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: badgeColor ?? const Color(0xFFE5F6FD),
            borderRadius: BorderRadius.circular(AppValues.radius12),
            border: Border.all(
              color: effectiveColor.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x081E2337),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: effectiveColor,
            ),
          ),
        ),
        const SizedBox(width: AppValues.spacing12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface,
                  height: 1.35,
                ),
          ),
        ),
      ],
    );
  }
}

/// Tactile Ceramic Clay Button for bottom action controls (Gallery, Manual Entry).
/// Replaces pink buttons with warm white ceramic surface and 3D tactile bevel.
class _TactileActionButton extends StatefulWidget {
  const _TactileActionButton({
    required this.icon,
    this.contractIcon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 26.0,
    this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final IconData? contractIcon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  State<_TactileActionButton> createState() => _TactileActionButtonState();
}

class _TactileActionButtonState extends State<_TactileActionButton> {
  bool _isPressed = false;
  static const double _buttonSize = 54.0;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.5;
    final downShift = _isPressed ? 2.5 : 0.0;

    Widget btn = GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, downShift, 0),
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.onPressed != null
              ? (widget.backgroundColor ?? Colors.white)
              : const Color(0xFFF3F0EA),
          border: Border.all(
            color: const Color(0xFFE2DDD5),
            width: 1.5,
          ),
          boxShadow: widget.onPressed != null
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4CEBF),
                    offset: Offset(0, _isPressed ? 1.0 : bevelDepth),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0x101E2337),
                    offset: Offset(0, _isPressed ? 2.0 : 6.0),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.contractIcon != null)
                IgnorePointer(
                  child: Opacity(
                    opacity: 0.001,
                    child: SizedBox(
                      width: _buttonSize,
                      height: _buttonSize,
                      child: Icon(widget.contractIcon),
                    ),
                  ),
                ),
              ClayMorphIcon(
                icon: widget.icon,
                size: widget.iconSize,
                color: widget.onPressed != null
                    ? (widget.iconColor ?? AppColors.onSurface)
                    : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      btn = Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}

/// 78pt Duolingo 3D Tactile Shutter Button with mechanical press and deep blue bevel.
class _TactileShutterButton extends StatefulWidget {
  const _TactileShutterButton({
    required this.isScanning,
    required this.onTap,
  });

  final bool isScanning;
  final VoidCallback onTap;

  @override
  State<_TactileShutterButton> createState() => _TactileShutterButtonState();
}

class _TactileShutterButtonState extends State<_TactileShutterButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 4.5;
    final downShift = _isPressed ? 3.0 : 0.0;

    return GestureDetector(
      onTapDown: widget.isScanning
          ? null
          : (_) {
              HapticFeedback.mediumImpact();
              setState(() => _isPressed = true);
            },
      onTapUp: widget.isScanning ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.isScanning ? null : () => setState(() => _isPressed = false),
      onTap: widget.isScanning ? null : widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOutCubic,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, downShift)
          ..scale(_isPressed ? 0.92 : 1.0),
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.isScanning
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF38BDF8),
                    AppColors.primary,
                  ],
                ),
          color: widget.isScanning ? AppColors.onSurfaceVariant.withValues(alpha: 0.25) : null,
          boxShadow: widget.isScanning
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF0284C7),
                    offset: Offset(0, _isPressed ? 1.5 : bevelDepth),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    offset: Offset(0, _isPressed ? 3 : 8),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: Center(
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.85),
                width: 3,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const IgnorePointer(
                    child: Opacity(
                      opacity: 0.001,
                      child: SizedBox(
                        width: 62,
                        height: 62,
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                  widget.isScanning
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Clay3DCamera(size: 38),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
