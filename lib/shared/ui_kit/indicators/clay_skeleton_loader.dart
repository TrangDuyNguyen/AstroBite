import 'dart:async';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';

/// Claymorphic shimmer loading placeholder with Warm Milk base (#F0EFEB)
/// and soft outline border.
class ClaySkeletonLoader extends StatelessWidget {
  const ClaySkeletonLoader({
    super.key,
    this.height = 56,
    this.width = double.infinity,
    this.borderRadius = 16.0,
  });

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: AppValues.spacing12),
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
    );
  }
}

/// Shimmer loader displayed during AI scan processing with rotating tips.
class ClayScanLoader extends StatefulWidget {
  const ClayScanLoader({super.key});

  @override
  State<ClayScanLoader> createState() => _ClayScanLoaderState();
}

class _ClayScanLoaderState extends State<ClayScanLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  int _tipIndex = 0;
  Timer? _tipTimer;

  static const _tipCount = 5;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _tipTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) setState(() => _tipIndex = (_tipIndex + 1) % _tipCount);
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
    final tips = [
      context.l10n.tipWater,
      context.l10n.tipVeggies,
      context.l10n.tipProtein,
      context.l10n.tipMealTiming,
      context.l10n.tipExercise,
    ];

    return Padding(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: AppValues.spacing24),
          Text(
            context.l10n.analyzingFood,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppValues.spacing16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              tips[_tipIndex % tips.length],
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

/// Backward compatibility aliases
typedef SkeletonLoader = ClaySkeletonLoader;
typedef ScanSkeletonLoader = ClayScanLoader;
