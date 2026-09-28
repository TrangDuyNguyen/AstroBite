import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Claymorphic Food Search Bar styled in signature Duolingo 2D/3D (Solar Fresh) aesthetic.
class FoodSearchBar extends StatelessWidget {
  const FoodSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return ClaySearchBar(
      controller: controller,
      hintText: AppStrings.searchFood,
      onChanged: onChanged,
    );
  }
}
