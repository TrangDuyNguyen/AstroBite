import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/widgets/skeleton_loader.dart';
import '../domain/scan_food_usecase.dart';
import '../domain/scanner_providers.dart';

@RoutePage()
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  final _imagePicker = ImagePicker();
  bool _isProcessing = false;

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
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      if (mounted) context.router.popForced();
      return;
    }

    setState(() => _isProcessing = true);

    final useCase = ref.read(scanFoodUseCaseProvider);
    final result = await useCase.execute(
      userId: user.uid,
      imageBytes: bytes,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

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
    if (_isProcessing) {
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
