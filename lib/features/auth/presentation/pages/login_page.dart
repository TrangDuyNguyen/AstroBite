import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_form_card.dart';
import '../widgets/login_header_view.dart';
import '../widgets/login_reset_password_dialog.dart';
import '../widgets/zero_gravity_food_background.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _fadeCardAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 0.95, curve: Curves.easeOut),
    );

    _slideCardAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 0.95, curve: Curves.easeOutCubic),
    ));

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
      if (mounted) context.router.replaceAll([const OnboardingRoute()]);
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(loginControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted) await _navigatePostAuth();
  }

  Future<void> _handleGoogleLogin() async {
    final success = await ref.read(loginControllerProvider.notifier).loginWithGoogle();
    if (success && mounted) await _navigatePostAuth();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (prev, next) {
      if (next.hasError && !next.isLoading) {
        final rawError = next.error;
        final message = rawError is Exception ? rawError.toString().replaceFirst('Exception: ', '') : rawError.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
      }
    });

    final loginState = ref.watch(loginControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ..._buildAmbientGradients(),
          const ZeroGravityFoodBackground(),
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
                    LoginHeaderView(
                      fadeAnimation: _fadeHeaderAnimation,
                      slideAnimation: _slideHeaderAnimation,
                    ),
                    const SizedBox(height: AppValues.spacing24),
                    SlideTransition(
                      position: _slideCardAnimation,
                      child: FadeTransition(
                        opacity: _fadeCardAnimation,
                        child: LoginFormCard(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isLoading: loginState.isLoading,
                          onLogin: _handleLogin,
                          onGoogleLogin: _handleGoogleLogin,
                          onForgotPassword: () => showLoginResetPasswordDialog(
                            context: context,
                            ref: ref,
                            initialEmail: _emailController.text.trim(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppValues.spacing20),
                    FadeTransition(
                      opacity: _fadeCardAnimation,
                      child: TextButton(
                        onPressed: () => context.router.push(const RegisterRoute()),
                        child: RichText(
                          text: TextSpan(
                            text: 'Chưa có tài khoản? ',
                            style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 14),
                            children: [
                              TextSpan(
                                text: context.l10n.register,
                                style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w700),
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

  List<Widget> _buildAmbientGradients() {
    return [
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
                colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.0)],
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
                colors: [AppColors.secondary.withValues(alpha: 0.06), AppColors.secondary.withValues(alpha: 0.0)],
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
                colors: [AppColors.tertiary.withValues(alpha: 0.05), AppColors.tertiary.withValues(alpha: 0.0)],
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
