import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/features/widgets/widget_sync_service.dart';
import 'package:astrobite/l10n/app_localizations.dart';
import 'core/services/locale_service.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widgetSyncServiceProvider).initDeepLink((uri) {
        if (uri != null) {
          final isScanner = uri.host == 'scanner' || uri.path.contains('scanner');
          if (isScanner) {
            _appRouter.push(const CameraRoute());
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'AstroBite',
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: _appRouter.config(),
    );
  }
}
