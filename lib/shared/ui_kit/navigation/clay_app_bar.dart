import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../buttons/clay_icon_button.dart';

/// Tactile Claymorphic AppBar adhering to Duolingo 2D/3D design language.
///
/// Features:
/// - Tactile squircle back button ([ClayIconButton]) with mechanical press
/// - Chunky, friendly typography ([GoogleFonts.outfit]) with high-contrast slate text
/// - Customizable actions list with tactile icon buttons
/// - Optional subtitle or status pill
/// - Zero elevation on Warm Milk canvas with transparent surface tint
class ClayAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ClayAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.bottom,
    this.height = kToolbarHeight + 4,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton && canPop) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: ClayIconButton(
            size: 40,
            borderRadius: 14,
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: context.l10n.back,
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leadingWidget,
      leadingWidth: leadingWidget != null ? 56 : 0,
      toolbarHeight: height,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: AppColors.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ),
            ]
          : null,
      bottom: bottom,
    );
  }
}
