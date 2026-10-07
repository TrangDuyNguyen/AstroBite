import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/models/guild.dart';
import '../controllers/guild_controller.dart';

class GuildEditSheet extends ConsumerStatefulWidget {
  final Guild guild;

  const GuildEditSheet({super.key, required this.guild});

  static Future<void> show(BuildContext context, {required Guild guild}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GuildEditSheet(guild: guild),
    );
  }

  @override
  ConsumerState<GuildEditSheet> createState() => _GuildEditSheetState();
}

class _GuildEditSheetState extends ConsumerState<GuildEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late String _selectedPlanet;

  final List<Map<String, String>> _planets = [
    {'id': 'mars', 'name': 'Sao Hỏa', 'icon': '🔴'},
    {'id': 'venus', 'name': 'Sao Kim', 'icon': '🟡'},
    {'id': 'jupiter', 'name': 'Sao Mộc', 'icon': '🟠'},
    {'id': 'saturn', 'name': 'Sao Thổ', 'icon': '🪐'},
    {'id': 'neptune', 'name': 'Sao Hải Vương', 'icon': '🔵'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guild.name);
    _descController = TextEditingController(text: widget.guild.description);
    _selectedPlanet = widget.guild.avatarPlanet;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.length < 3 || name.length > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên bang hội phải từ 3 đến 30 ký tự'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final success = await ref.read(guildControllerProvider.notifier).updateGuildInfo(
          name: name,
          description: _descController.text.trim(),
          avatarPlanet: _selectedPlanet,
        );

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(guildControllerProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chỉnh Sửa Thông Tin Bang Hội ✏️',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cập nhật tên, tuyên ngôn và biểu tượng hành tinh đại diện.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),

          // Planet Selection
          Text(
            'Hành Tinh Đại Diện:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _planets.map((planet) {
                final isSelected = _selectedPlanet == planet['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${planet['icon']} ${planet['name']}'),
                    selected: isSelected,
                    selectedColor: AppColors.clayLunch,
                    backgroundColor: AppColors.surfaceContainer,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedPlanet = planet['id']!);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Guild Name
          ClayTextField(
            controller: _nameController,
            labelText: 'Tên Bang Hội (3-30 ký tự)',
            hintText: 'Ví dụ: Vệ Binh Sao Hỏa...',
          ),
          const SizedBox(height: 12),

          // Guild Desc
          ClayTextField(
            controller: _descController,
            labelText: 'Tuyên ngôn hoặc mục tiêu bang hội',
            hintText: 'Mục tiêu dinh dưỡng của bang...',
          ),
          const SizedBox(height: 24),

          // Submit button
          ClayButton(
            text: 'Lưu Thay Đổi',
            isLoading: uiState.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
