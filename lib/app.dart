import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class AstroBiteApp extends ConsumerStatefulWidget {
  const AstroBiteApp({super.key});

  @override
  ConsumerState<AstroBiteApp> createState() => _AstroBiteAppState();
}

class _AstroBiteAppState extends ConsumerState<AstroBiteApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AstroBite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
