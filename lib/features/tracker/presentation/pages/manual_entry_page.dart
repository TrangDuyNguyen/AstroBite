import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/shared/widgets/meal_type_chip.dart';
import '../widgets/food_search_bar.dart';

@RoutePage()
class ManualEntryPage extends ConsumerStatefulWidget {
  const ManualEntryPage({super.key});

  @override
  ConsumerState<ManualEntryPage> createState() => _ManualEntryPageState();
}

class _ManualEntryPageState extends ConsumerState<ManualEntryPage> {
  String _selectedMeal = 'lunch';
  String _query = '';

  static const _commonFoods = [
    {'name': 'Phở bò', 'calories': 450, 'protein': 25, 'carbs': 55, 'fat': 12, 'weight': 350},
    {'name': 'Cơm tấm sườn', 'calories': 550, 'protein': 30, 'carbs': 70, 'fat': 16, 'weight': 300},
    {'name': 'Bún chả', 'calories': 480, 'protein': 22, 'carbs': 60, 'fat': 15, 'weight': 320},
    {'name': 'Bánh mì thịt', 'calories': 380, 'protein': 18, 'carbs': 45, 'fat': 14, 'weight': 180},
    {'name': 'Gỏi cuốn (2 cái)', 'calories': 180, 'protein': 10, 'carbs': 28, 'fat': 3, 'weight': 150},
    {'name': 'Ức gà luộc', 'calories': 165, 'protein': 31, 'carbs': 0, 'fat': 3.6, 'weight': 100},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _commonFoods
        : _commonFoods
            .where((f) => (f['name'] as String).toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.manualEntry)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MealTypeChip(
                      mealType: 'breakfast',
                      isSelected: _selectedMeal == 'breakfast',
                      onTap: () => setState(() => _selectedMeal = 'breakfast'),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    MealTypeChip(
                      mealType: 'lunch',
                      isSelected: _selectedMeal == 'lunch',
                      onTap: () => setState(() => _selectedMeal = 'lunch'),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    MealTypeChip(
                      mealType: 'dinner',
                      isSelected: _selectedMeal == 'dinner',
                      onTap: () => setState(() => _selectedMeal = 'dinner'),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                    MealTypeChip(
                      mealType: 'snack',
                      isSelected: _selectedMeal == 'snack',
                      onTap: () => setState(() => _selectedMeal = 'snack'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppValues.spacing16),
              FoodSearchBar(onChanged: (q) => setState(() => _query = q)),
              const SizedBox(height: AppValues.spacing16),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final item = filtered[i];
                    return Card(
                      child: ListTile(
                        title: Text(item['name'] as String),
                        subtitle: Text('${item['weight']}g • ${item['calories']} kcal'),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã thêm ${item['name']} vào $_selectedMeal')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
