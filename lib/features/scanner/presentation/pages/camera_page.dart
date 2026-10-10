import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/scanner_controller.dart';
import '../widgets/camera_app_bar.dart';
import '../widgets/camera_dock_controls.dart';
import '../widgets/camera_error_dialog_handler.dart';
import '../widgets/camera_quota_badge.dart';
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
      if (cameras.isEmpty) return;

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

      setState(() => _cameraController = controller);
    } catch (_) {
      // Ignored: Gracefully fall back to image picker
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
        // Fallback to local state toggle
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

    CameraErrorDialogHandler.handleResult(
      context: context,
      result: result,
      bytes: bytes,
      onClearPreview: () => setState(() => _previewBytes = null),
      onRetry: _processImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scannerControllerProvider);
    final isScanning = scanState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: CameraAppBar(
        isTorchOn: _isTorchOn,
        onToggleTorch: _toggleTorch,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderInstruction(isScanning),
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
            CameraDockControls(
              isScanning: isScanning,
              onPickImage: _pickImage,
              onCapture: _captureOrPickImage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInstruction(bool isScanning) {
    return Padding(
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
          const CameraQuotaBadge(),
        ],
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
