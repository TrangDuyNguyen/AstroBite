import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../recipes_providers.dart';
import '../controllers/recipe_builder_controller.dart';

/// 3D tactile save button for RecipeBuilderPage.
class RecipeSaveButton extends ConsumerStatefulWidget {
  const RecipeSaveButton({
    super.key,
    required this.formKey,
    required this.nameCtrl,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;

  @override
  ConsumerState<RecipeSaveButton> createState() => _RecipeSaveButtonState();
}

class _RecipeSaveButtonState extends ConsumerState<RecipeSaveButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeBuilderProvider);

    if (state.isSaving) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _save(context, ref);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 1.8 : 0.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF38BDF8), Color(0xFF1CB0F6)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF1488C2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F74A8),
              offset: Offset(0, _isPressed ? 1.0 : 2.8),
              blurRadius: 0,
            ),
          ],
        ),
        child: const Text(
          'Lưu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    if (!(widget.formKey.currentState?.validate() ?? false)) return;

    final controller = ref.read(recipeBuilderProvider.notifier);
    final repo = ref.read(recipeRepositoryProvider);
    final user = ref.read(authStateProvider).valueOrNull;
    final userId = (user?.uid.isNotEmpty == true) ? user!.uid : 'guest_user';

    final saved = await controller.save(userId: userId, repo: repo);
    if (!context.mounted) return;

    if (saved != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Đã lưu công thức "${saved.name}"'),
          backgroundColor: AppColors.brandGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.router.maybePop();
    }
  }
}
