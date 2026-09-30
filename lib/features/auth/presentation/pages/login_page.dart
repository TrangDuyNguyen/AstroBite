import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/shared/widgets/cosmic_logo_badge.dart';
import '../controllers/login_controller.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/zero_gravity_food_background.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeHeaderAnimation;
  late final Animation<Offset> _slideHeaderAnimation;
  late final Animation<double> _fadeCardAnimation;
  late final Animation<Offset> _slideCardAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeHeaderAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideHeaderAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _fadeCardAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 0.95, curve: Curves.easeOut),
    );

    _slideCardAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _navigatePostAuth() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;
    try {
      final repo = ref.read(profileRepositoryProvider);
      final profile = await repo.getProfile(user.uid).timeout(
        const Duration(seconds: 3),
        onTimeout: () => null,
      );
      if (!mounted) return;
      if (profile != null && profile.isOnboardingCompleted) {
        context.router.replaceAll([const ShellRoute()]);
      } else {
        context.router.replaceAll([const OnboardingRoute()]);
      }
    } catch (_) {
      if (mounted) {
        context.router.replaceAll([const OnboardingRoute()]);
      }
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
            side: const BorderSide(color: AppColors.outline),
          ),
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
                ClayTextField(
                  controller: resetEmailController,
                  labelText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.onSurfaceVariant,
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

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Warm Clay Ambiance — subtle radial gradients
          Positioned(
            top: -80,
            right: -80,
            width: 320,
            height: 320,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            width: 280,
            height: 280,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.06),
                      AppColors.secondary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 240,
            left: -80,
            width: 260,
            height: 260,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.tertiary.withValues(alpha: 0.05),
                      AppColors.tertiary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Zero-Gravity Clay Food & Fruit Floating Background
          const ZeroGravityFoodBackground(),

          // 3. Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.screenPadding,
                  vertical: AppValues.spacing24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 2a. Header with Hero Logo Badge
                    SlideTransition(
                      position: _slideHeaderAnimation,
                      child: FadeTransition(
                        opacity: _fadeHeaderAnimation,
                        child: Column(
                          children: [
                            const CosmicLogoBadge(
                              size: 80,
                              heroTag: 'astrobite-brand-logo',
                            ),
                            const SizedBox(height: AppValues.spacing16),
                            Text(
                              AppStrings.appName,
                              style: GoogleFonts.outfit(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppValues.spacing4),
                            Text(
                              'Đăng nhập để theo dõi mục tiêu dinh dưỡng',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppValues.spacing24),

                    // 2b. Form Container in ClayCard
                    SlideTransition(
                      position: _slideCardAnimation,
                      child: FadeTransition(
                        opacity: _fadeCardAnimation,
                        child: ClayCard(
                          padding: const EdgeInsets.all(AppValues.spacing24),
                          borderRadius: AppValues.cardRadiusLarge,
                          elevation: 6.0,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClayTextField(
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
                                ClayTextField(
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
                                ClayButton(
                                  text: AppStrings.login,
                                  isLoading: loginState.isLoading,
                                  onPressed: _handleLogin,
                                  width: double.infinity,
                                  height: 52,
                                ),
                                const SizedBox(height: AppValues.spacing20),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Divider(color: AppColors.outline),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppValues.spacing16,
                                      ),
                                      child: Text(
                                        AppStrings.orDivider,
                                        style: TextStyle(
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
                                      onPressed: loginState.isLoading ? null : _handleGoogleLogin,
                                    ),
                                    const SizedBox(width: AppValues.spacing16),
                                    ClayIconButton(
                                      size: 56.0,
                                      icon: Icons.apple,
                                      iconColor: Colors.black,
                                      onPressed: loginState.isLoading ? null : () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppValues.spacing20),

                    // 2c. Register Redirect Link
                    FadeTransition(
                      opacity: _fadeCardAnimation,
                      child: TextButton(
                        onPressed: () => context.router.push(const RegisterRoute()),
                        child: RichText(
                          text: TextSpan(
                            text: 'Chưa có tài khoản? ',
                            style: GoogleFonts.inter(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: AppStrings.register,
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
