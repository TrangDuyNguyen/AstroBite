import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';

import '../../data/models/user_profile_dto.dart';
import '../controllers/profile_controller.dart';

@RoutePage()
class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'male';
  late final TextEditingController _birthYearController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetCalController;
  String _activityLevel = 'moderate';

  @override
  void initState() {
    super.initState();
    _birthYearController = TextEditingController(text: '1995');
    _heightController = TextEditingController(text: '170');
    _weightController = TextEditingController(text: '65');
    _targetCalController = TextEditingController(text: '2000');
  }

  @override
  void dispose() {
    _birthYearController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetCalController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final dto = UserProfileDto(
      uid: user.uid,
      gender: _gender,
      birthYear: int.tryParse(_birthYearController.text) ?? 1995,
      heightCm: double.tryParse(_heightController.text) ?? 170,
      weightKg: double.tryParse(_weightController.text) ?? 65,
      activityLevel: _activityLevel,
      dailyTargetCalories: int.tryParse(_targetCalController.text) ?? 2000,
    );

    final success = await ref.read(profileControllerProvider.notifier).saveProfile(dto);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật hồ sơ!')),
      );
      context.router.popForced();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppValues.screenPadding),
            children: [
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(labelText: 'Giới tính'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Nam')),
                  DropdownMenuItem(value: 'female', child: Text('Nữ')),
                ],
                onChanged: (v) => setState(() => _gender = v ?? 'male'),
              ),
              const SizedBox(height: AppValues.spacing16),
              TextFormField(
                controller: _birthYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Năm sinh'),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập năm sinh',
              ),
              const SizedBox(height: AppValues.spacing16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Chiều cao (cm)'),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập chiều cao',
              ),
              const SizedBox(height: AppValues.spacing16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cân nặng (kg)'),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập cân nặng',
              ),
              const SizedBox(height: AppValues.spacing16),
              DropdownButtonFormField<String>(
                initialValue: _activityLevel,
                decoration: const InputDecoration(labelText: 'Mức độ vận động'),
                items: const [
                  DropdownMenuItem(value: 'sedentary', child: Text('Ít vận động (Ít/không tập thể thao)')),
                  DropdownMenuItem(value: 'light', child: Text('Nhẹ (Tập 1-3 ngày/tuần)')),
                  DropdownMenuItem(value: 'moderate', child: Text('Vừa phải (Tập 3-5 ngày/tuần)')),
                  DropdownMenuItem(value: 'active', child: Text('Năng động (Tập 6-7 ngày/tuần)')),
                ],
                onChanged: (v) => setState(() => _activityLevel = v ?? 'moderate'),
              ),
              const SizedBox(height: AppValues.spacing16),
              TextFormField(
                controller: _targetCalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mục tiêu Calo/ngày'),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập mục tiêu calo',
              ),
              const SizedBox(height: AppValues.spacing32),
              FilledButton(
                onPressed: profileState.isLoading ? null : _handleSave,
                child: profileState.isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
