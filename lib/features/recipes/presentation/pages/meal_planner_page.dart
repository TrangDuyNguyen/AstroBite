import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/meal_plan_controller.dart';
import '../widgets/meal_plan_day_strip.dart';
import '../widgets/meal_plan_section_card.dart';
import '../widgets/meal_plan_summary_card.dart';

const _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

@RoutePage()
class MealPlannerPage extends ConsumerWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ClayAppBar(
        title: 'Kế Hoạch Bữa Ăn',
        subtitle: 'Lên lịch dinh dưỡng 7 ngày',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppValues.spacing12),
            child: ClayIconButton(
              size: 40,
              borderRadius: 14,
              icon: Icons.menu_book_rounded,
              tooltip: 'Kho công thức',
              iconColor: AppColors.primary,
              backgroundColor: AppColors.surfaceContainer,
              onPressed: () => context.router.push(const RecipesRoute()),
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          SizedBox(height: AppValues.spacing8),
          MealPlanDayStrip(),
          SizedBox(height: AppValues.spacing12),
          Expanded(child: _MealPlannerBody()),
        ],
      ),
    );
  }
}

class _MealPlannerBody extends ConsumerWidget {
  const _MealPlannerBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedPlanDateProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final userId = (user?.uid.isNotEmpty == true) ? user!.uid : 'guest_user';
    final key = (userId: userId, date: date);
    final itemsAsync = ref.watch(mealPlanItemsProvider(key));

    return itemsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
        children: List.generate(
          4,
          (_) => const ClaySkeletonLoader(height: 90, borderRadius: 20),
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: AppColors.error,
              ),
              const SizedBox(height: AppValues.spacing8),
              Text(
                'Lỗi tải kế hoạch: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: AppValues.spacing12),
              ClayButton(
                text: 'Thử Lại',
                icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                onPressed: () => ref.invalidate(mealPlanItemsProvider(key)),
              ),
            ],
          ),
        ),
      ),
      data: (items) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
          children: [
            MealPlanSummaryCard(items: items),
            const SizedBox(height: AppValues.spacing20),
            ..._mealTypes.map(
              (type) => MealPlanSectionCard(
                userId: userId,
                mealType: type,
                items: items.where((i) => i.mealType == type).toList(),
                date: date,
              ),
            ),
            const SizedBox(height: AppValues.spacing32),
          ],
        );
      },
    );
  }
}
