import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Skeleton loader for the recipes list while loading.
class RecipesLoadingView extends StatelessWidget {
  const RecipesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.spacing12),
      itemBuilder: (_, __) => const ClaySkeletonLoader(
        height: 100,
        borderRadius: 20,
      ),
    );
  }
}

/// Friendly empty state displayed when the user has no recipes yet.
class RecipesEmptyStateView extends StatelessWidget {
  const RecipesEmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Clay3DCookbook(size: 72),
            const SizedBox(height: AppValues.spacing20),
            Text(
              'Chưa có công thức nào',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: AppValues.spacing8),
            Text(
              'Sáng tạo và lưu lại các món ăn yêu thích với đầy đủ tính toán Calories & Macros chuẩn xác.\nNhấn nút bên dưới để bắt đầu!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view displayed when recipes cannot be loaded from the repository.
class RecipesErrorStateView extends StatelessWidget {
  const RecipesErrorStateView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: Text(
          'Lỗi tải công thức: $message',
          style: const TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
