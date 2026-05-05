import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/cyberpunk_theme.dart';
import '../models/all_models.dart';
import '../providers/game_providers.dart';

class SectorDetailScreen extends ConsumerWidget {
  final QuantumSector sector;

  const SectorDetailScreen({super.key, required this.sector});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sector.name.toUpperCase()),
        backgroundColor: CyberpunkTheme.surfaceDark,
      ),
      body: Container(
        decoration: CyberpunkTheme.gradientBackground,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectorInfoCard(sector),
            const SizedBox(height: 16),
            _buildResourceCard(sector),
            const SizedBox(height: 16),
            _buildBuildingsCard(context, ref, sector),
            const SizedBox(height: 16),
            _buildActionsCard(context, ref, sector),
          ],
        ),
      ),
    );
  }

  Widget _buildSectorInfoCard(QuantumSector sector) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_city, color: CyberpunkTheme.primaryNeon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sector.name,
                    style: const TextStyle(
                      color: CyberpunkTheme.primaryNeon,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: CyberpunkTheme.primaryNeon),
            _buildInfoRow('Type', sector.type.toUpperCase()),
            _buildInfoRow('Coordinates', '(${sector.gridX}, ${sector.gridY})'),
            _buildInfoRow('Population', '${sector.population}'),
            _buildInfoRow('Resource Level', '${sector.resourceLevel.toStringAsFixed(1)}%'),
            _buildInfoRow('Buildings', '${sector.buildings.length}'),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2);
  }

  Widget _buildResourceCard(QuantumSector sector) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: CyberpunkTheme.accentNeon),
                SizedBox(width: 8),
                Text(
                  'RESOURCE LEVEL',
                  style: TextStyle(
                    color: CyberpunkTheme.accentNeon,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: sector.resourceLevel / 100,
              minHeight: 12,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                sector.resourceLevel > 70 ? CyberpunkTheme.accentNeon : CyberpunkTheme.warningNeon,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${sector.resourceLevel.toStringAsFixed(1)}%',
              style: const TextStyle(color: CyberpunkTheme.textPrimary, fontSize: 14),
            ),
          ],
        ),
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideX(begin: 0.2);
  }

  Widget _buildBuildingsCard(BuildContext context, WidgetRef ref, QuantumSector sector) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.construction, color: CyberpunkTheme.secondaryNeon),
                const SizedBox(width: 8),
                const Text(
                  'BUILDINGS',
                  style: TextStyle(
                    color: CyberpunkTheme.secondaryNeon,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _showAddBuildingDialog(context, ref, sector),
                  child: const Text('+ ADD'),
                ),
              ],
            ),
            const Divider(color: CyberpunkTheme.secondaryNeon),
            if (sector.buildings.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No buildings yet. Tap + ADD to construct.',
                  style: TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 12),
                ),
              )
            else
              ...sector.buildings.map((building) => ListTile(
                    leading: const Icon(Icons.business, color: CyberpunkTheme.secondaryNeon, size: 20),
                    title: Text(
                      building,
                      style: const TextStyle(color: CyberpunkTheme.textPrimary, fontSize: 14),
                    ),
                    dense: true,
                  )),
          ],
        ),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildActionsCard(BuildContext context, WidgetRef ref, QuantumSector sector) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ACTIONS',
              style: TextStyle(
                color: CyberpunkTheme.primaryNeon,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.upgrade,
                  label: 'UPGRADE',
                  onTap: () => _upgradeSector(context, ref, sector),
                ),
                _buildActionButton(
                  icon: Icons.people,
                  label: 'ADD POP',
                  onTap: () => _addPopulation(context, ref, sector),
                ),
                _buildActionButton(
                  icon: Icons.bolt,
                  label: 'BOOST',
                  onTap: () => _boostResources(context, ref, sector),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(color: CyberpunkTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: CyberpunkTheme.primaryNeon, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(icon, color: CyberpunkTheme.primaryNeon, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: CyberpunkTheme.primaryNeon, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBuildingDialog(BuildContext context, WidgetRef ref, QuantumSector sector) {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: CyberpunkTheme.surfaceDark,
        title: const Text('ADD BUILDING', style: TextStyle(color: CyberpunkTheme.primaryNeon)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: BuildingType.values.map((type) {
            return ListTile(
              leading: Icon(_getBuildingIcon(type), color: CyberpunkTheme.secondaryNeon),
              title: Text(
                type.toString().split('.').last.toUpperCase(),
                style: const TextStyle(color: CyberpunkTheme.textPrimary),
              ),
              onTap: () async {
                final building = Building(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: '${type.toString().split('.').last} Building',
                  type: type,
                  description: 'A new ${type.toString().split('.').last} building',
                  resourceOutput: 10,
                  resourceCost: 50,
                );
                await ref.read(gameStateNotifierProvider.notifier).addBuilding(sector.id, building);
                navigator.pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _upgradeSector(BuildContext context, WidgetRef ref, QuantumSector sector) {
    final updatedSector = sector.copyWith(
      resourceLevel: (sector.resourceLevel + 10).clamp(0.0, 100.0),
      population: sector.population + 50,
    );
    ref.read(gameStateNotifierProvider.notifier).updateSector(updatedSector);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sector upgraded!'), backgroundColor: CyberpunkTheme.accentNeon),
    );
  }

  void _addPopulation(BuildContext context, WidgetRef ref, QuantumSector sector) {
    final updatedSector = sector.copyWith(population: sector.population + 100);
    ref.read(gameStateNotifierProvider.notifier).updateSector(updatedSector);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Population added!'), backgroundColor: CyberpunkTheme.accentNeon),
    );
  }

  void _boostResources(BuildContext context, WidgetRef ref, QuantumSector sector) {
    final updatedSector = sector.copyWith(resourceLevel: (sector.resourceLevel + 20).clamp(0.0, 100.0));
    ref.read(gameStateNotifierProvider.notifier).updateSector(updatedSector);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resources boosted!'), backgroundColor: CyberpunkTheme.accentNeon),
    );
  }

  IconData _getBuildingIcon(BuildingType type) {
    switch (type) {
      case BuildingType.residential:
        return Icons.home;
      case BuildingType.commercial:
        return Icons.store;
      case BuildingType.industrial:
        return Icons.factory;
      case BuildingType.tech:
        return Icons.computer;
      case BuildingType.infrastructure:
        return Icons.construction;
    }
  }
}
