import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import '../controllers/login_controller.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(loginControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted) {
      context.router.replaceAll([const ShellRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppValues.spacing48),
                AuthTextField(
                  controller: _emailController,
                  labelText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v != null && v.contains('@') ? null : 'Email không hợp lệ',
                ),
                const SizedBox(height: AppValues.spacing16),
                AuthTextField(
                  controller: _passwordController,
                  labelText: AppStrings.password,
                  obscureText: true,
                  validator: (v) => v != null && v.length >= 6 ? null : 'Mật khẩu tối thiểu 6 ký tự',
                ),
                if (loginState.hasError) ...[
                  const SizedBox(height: AppValues.spacing8),
                  Text(
                    loginState.error.toString(),
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
                const SizedBox(height: AppValues.spacing24),
                AuthSubmitButton(
                  text: AppStrings.login,
                  isLoading: loginState.isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: AppValues.spacing16),
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
    );
  }
}
