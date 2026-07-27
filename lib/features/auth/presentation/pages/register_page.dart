import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import '../controllers/register_controller.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';

@RoutePage()
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
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
      context.router.replaceAll([const ShellRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.register)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: AppValues.spacing16),
                AuthTextField(
                  controller: _confirmController,
                  labelText: AppStrings.confirmPassword,
                  obscureText: true,
                  validator: (v) => v == _passwordController.text ? null : 'Mật khẩu không khớp',
                ),
                if (registerState.hasError) ...[
                  const SizedBox(height: AppValues.spacing8),
                  Text(
                    registerState.error.toString(),
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
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
      ),
    );
  }
}
