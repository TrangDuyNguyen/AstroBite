import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'google_sign_in_button.dart';

/// Form card containing input fields, validation, and login actions.
class LoginFormCard extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onGoogleLogin;
  final VoidCallback onForgotPassword;

  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onGoogleLogin,
    required this.onForgotPassword,
  });

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(AppValues.spacing24),
      borderRadius: AppValues.cardRadiusLarge,
      elevation: 6.0,
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClayTextField(
              controller: widget.emailController,
              labelText: AppStrings.email,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.onSurfaceVariant,
              ),
              validator: (v) => v != null && v.contains('@') ? null : 'Email không hợp lệ',
            ),
            const SizedBox(height: AppValues.spacing16),
            ClayTextField(
              controller: widget.passwordController,
              labelText: AppStrings.password,
              obscureText: _obscurePassword,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) => v != null && v.length >= 6 ? null : 'Mật khẩu tối thiểu 6 ký tự',
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onForgotPassword,
                child: const Text(
                  AppStrings.forgotPassword,
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppValues.spacing8),
            ClayButton(
              text: AppStrings.login,
              isLoading: widget.isLoading,
              onPressed: widget.onLogin,
              width: double.infinity,
              height: 52,
            ),
            const SizedBox(height: AppValues.spacing20),
            const Row(
              children: [
                Expanded(child: Divider(color: AppColors.outline)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppValues.spacing16),
                  child: Text(
                    AppStrings.orDivider,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.outline)),
              ],
            ),
            const SizedBox(height: AppValues.spacing20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClayIconButton(
                  size: 56.0,
                  customIcon: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CustomPaint(painter: GoogleLogoPainter()),
                  ),
                  onPressed: widget.isLoading ? null : widget.onGoogleLogin,
                ),
                const SizedBox(width: AppValues.spacing16),
                ClayIconButton(
                  size: 56.0,
                  icon: Icons.apple,
                  iconColor: Colors.black,
                  onPressed: widget.isLoading ? null : () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
