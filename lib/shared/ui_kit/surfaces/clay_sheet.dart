import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Claymorphic Bottom Sheet Container with fat top rounded corners (24pt),
/// pure white clay background, and top pull-bar handle.
class ClaySheet extends StatelessWidget {
  const ClaySheet({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppValues.spacing20),
    this.showHandle = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.outline, width: 1.2),
          left: BorderSide(color: AppColors.outline, width: 1.2),
          right: BorderSide(color: AppColors.outline, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x141E2337),
            offset: Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHandle) ...[
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: AppValues.spacing16),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
