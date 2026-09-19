import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Celestial primary submit button with tactile spring scale effect and FilledButton semantics.
class AuthSubmitButton extends StatefulWidget {
  const AuthSubmitButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  State<AuthSubmitButton> createState() => _AuthSubmitButtonState();
}

class _AuthSubmitButtonState extends State<AuthSubmitButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        height: AppValues.minTouchTarget,
        child: Listener(
          onPointerDown: (_) {
            if (!widget.isLoading && widget.onPressed != null) {
              setState(() => _isPressed = true);
            }
          },
          onPointerUp: (_) {
            if (_isPressed) setState(() => _isPressed = false);
          },
          onPointerCancel: (_) {
            if (_isPressed) setState(() => _isPressed = false);
          },
          child: FilledButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppValues.cardRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppValues.spacing16),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
