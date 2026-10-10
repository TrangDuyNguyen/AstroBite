import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Quick actions bar on HomePage: Recipes, 7-day meal planner, and Guild challenge banner.
class HomeQuickActionsBar extends StatelessWidget {
  const HomeQuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionChipButton(
                icon: Icons.menu_book_rounded,
                label: 'Công thức món',
                color: AppColors.primary,
                onTap: () => context.router.push(const RecipesRoute()),
              ),
            ),
            const SizedBox(width: AppValues.spacing12),
            Expanded(
              child: _ActionChipButton(
                icon: Icons.calendar_month_rounded,
                label: 'Kế hoạch 7 ngày',
                color: AppColors.tertiary,
                onTap: () => context.router.push(const MealPlannerRoute()),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing8),
        ClayCard(
          key: const Key('home_guild_banner_card'),
          borderRadius: 16,
          elevation: 2.5,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          onTap: () => context.router.push(const GuildRoute()),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.clayMint,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text('🪐', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Bang Hội Vũ Trụ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.brandGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Thử thách tuần',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.brandGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Lập đội thi đua & cùng nhau gánh vác mục tiêu dinh dưỡng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPrimary = color == AppColors.primary;
    final badgeBg = isPrimary ? const Color(0xFFE5F6FD) : const Color(0xFFFFF2D6);
    final badgeBevel = isPrimary ? const Color(0xFFBCE3F7) : const Color(0xFFF7DEB0);

    return ClayCard(
      onTap: onTap,
      elevation: 3.0,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing12,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badgeBg,
              boxShadow: [
                BoxShadow(
                  color: badgeBevel,
                  offset: const Offset(0, 1.5),
                  blurRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: AppValues.spacing8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
