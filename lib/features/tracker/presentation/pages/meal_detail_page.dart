import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';

@RoutePage()
class MealDetailPage extends ConsumerWidget {
  const MealDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết bữa ăn')),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppValues.screenPadding),
          child: Center(
            child: Text('Chi tiết các món ăn trong bữa'),
          ),
        ),
      ),
    );
  }
}
