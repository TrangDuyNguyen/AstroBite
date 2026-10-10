import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Bottom Shutter & Picker Control Panel (Tactile Claymorphic Dock).
class CameraDockControls extends StatelessWidget {
  const CameraDockControls({
    super.key,
    required this.isScanning,
    required this.onPickImage,
    required this.onCapture,
  });

  final bool isScanning;
  final ValueChanged<ImageSource> onPickImage;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.spacing16,
        AppValues.screenPadding,
        AppValues.spacing24,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.outline.withValues(alpha: 0.5),
            width: 1.2,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1E2337),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gallery Pick Button (Tactile Ceramic Clay Button)
          _TactileActionButton(
            icon: Icons.photo_library_rounded,
            contractIcon: Icons.photo_library_outlined,
            iconColor: AppColors.primary,
            backgroundColor: const Color(0xFFF0F9FF),
            iconSize: 26,
            tooltip: context.l10n.selectFromGallery,
            onPressed: isScanning ? null : () => onPickImage(ImageSource.gallery),
          ),

          // Big Duolingo 3D Tactile Shutter Button (78pt diameter)
          _TactileShutterButton(
            isScanning: isScanning,
            onTap: onCapture,
          ),

          // Manual Entry shortcut button (Tactile Ceramic Clay Button)
          _TactileActionButton(
            icon: Icons.edit_note_rounded,
            contractIcon: Icons.edit_note_outlined,
            iconColor: AppColors.tertiary,
            backgroundColor: const Color(0xFFFFF7ED),
            iconSize: 28,
            tooltip: context.l10n.manualEntryTooltip,
            onPressed: isScanning
                ? null
                : () => context.router.push(ManualEntryRoute()),
          ),
        ],
      ),
    );
  }
}

/// Tactile Ceramic Clay Button for bottom action controls (Gallery, Manual Entry).
class _TactileActionButton extends StatefulWidget {
  const _TactileActionButton({
    required this.icon,
    this.contractIcon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 26.0,
    this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final IconData? contractIcon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  State<_TactileActionButton> createState() => _TactileActionButtonState();
}

class _TactileActionButtonState extends State<_TactileActionButton> {
  bool _isPressed = false;
  static const double _buttonSize = 54.0;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.5;
    final downShift = _isPressed ? 2.5 : 0.0;

    Widget btn = GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, downShift, 0),
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.onPressed != null
              ? (widget.backgroundColor ?? Colors.white)
              : const Color(0xFFF3F0EA),
          border: Border.all(
            color: const Color(0xFFE2DDD5),
            width: 1.5,
          ),
          boxShadow: widget.onPressed != null
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4CEBF),
                    offset: Offset(0, _isPressed ? 1.0 : bevelDepth),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0x101E2337),
                    offset: Offset(0, _isPressed ? 2.0 : 6.0),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.contractIcon != null)
                IgnorePointer(
                  child: Opacity(
                    opacity: 0.001,
                    child: SizedBox(
                      width: _buttonSize,
                      height: _buttonSize,
                      child: Icon(widget.contractIcon),
                    ),
                  ),
                ),
              ClayMorphIcon(
                icon: widget.icon,
                size: widget.iconSize,
                color: widget.onPressed != null
                    ? (widget.iconColor ?? AppColors.onSurface)
                    : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      btn = Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}

/// 78pt Duolingo 3D Tactile Shutter Button with mechanical press and deep blue bevel.
class _TactileShutterButton extends StatefulWidget {
  const _TactileShutterButton({
    required this.isScanning,
    required this.onTap,
  });

  final bool isScanning;
  final VoidCallback onTap;

  @override
  State<_TactileShutterButton> createState() => _TactileShutterButtonState();
}

class _TactileShutterButtonState extends State<_TactileShutterButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 4.5;
    final downShift = _isPressed ? 3.0 : 0.0;

    return GestureDetector(
      onTapDown: widget.isScanning
          ? null
          : (_) {
              HapticFeedback.mediumImpact();
              setState(() => _isPressed = true);
            },
      onTapUp: widget.isScanning ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.isScanning ? null : () => setState(() => _isPressed = false),
      onTap: widget.isScanning ? null : widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOutCubic,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, downShift)
          ..scale(_isPressed ? 0.92 : 1.0),
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.isScanning
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF38BDF8),
                    AppColors.primary,
                  ],
                ),
          color: widget.isScanning ? AppColors.onSurfaceVariant.withValues(alpha: 0.25) : null,
          boxShadow: widget.isScanning
              ? null
              : [
                  BoxShadow(
                    color: const Color(0xFF0284C7),
                    offset: Offset(0, _isPressed ? 1.5 : bevelDepth),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    offset: Offset(0, _isPressed ? 3 : 8),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: Center(
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.85),
                width: 3,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const IgnorePointer(
                    child: Opacity(
                      opacity: 0.001,
                      child: SizedBox(
                        width: 62,
                        height: 62,
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                  widget.isScanning
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Clay3DCamera(size: 38),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
