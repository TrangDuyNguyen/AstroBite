import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';

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
    return SearchBar(
      controller: controller,
      hintText: AppStrings.searchFood,
      leading: const Icon(Icons.search),
      onChanged: onChanged,
    );
  }
}
