import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import '../domain/tracker_providers.dart';
import 'widgets/daily_summary_card.dart';
import 'widgets/meal_section.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(todaySummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.todayOverview),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.router.push(const ProfileRoute()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          children: [
            DailySummaryCard(summary: summary),
            const SizedBox(height: AppValues.spacing24),
            Text(
              AppStrings.nutritionLog,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppValues.spacing12),
            MealSection(
              mealType: 'breakfast',
              summary: summary,
              onAddTap: () => context.router.push(const ManualEntryRoute()),
            ),
            MealSection(
              mealType: 'lunch',
              summary: summary,
              onAddTap: () => context.router.push(const ManualEntryRoute()),
            ),
            MealSection(
              mealType: 'dinner',
              summary: summary,
              onAddTap: () => context.router.push(const ManualEntryRoute()),
            ),
            MealSection(
              mealType: 'snack',
              summary: summary,
              onAddTap: () => context.router.push(const ManualEntryRoute()),
            ),
          ],
        ),
      ),
    );
  }
}
