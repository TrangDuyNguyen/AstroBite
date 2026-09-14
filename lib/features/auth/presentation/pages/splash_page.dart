import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import '../../domain/auth_providers.dart';

@RoutePage()
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) async {
      final user = next.value;
      if (user != null) {
        final repo = ref.read(profileRepositoryProvider);
        final profile = await repo.getProfile(user.uid);
        if (context.mounted) {
          if (profile != null && profile.isOnboardingCompleted) {
            context.router.replaceAll([const ShellRoute()]);
          } else {
            context.router.replaceAll([const OnboardingRoute()]);
          }
        }
      } else {
        context.router.replaceAll([const LoginRoute()]);
      }
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🌌 AstroBite', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
