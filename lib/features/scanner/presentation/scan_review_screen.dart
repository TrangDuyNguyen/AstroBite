import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';

@RoutePage()
class ScanReviewScreen extends ConsumerWidget {
  const ScanReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả phân tích AI')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: Column(
                  children: [
                    Text(
                      '595 kcal',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 36,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Đạm: 34g', style: TextStyle(color: colorScheme.tertiary)),
                        Text('Carbs: 75g', style: TextStyle(color: colorScheme.primary)),
                        Text('Béo: 17g', style: TextStyle(color: colorScheme.secondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppValues.spacing16),
              Text('Các món ăn nhận diện:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppValues.spacing8),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      title: Text('Cơm trắng'),
                      subtitle: Text('200g'),
                      trailing: Text('260 kcal'),
                    ),
                    ListTile(
                      title: Text('Sườn heo nướng'),
                      subtitle: Text('120g'),
                      trailing: Text('290 kcal'),
                    ),
                    ListTile(
                      title: Text('Trứng ốp la'),
                      subtitle: Text('50g'),
                      trailing: Text('45 kcal'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppValues.spacing16),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã lưu nhật ký bữa ăn!')),
                  );
                  context.router.popUntilRoot();
                },
                child: const Text(AppStrings.saveLog),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
