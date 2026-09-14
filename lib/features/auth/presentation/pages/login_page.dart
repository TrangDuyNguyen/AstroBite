import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import '../controllers/login_controller.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/google_sign_in_button.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _navigatePostAuth() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;
    final repo = ref.read(profileRepositoryProvider);
    final profile = await repo.getProfile(user.uid);
    if (!mounted) return;
    if (profile != null && profile.isOnboardingCompleted) {
      context.router.replaceAll([const ShellRoute()]);
    } else {
      context.router.replaceAll([const OnboardingRoute()]);
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(loginControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted) {
      await _navigatePostAuth();
    }
  }

  Future<void> _handleGoogleLogin() async {
    final success =
        await ref.read(loginControllerProvider.notifier).loginWithGoogle();
    if (success && mounted) {
      await _navigatePostAuth();
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final resetEmailController =
        TextEditingController(text: _emailController.text.trim());
    final resetFormKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainer,
          title: const Text(
            AppStrings.resetPassword,
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: resetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nhập địa chỉ email của bạn để nhận liên kết đặt lại mật khẩu.',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppValues.spacing16),
                TextFormField(
                  controller: resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.onSurface),
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppValues.cardRadius),
                    ),
                  ),
                  validator: (v) =>
                      v != null && v.contains('@') ? null : 'Email không hợp lệ',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Hủy',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (!resetFormKey.currentState!.validate()) return;
                final email = resetEmailController.text.trim();
                Navigator.of(dialogContext).pop();
                final success = await ref
                    .read(loginControllerProvider.notifier)
                    .sendPasswordResetEmail(email: email);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.resetPasswordSent),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text(AppStrings.sendResetLink),
            ),
          ],
        );
      },
    );
    resetEmailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (prev, next) {
      if (next.hasError && !next.isLoading) {
        final rawError = next.error;
        final message = rawError is Exception
            ? rawError.toString().replaceFirst('Exception: ', '')
            : rawError.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    final loginState = ref.watch(loginControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppValues.screenPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '🌌 ${AppStrings.appName}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppValues.spacing8),
                  Text(
                    'Đăng nhập để theo dõi mục tiêu dinh dưỡng',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppValues.spacing32),
                  AuthTextField(
                    controller: _emailController,
                    labelText: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                    validator: (v) => v != null && v.contains('@')
                        ? null
                        : 'Email không hợp lệ',
                  ),
                  const SizedBox(height: AppValues.spacing16),
                  AuthTextField(
                    controller: _passwordController,
                    labelText: AppStrings.password,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.onSurfaceVariant,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (v) => v != null && v.length >= 6
                        ? null
                        : 'Mật khẩu tối thiểu 6 ký tự',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
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
                  AuthSubmitButton(
                    text: AppStrings.login,
                    isLoading: loginState.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: AppValues.spacing24),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppColors.outline),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppValues.spacing16),
                        child: Text(
                          AppStrings.orDivider,
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppColors.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppValues.spacing24),
                  GoogleSignInButton(
                    isLoading: loginState.isLoading,
                    onPressed: _handleGoogleLogin,
                  ),
                  const SizedBox(height: AppValues.spacing24),
                  TextButton(
                    onPressed: () => context.router.push(const RegisterRoute()),
                    child: Text(
                      'Chưa có tài khoản? ${AppStrings.register}',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
