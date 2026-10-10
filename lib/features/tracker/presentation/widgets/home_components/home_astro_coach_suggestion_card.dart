import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/tracker/domain/daily_summary.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Interactive AstroCoach suggestion card displayed on HomePage.
class HomeAstroCoachSuggestionCard extends StatelessWidget {
  final DailySummary summary;

  const HomeAstroCoachSuggestionCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final needsProtein = summary.totalProteinG < summary.targetProteinG;
    final proteinDiff = summary.targetProteinG - summary.totalProteinG;

    return ClayCard(
      elevation: 3.5,
      borderRadius: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => context.router.push(const CoachRoute()),
      child: Row(
        children: [
          // 1. 3D Ceramic AstroCoach Badge (AstroBot)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFBAE6FD),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF7DD3FC),
                  offset: Offset(0, 2.5),
                  blurRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x200284C7),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 2,
                  child: Container(
                    width: 26,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const Clay3DAstroBot(size: 26),
              ],
            ),
          ),
          const SizedBox(width: AppValues.spacing12),

          // 2. Title & Dynamic Nutritional Advice
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Gợi ý từ AstroCoach',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            letterSpacing: -0.2,
                          ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFDDD6FE),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFC4B5FD),
                            offset: Offset(0, 1.2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Text(
                        'AI COACH',
                        style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w800,
                          fontSize: 8.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
                    ),
                    children: needsProtein
                        ? [
                            const TextSpan(text: 'Cần thêm '),
                            TextSpan(
                              text: '${proteinDiff}g Protein',
                              style: const TextStyle(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: ' để đạt mục tiêu...'),
                          ]
                        : const [
                            TextSpan(text: 'Dinh dưỡng hôm nay '),
                            TextSpan(
                              text: 'đang rất cân bằng',
                              style: TextStyle(
                                color: AppColors.brandGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: ' và tối ưu! 🥑'),
                          ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // 3. Tactile 3D Circular Arrow Button
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF8F6F2),
              border: Border.all(
                color: const Color(0xFFEDE8DD),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFDDD8CE),
                  offset: Offset(0, 1.5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFF78829A),
            ),
          ),
        ],
      ),
    );
  }
}
