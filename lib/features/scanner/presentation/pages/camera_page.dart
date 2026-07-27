import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/shared/widgets/skeleton_loader.dart';
import '../../domain/usecases/scan_food_usecase.dart';
import '../controllers/scanner_controller.dart';

@RoutePage()
class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  final _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (file == null) return;
    final bytes = await file.readAsBytes();
    await _processImage(bytes);
  }

  Future<void> _processImage(Uint8List bytes) async {
    final result = await ref.read(scannerControllerProvider.notifier).scanImage(bytes);

    if (!mounted || result == null) return;

    switch (result) {
      case ScanSuccess():
        context.router.push(const ScanReviewRoute());
      case QuotaExceeded():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.quotaExceeded)),
        );
      case NotFoodResult():
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Thông báo'),
            content: const Text(AppStrings.notFood),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      case ScanError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scannerControllerProvider);

    if (scanState.isLoading) {
      return const Scaffold(
        body: SafeArea(child: ScanSkeletonLoader()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.scanFood)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppValues.spacing24),
              Text(
                'Chụp ảnh bữa ăn của bạn',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppValues.spacing8),
              Text(
                'Gemini AI sẽ tự động phân tích calo và macronutrients',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppValues.spacing48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_outlined),
                    label: const Text('Máy ảnh'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Thư viện'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
