import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/guild_controller.dart';

class GuildCreateSheet extends ConsumerStatefulWidget {
  const GuildCreateSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const GuildCreateSheet(),
    );
  }

  @override
  ConsumerState<GuildCreateSheet> createState() => _GuildCreateSheetState();
}

class _GuildCreateSheetState extends ConsumerState<GuildCreateSheet> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedPlanet = 'mars';

  final List<Map<String, String>> _planets = const [
    {'id': 'mars', 'name': 'Sao Hỏa'},
    {'id': 'venus', 'name': 'Sao Kim'},
    {'id': 'jupiter', 'name': 'Sao Mộc'},
    {'id': 'saturn', 'name': 'Sao Thổ'},
    {'id': 'neptune', 'name': 'Sao Hải Vương'},
  ];

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

    final success = await ref.read(guildControllerProvider.notifier).createGuild(
          name: name,
          description: _descController.text.trim(),
          avatarPlanet: _selectedPlanet,
        );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã tạo thành công Bang hội "$name"!'),
          backgroundColor: AppColors.brandGreen,
        ),
      );
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

          // Header with 3D Rocket Figurine
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
                child: const Center(
                  child: Clay3DCarrotRocket(size: 28),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khởi Tạo Bang Hội Vũ Trụ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tập hợp đồng đội cùng chinh phục mục tiêu dinh dưỡng lành mạnh.',
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
            'Chọn Hành Tinh Đại Diện:',
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
            hintText: 'Ví dụ: Vệ Binh Sao Hỏa, Chiến Binh Keto...',
          ),
          const SizedBox(height: 12),

          // Guild Desc
          ClayTextField(
            controller: _descController,
            labelText: 'Tuyên ngôn hoặc mục tiêu bang hội',
            hintText: 'Cùng nhau giảm cân, tích cực ăn sạch...',
          ),
          const SizedBox(height: 24),

          // Full-width Chunky 3D Submit button
          ClayButton(
            width: double.infinity,
            height: 52,
            text: 'Khởi Tạo Bang Hội Ngay',
            isLoading: uiState.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
