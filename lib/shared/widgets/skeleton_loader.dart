import 'dart:async';
import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/constants/app_values.dart';

/// Skeleton loader displayed during AI scan processing.
/// Shows shimmer animation with rotating nutrition tips.
class ScanSkeletonLoader extends StatefulWidget {
  const ScanSkeletonLoader({super.key});

  @override
  State<ScanSkeletonLoader> createState() => _ScanSkeletonLoaderState();
}

class _ScanSkeletonLoaderState extends State<ScanSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  int _tipIndex = 0;
  Timer? _tipTimer;

  static const _tips = [
    '💡 Uống đủ 2 lít nước mỗi ngày giúp trao đổi chất tốt hơn.',
    '🥗 Rau xanh chứa ít calo nhưng giàu chất xơ và vitamin.',
    '🍳 Protein giúp no lâu và duy trì cơ bắp.',
    '⏰ Ăn đúng giờ giúp cơ thể điều hòa năng lượng hiệu quả.',
    '🏃 Kết hợp vận động 30 phút mỗi ngày để duy trì sức khỏe.',
  ];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _tipTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _tipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: AppValues.spacing24),
          Text(
            'Đang phân tích món ăn...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppValues.spacing16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _tips[_tipIndex],
              key: ValueKey(_tipIndex),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Generic shimmer placeholder box for list loading states.
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key, this.height = 56, this.width = double.infinity});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: AppValues.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppValues.cardRadius),
      ),
    );
  }
}
