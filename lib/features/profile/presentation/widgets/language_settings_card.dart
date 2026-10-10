import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/services/locale_service.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Card allowing users to switch application language (System, VI, EN).
class LanguageSettingsCard extends ConsumerWidget {
  const LanguageSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(appLanguageProvider);
    final l10n = context.l10n;

    final currentLabel = switch (currentLang) {
      AppLanguage.system => l10n.systemLanguage,
      AppLanguage.vietnamese => l10n.vietnamese,
      AppLanguage.english => l10n.english,
    };

    final currentFlag = switch (currentLang) {
      AppLanguage.system => '🌐',
      AppLanguage.vietnamese => '🇻🇳',
      AppLanguage.english => '🇺🇸',
    };

    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showLanguagePicker(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.clayLunch,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  currentFlag,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.language,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentLang = ref.read(appLanguageProvider);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return ClaySheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.languageSelect,
                textAlign: TextAlign.center,
                style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
              ),
              const SizedBox(height: 16),
              _LanguageOptionTile(
                flag: '🌐',
                title: l10n.systemLanguage,
                isSelected: currentLang == AppLanguage.system,
                onTap: () {
                  ref.read(appLanguageProvider.notifier).setLanguage(AppLanguage.system);
                  Navigator.of(sheetContext).pop();
                },
              ),
              const SizedBox(height: 8),
              _LanguageOptionTile(
                flag: '🇻🇳',
                title: l10n.vietnamese,
                isSelected: currentLang == AppLanguage.vietnamese,
                onTap: () {
                  ref.read(appLanguageProvider.notifier).setLanguage(AppLanguage.vietnamese);
                  Navigator.of(sheetContext).pop();
                },
              ),
              const SizedBox(height: 8),
              _LanguageOptionTile(
                flag: '🇺🇸',
                title: l10n.english,
                isSelected: currentLang == AppLanguage.english,
                onTap: () {
                  ref.read(appLanguageProvider.notifier).setLanguage(AppLanguage.english);
                  Navigator.of(sheetContext).pop();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.flag,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.clayMint : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.brandGreen : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.brandGreen,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
