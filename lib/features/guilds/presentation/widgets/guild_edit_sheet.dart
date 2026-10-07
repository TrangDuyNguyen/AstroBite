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

  final List<Map<String, String>> _planets = const [
    {'id': 'mars', 'name': 'Sao Hỏa'},
    {'id': 'venus', 'name': 'Sao Kim'},
    {'id': 'jupiter', 'name': 'Sao Mộc'},
    {'id': 'saturn', 'name': 'Sao Thổ'},
    {'id': 'neptune', 'name': 'Sao Hải Vương'},
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
          // Drag handle
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
          const SizedBox(height: 18),

          // Header with 3D Planet Figurine
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.clayLunch,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Clay3DPlanet(planet: _selectedPlanet, size: 30),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chỉnh Sửa Thông Tin Bang Hội',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Cập nhật tên, tuyên ngôn và biểu tượng hành tinh đại diện.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Planet Selection Header
          Text(
            'Hành Tinh Đại Diện:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 10),

          // Tactile 3D Clay Planet Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: _planets.map((planet) {
                final isSelected = _selectedPlanet == planet['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClayPlanetChip(
                    planetId: planet['id']!,
                    label: planet['name']!,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedPlanet = planet['id']!);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

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

          // Full-width Chunky 3D Submit button
          ClayButton(
            width: double.infinity,
            height: 52,
            text: 'Lưu Thay Đổi',
            isLoading: uiState.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
