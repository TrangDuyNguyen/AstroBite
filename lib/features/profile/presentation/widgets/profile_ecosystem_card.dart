import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/services/gemini_api_key_service.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/shared/widgets/gemini_api_key_dialog.dart';
import 'home_widget_guide_sheet.dart';

class ProfileEcosystemCard extends ConsumerWidget {
  const ProfileEcosystemCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.geminiAiConfig,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 20),
                tooltip: l10n.apiKeySettings,
                onPressed: () => GeminiApiKeyDialog.show(context),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Gemini API Key Tile
          Consumer(
            builder: (context, ref, _) {
              final keyState = ref.watch(geminiApiKeyServiceProvider);
              final title = keyState.isUsingCustomKey
                  ? '${l10n.customKeyPrefix}${keyState.maskedActiveKey}'
                  : keyState.hasKey
                      ? l10n.aiActive
                      : l10n.aiNotConfigured;
              final subtitle = keyState.isUsingCustomKey
                  ? l10n.usingCustomKeyDesc
                  : keyState.hasKey
                      ? l10n.aiReadyDesc
                      : l10n.addKeyFreeDesc;

              return _MenuTile(
                icon: '🔑',
                title: title,
                subtitle: subtitle,
                iconBg: keyState.hasKey ? AppColors.clayMint : AppColors.claySnack,
                onTap: () => GeminiApiKeyDialog.show(context),
              );
            },
          ),

          const _TileDivider(),

          // AI Coach
          _MenuTile(
            icon: '🤖',
            title: l10n.aiCoach,
            subtitle: l10n.aiCoachDesc,
            iconBg: AppColors.clayLunch,
            onTap: () => context.router.push(const CoachRoute()),
          ),

          const _TileDivider(),

          // Health Integration
          _MenuTile(
            icon: '🏃',
            title: l10n.healthConnection,
            subtitle: l10n.healthConnectionDesc,
            iconBg: AppColors.clayMint,
            onTap: () => context.router.push(const HealthConnectionRoute()),
          ),

          const _TileDivider(),

          // Home Widget
          _MenuTile(
            icon: '📱',
            title: l10n.homeWidget,
            subtitle: l10n.homeWidgetDesc,
            iconBg: AppColors.clayBreakfast,
            onTap: () => HomeWidgetGuideSheet.show(context),
          ),

          const _TileDivider(),

          // Recipe Catalog
          _MenuTile(
            icon: '🍲',
            title: l10n.recipeCatalog,
            subtitle: l10n.recipeCatalogDesc,
            iconBg: AppColors.clayLunch,
            onTap: () => context.router.push(const RecipesRoute()),
          ),

          const _TileDivider(),

          // Meal Planner
          _MenuTile(
            icon: '📅',
            title: l10n.mealPlanner,
            subtitle: l10n.mealPlannerDesc,
            iconBg: AppColors.clayBreakfast,
            onTap: () => context.router.push(const MealPlannerRoute()),
          ),

          const _TileDivider(),

          // Social Guilds
          _MenuTile(
            icon: '🪐',
            title: l10n.guilds,
            subtitle: l10n.guildsDesc,
            iconBg: AppColors.clayMint,
            onTap: () => context.router.push(const GuildRoute()),
          ),
        ],
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(color: Color(0xFFF0EFEB), height: 1),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final Color iconBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
