import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';

/// Guild Header Card showing avatar planet, name, description, member count and invite code.
class GuildHeaderCard extends StatelessWidget {
  const GuildHeaderCard({
    super.key,
    required this.guild,
    required this.onOpenGovernance,
  });

  final Guild guild;
  final VoidCallback onOpenGovernance;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.clayLunch,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Center(
              child: Clay3DPlanet(planet: guild.avatarPlanet, size: 36),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guild.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            guild.description.isNotEmpty
                                ? guild.description
                                : 'Cùng nhau giữ kỷ luật dinh dưỡng',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Governance Settings Button
                    IconButton(
                      key: const Key('guild_settings_button'),
                      icon: const Icon(Icons.settings_outlined, color: AppColors.onSurfaceVariant),
                      tooltip: 'Cài đặt bang hội',
                      onPressed: onOpenGovernance,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.clayMint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${guild.memberCount}/20 Thành viên',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.brandGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const Spacer(),
                    // Copy code button
                    InkWell(
                      key: const Key('copy_invite_code_button'),
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: guild.inviteCode));
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã sao chép mã mời: ${guild.inviteCode}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.outline),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              guild.inviteCode,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
