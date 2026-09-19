import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/celestial_particle_background.dart';
import 'package:astrobite/shared/widgets/cosmic_logo_badge.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import '../controllers/register_controller.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

@RoutePage()
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(registerControllerProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted) {
      context.router.replaceAll([const OnboardingRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerControllerProvider, (prev, next) {
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

    final registerState = ref.watch(registerControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          AppStrings.register,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: CelestialParticleBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.screenPadding,
                vertical: AppValues.spacing16,
              ),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CosmicLogoBadge(
                        size: 64,
                        heroTag: 'astrobite-brand-logo-register',
                      ),
                      const SizedBox(height: AppValues.spacing12),
                      Text(
                        'Tạo tài khoản AstroBite',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bắt đầu hành trình dinh dưỡng thông minh',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppValues.spacing24),

                      GlassCard(
                        padding: const EdgeInsets.all(AppValues.spacing20),
                        borderRadius: AppValues.cardRadius * 1.5,
                        borderColor: Colors.white.withValues(alpha: 0.12),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthTextField(
                                controller: _emailController,
                                labelText: AppStrings.email,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                validator: (v) =>
                                    v != null && v.contains('@') ? null : 'Email không hợp lệ',
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
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                validator: (v) => v != null && v.length >= 6
                                    ? null
                                    : 'Mật khẩu tối thiểu 6 ký tự',
                              ),
                              const SizedBox(height: AppValues.spacing16),
                              AuthTextField(
                                controller: _confirmController,
                                labelText: AppStrings.confirmPassword,
                                obscureText: _obscureConfirm,
                                prefixIcon: const Icon(
                                  Icons.lock_reset_outlined,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscureConfirm = !_obscureConfirm);
                                  },
                                ),
                                validator: (v) => v == _passwordController.text
                                    ? null
                                    : 'Mật khẩu không khớp',
                              ),
                              const SizedBox(height: AppValues.spacing24),
                              AuthSubmitButton(
                                text: AppStrings.register,
                                isLoading: registerState.isLoading,
                                onPressed: _handleRegister,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppValues.spacing16),

                      TextButton(
                        onPressed: () => context.router.maybePop(),
                        child: RichText(
                          text: TextSpan(
                            text: 'Đã có tài khoản? ',
                            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                            children: [
                              TextSpan(
                                text: AppStrings.login,
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
