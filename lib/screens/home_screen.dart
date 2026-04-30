import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_providers.dart';
import '../theme/cyberpunk_theme.dart';
import 'sector_detail_screen.dart';
import '../models/all_models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BITVERSE'),
        backgroundColor: CyberpunkTheme.surfaceDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(gameStateNotifierProvider),
            tooltip: 'Reset Game',
          ),
        ],
      ),
      body: Container(
        decoration: CyberpunkTheme.gradientBackground,
        child: gameState.when(
          data: (data) => _buildGameContent(context, ref, data),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ).animate().fadeIn(duration: 500.ms),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: CyberpunkTheme.errorNeon, size: 64),
                const SizedBox(height: 16),
                Text('Error: $error', style: const TextStyle(color: CyberpunkTheme.textPrimary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(gameStateNotifierProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent(BuildContext context, WidgetRef ref, GameStateData data) {
    return Column(
      children: [
        _buildResourceBar(context, data.resources),
        _buildTimelineInfo(context, data.timeline),
        Expanded(child: _buildSectorGrid(context, ref, data.sectors)),
      ],
    );
  }

  Widget _buildResourceBar(BuildContext context, List<Resource> resources) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CyberpunkTheme.surfaceDark,
        border: Border(
          bottom: BorderSide(color: CyberpunkTheme.primaryNeon.withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: resources.map((resource) => _buildResourceItem(resource)).toList(),
      ),
    ).animate().slideY(begin: -1, duration: 500.ms);
  }

  Widget _buildResourceItem(Resource resource) {
    final color = _getResourceColor(resource.type);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_getResourceIcon(resource.type), color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          '${resource.value.toStringAsFixed(0)}/${resource.maxCapacity}',
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          _getResourceName(resource.type),
          style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildTimelineInfo(BuildContext context, QuantumTimeline? timeline) {
    if (timeline == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: CyberpunkTheme.surfaceMedium,
      child: Row(
        children: [
          const Icon(Icons.timeline, color: CyberpunkTheme.secondaryNeon, size: 16),
          const SizedBox(width: 8),
          Text(
            'Timeline: ${timeline.name}',
            style: const TextStyle(color: CyberpunkTheme.secondaryNeon, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            'Sequence #${timeline.sequenceNumber}',
            style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 12),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildSectorGrid(BuildContext context, WidgetRef ref, List<QuantumSector> sectors) {
    if (sectors.isEmpty) {
      return const Center(
        child: Text(
          'Initializing Quantum Grid...',
          style: TextStyle(color: CyberpunkTheme.primaryNeon, fontSize: 18),
        ),
      ).animate().shimmer(duration: 1500.ms);
    }

    final gridSize = _calculateGridSize(sectors);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: sectors.length,
        itemBuilder: (context, index) {
          final sector = sectors[index];
          return _buildSectorCard(context, ref, sector, index);
        },
      ),
    );
  }

  Widget _buildSectorCard(BuildContext context, WidgetRef ref, QuantumSector sector, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectorDetailScreen(sector: sector),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: CyberpunkTheme.surfaceMedium,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CyberpunkTheme.primaryNeon.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: CyberpunkTheme.primaryNeon.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sector.name,
              style: const TextStyle(
                color: CyberpunkTheme.primaryNeon,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: sector.resourceLevel / 100,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                sector.resourceLevel > 70 ? CyberpunkTheme.accentNeon : CyberpunkTheme.warningNeon,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pop: ${sector.population}',
              style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 10),
            ),
            Text(
              sector.type.toUpperCase(),
              style: TextStyle(
                color: _getSectorTypeColor(sector.type),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ).animate(delay: (index * 50).ms).fadeIn(duration: 300.ms).slideY(begin: 0.3),
    );
  }

  int _calculateGridSize(List<QuantumSector> sectors) {
    final count = sectors.length;
    return (count > 0) ? (count / 8).ceil() : 4;
  }

  Color _getResourceColor(ResourceType type) {
    switch (type) {
      case ResourceType.energy:
        return Colors.yellow;
      case ResourceType.data:
        return Colors.blue;
      case ResourceType.matter:
        return Colors.orange;
      case ResourceType.quantum:
        return CyberpunkTheme.secondaryNeon;
      case ResourceType.population:
        return CyberpunkTheme.accentNeon;
    }
  }

  IconData _getResourceIcon(ResourceType type) {
    switch (type) {
      case ResourceType.energy:
        return Icons.bolt;
      case ResourceType.data:
        return Icons.data_usage;
      case ResourceType.matter:
        return Icons.category;
      case ResourceType.quantum:
        return Icons.science;
      case ResourceType.population:
        return Icons.people;
    }
  }

  String _getResourceName(ResourceType type) {
    return type.toString().split('.').last.toUpperCase();
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
}
