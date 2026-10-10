import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Claymorphic Search Bar with 16pt corners, pure white clay container,
/// search icon prefix and clear button.
class ClaySearchBar extends StatelessWidget {
  const ClaySearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.hintText,
    this.onClear,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outline,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081E2337),
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Color(0x101E2337),
            offset: Offset(0, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText ?? context.l10n.searchFood,
          hintStyle: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppColors.onSurfaceVariant,
                  onPressed: () {
                    controller!.clear();
                    onChanged('');
                    onClear?.call();
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppValues.spacing16,
            vertical: AppValues.spacing12,
          ),
        ),
      ),
    );
  }
}
