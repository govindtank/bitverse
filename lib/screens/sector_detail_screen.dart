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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      body: Container(
        decoration: CyberpunkTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isDesktop ? 32 : 16),
                  child: isDesktop
                      ? _buildDesktopLayout(context, ref)
                      : _buildMobileLayout(context, ref),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CyberpunkTheme.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: CyberpunkTheme.primaryNeon.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: CyberpunkTheme.primaryNeon.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: CyberpunkTheme.primaryNeon,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sector.name.toUpperCase(),
                  style: const TextStyle(
                    color: CyberpunkTheme.primaryNeon,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: CyberpunkTheme.accentNeon,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'SECTOR ACTIVE',
                      style: TextStyle(
                        color: CyberpunkTheme.textSecondary,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getSectorTypeColor(sector.type).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getSectorTypeColor(sector.type).withOpacity(0.5)),
            ),
            child: Text(
              sector.type.toUpperCase(),
              style: TextStyle(
                color: _getSectorTypeColor(sector.type),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2);
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildInfoAndResources()),
        const SizedBox(width: 24),
        Expanded(flex: 1, child: _buildActionsColumn(context, ref)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildInfoAndResources(),
        const SizedBox(height: 24),
        _buildActionsColumn(context, ref),
      ],
    );
  }

  Widget _buildInfoAndResources() {
    return Column(
      children: [
        _buildSectorInfoCard(),
        const SizedBox(height: 16),
        _buildResourceCard(),
        const SizedBox(height: 16),
        _buildBuildingsCard(),
      ],
    );
  }

  Widget _buildSectorInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: CyberpunkTheme.glowingCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getSectorTypeColor(sector.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getSectorIcon(sector.type),
                  color: _getSectorTypeColor(sector.type),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SECTOR DETAILS',
                      style: TextStyle(
                        color: CyberpunkTheme.textSecondary,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      sector.name,
                      style: const TextStyle(
                        color: CyberpunkTheme.primaryNeon,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: CyberpunkTheme.primaryNeon),
          const SizedBox(height: 16),
          _buildInfoRow('Coordinates', '(${sector.gridX}, ${sector.gridY})', Icons.grid_on),
          _buildInfoRow('Population', '${sector.population.toStringAsFixed(0)}', Icons.people),
          _buildInfoRow('Resource Level', '${sector.resourceLevel.toStringAsFixed(1)}%', Icons.analytics),
          _buildInfoRow('Buildings', '${sector.buildings.length}', Icons.business),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1);
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: CyberpunkTheme.textSecondary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: CyberpunkTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard() {
    final progressColor = sector.resourceLevel > 70
        ? CyberpunkTheme.accentNeon
        : (sector.resourceLevel > 30 ? CyberpunkTheme.warningNeon : CyberpunkTheme.errorNeon);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: CyberpunkTheme.glowingCardDecoration,
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: sector.resourceLevel / 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progressColor.withOpacity(0.8),
                      progressColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: progressColor.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${sector.resourceLevel.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sector.resourceLevel > 70
                      ? 'OPTIMAL'
                      : (sector.resourceLevel > 30 ? 'MODERATE' : 'LOW'),
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }

  Widget _buildBuildingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: CyberpunkTheme.glowingCardDecoration,
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CyberpunkTheme.secondaryNeon.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${sector.buildings.length}',
                  style: const TextStyle(
                    color: CyberpunkTheme.secondaryNeon,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (sector.buildings.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: CyberpunkTheme.surfaceDark.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CyberpunkTheme.secondaryNeon.withOpacity(0.2)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.add_home, color: CyberpunkTheme.textSecondary, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'No buildings constructed',
                    style: TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap the + button below to add buildings',
                    style: TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 10),
                  ),
                ],
              ),
            )
          else
            ...sector.buildings.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final buildingName = entry.value;
              final buildingType = _getBuildingTypeFromName(buildingName);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CyberpunkTheme.surfaceDark.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CyberpunkTheme.secondaryNeon.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CyberpunkTheme.secondaryNeon.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getBuildingIcon(buildingType),
                        color: CyberpunkTheme.secondaryNeon,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        buildingName,
                        style: const TextStyle(
                          color: CyberpunkTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.1);
            }),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildActionsColumn(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: CyberpunkTheme.glowingCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ACTIONS',
            style: TextStyle(
              color: CyberpunkTheme.primaryNeon,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.upgrade,
            label: 'UPGRADE SECTOR',
            description: '+10% Resource, +50 Pop',
            color: CyberpunkTheme.accentNeon,
            onTap: () => _upgradeSector(context, ref),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.people,
            label: 'ADD POPULATION',
            description: '+100 Citizens',
            color: Colors.green,
            onTap: () => _addPopulation(context, ref),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.bolt,
            label: 'BOOST RESOURCES',
            description: '+20% Resource Level',
            color: Colors.yellow,
            onTap: () => _boostResources(context, ref),
          ),
          const SizedBox(height: 20),
          const Divider(color: CyberpunkTheme.primaryNeon),
          const SizedBox(height: 16),
          const Text(
            'CONSTRUCT',
            style: TextStyle(
              color: CyberpunkTheme.secondaryNeon,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showAddBuildingDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('ADD BUILDING'),
            style: OutlinedButton.styleFrom(
              foregroundColor: CyberpunkTheme.secondaryNeon,
              side: const BorderSide(color: CyberpunkTheme.secondaryNeon),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        color: CyberpunkTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBuildingDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_business, color: CyberpunkTheme.secondaryNeon),
            SizedBox(width: 8),
            Text('CONSTRUCT BUILDING'),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: BuildingType.values.map((type) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: CyberpunkTheme.surfaceMedium,
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CyberpunkTheme.secondaryNeon.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getBuildingIcon(type),
                        color: CyberpunkTheme.secondaryNeon,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      type.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                        color: CyberpunkTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    trailing: const Icon(Icons.add, color: CyberpunkTheme.accentNeon),
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
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  void _upgradeSector(BuildContext context, WidgetRef ref) {
    final updatedSector = sector.copyWith(
      resourceLevel: (sector.resourceLevel + 10).clamp(0.0, 100.0),
      population: sector.population + 50,
    );
    ref.read(gameStateNotifierProvider.notifier).updateSector(updatedSector);
    _showSnackBar(context, 'Sector upgraded successfully!', CyberpunkTheme.accentNeon);
  }

  void _addPopulation(BuildContext context, WidgetRef ref) {
    final updatedSector = sector.copyWith(population: sector.population + 100);
    ref.read(gameStateNotifierProvider.notifier).updateSector(updatedSector);
    _showSnackBar(context, 'Population increased!', Colors.green);
  }

  void _boostResources(BuildContext context, WidgetRef ref) {
    final updatedSector = sector.copyWith(resourceLevel: (sector.resourceLevel + 20).clamp(0.0, 100.0));
    ref.read(gameStateNotifierProvider.notifier).updateSector(updatedSector);
    _showSnackBar(context, 'Resources boosted!', Colors.yellow);
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: color, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: CyberpunkTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Color _getSectorTypeColor(String type) {
    switch (type) {
      case 'residential':
        return Colors.green;
      case 'commercial':
        return Colors.blue;
      case 'industrial':
        return Colors.orange;
      case 'tech':
        return CyberpunkTheme.primaryNeon;
      case 'infrastructure':
        return Colors.grey;
      default:
        return CyberpunkTheme.textSecondary;
    }
  }

  IconData _getSectorIcon(String type) {
    switch (type) {
      case 'residential':
        return Icons.home;
      case 'commercial':
        return Icons.store;
      case 'industrial':
        return Icons.factory;
      case 'tech':
        return Icons.computer;
      case 'infrastructure':
        return Icons.construction;
      default:
        return Icons.location_city;
    }
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

  BuildingType _getBuildingTypeFromName(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('residential') || lowerName.contains('home')) {
      return BuildingType.residential;
    } else if (lowerName.contains('commercial') || lowerName.contains('store')) {
      return BuildingType.commercial;
    } else if (lowerName.contains('industrial') || lowerName.contains('factory')) {
      return BuildingType.industrial;
    } else if (lowerName.contains('tech') || lowerName.contains('computer')) {
      return BuildingType.tech;
    } else if (lowerName.contains('infrastructure') || lowerName.contains('construction')) {
      return BuildingType.infrastructure;
    }
    return BuildingType.residential;
  }
}
