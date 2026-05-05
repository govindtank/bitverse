import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_providers.dart';
import '../theme/cyberpunk_theme.dart';
import 'sector_detail_screen.dart';
import '../models/all_models.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateNotifierProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final isTablet = screenWidth > 600 && screenWidth <= 900;

    return Scaffold(
      body: Container(
        decoration: CyberpunkTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, isDesktop),
              Expanded(
                child: gameState.when(
                  data: (data) => _buildGameContent(context, ref, data, isDesktop, isTablet),
                  loading: () => _buildLoadingState(),
                  error: (error, stack) => _buildErrorState(context, ref, error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: CyberpunkTheme.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: CyberpunkTheme.primaryNeon.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: CyberpunkTheme.primaryNeon.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CyberpunkTheme.primaryNeon.withOpacity(0.5 + _pulseController.value * 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkTheme.primaryNeon.withOpacity(0.3 * _pulseController.value),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.hub,
                  color: CyberpunkTheme.primaryNeon,
                  size: 24,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BITVERSE',
                style: TextStyle(
                  color: CyberpunkTheme.primaryNeon,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                'Quantum Grid Active',
                style: TextStyle(
                  color: CyberpunkTheme.textSecondary,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildActionButton(
            icon: Icons.refresh,
            tooltip: 'Reset Game',
            onPressed: () => _showResetDialog(context, ref),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -1);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: CyberpunkTheme.primaryNeon.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: CyberpunkTheme.primaryNeon, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: CyberpunkTheme.neonBorderDecoration,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(CyberpunkTheme.primaryNeon),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'LOADING QUANTUM DATA...',
            style: TextStyle(
              color: CyberpunkTheme.textSecondary,
              fontSize: 14,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: CyberpunkTheme.glowingCardDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: CyberpunkTheme.errorNeon,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'SYSTEM ERROR',
              style: TextStyle(
                color: CyberpunkTheme.errorNeon,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: CyberpunkTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(gameStateNotifierProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('REBOOT SYSTEM'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    WidgetRef ref,
    GameStateData data,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      children: [
        _buildHeroSection(context, data, isDesktop),
        _buildResourceBar(context, data.resources, isDesktop, isTablet),
        _buildTimelineInfo(context, data.timeline),
        Expanded(child: _buildSectorGrid(context, ref, data.sectors, isDesktop, isTablet)),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, GameStateData data, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      decoration: CyberpunkTheme.heroDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '🌌 QUANTUM GRID',
            style: TextStyle(
              color: CyberpunkTheme.primaryNeon,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              fontFamily: 'monospace',
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            '${data.sectors.length} Sectors Active',
            style: const TextStyle(
              color: CyberpunkTheme.textSecondary,
              fontSize: 14,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          if (isDesktop) ...[
            const SizedBox(height: 8),
            Text(
              'Quantum Coherence: ${_calculateCoherence(data).toStringAsFixed(1)}%',
              style: const TextStyle(
                color: CyberpunkTheme.accentNeon,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  double _calculateCoherence(GameStateData data) {
    if (data.sectors.isEmpty) return 0;
    final avgLevel = data.sectors.fold<double>(0, (sum, s) => sum + s.resourceLevel) / data.sectors.length;
    return avgLevel;
  }

  Widget _buildResourceBar(BuildContext context, List<Resource> resources, bool isDesktop, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: CyberpunkTheme.surfaceDark.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(color: CyberpunkTheme.primaryNeon.withOpacity(0.2), width: 1),
        ),
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: resources.map((r) => _buildResourceItemLarge(r)).toList(),
            )
          : Wrap(
              spacing: 24,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: resources.map((r) => _buildResourceItemSmall(r)).toList(),
            ),
    ).animate().slideY(begin: -1, duration: 500.ms);
  }

  Widget _buildResourceItemLarge(Resource resource) {
    final color = _getResourceColor(resource.type);
    final percentage = resource.maxCapacity > 0 ? (resource.value / resource.maxCapacity) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberpunkTheme.surfaceMedium.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getResourceIcon(resource.type), color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            resource.value.toStringAsFixed(0),
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            _getResourceName(resource.type),
            style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 10, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItemSmall(Resource resource) {
    final color = _getResourceColor(resource.type);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_getResourceIcon(resource.type), color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          '${resource.value.toStringAsFixed(0)}',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineInfo(BuildContext context, QuantumTimeline? timeline) {
    if (timeline == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CyberpunkTheme.surfaceMedium.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CyberpunkTheme.secondaryNeon.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CyberpunkTheme.secondaryNeon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.timeline, color: CyberpunkTheme.secondaryNeon, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeline.name,
                  style: const TextStyle(
                    color: CyberpunkTheme.secondaryNeon,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Sequence #${timeline.sequenceNumber}',
                  style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CyberpunkTheme.secondaryNeon.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ACTIVE',
              style: TextStyle(
                color: CyberpunkTheme.secondaryNeon,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1);
  }

  Widget _buildSectorGrid(
    BuildContext context,
    WidgetRef ref,
    List<QuantumSector> sectors,
    bool isDesktop,
    bool isTablet,
  ) {
    if (sectors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.grid_4x4, color: CyberpunkTheme.primaryNeon, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Initializing Quantum Grid...',
              style: TextStyle(
                color: CyberpunkTheme.primaryNeon,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ).animate().shimmer(duration: 1500.ms),
          ],
        ),
      );
    }

    final gridSize = _calculateGridSize(sectors, isDesktop, isTablet);
    final crossAxisCount = isDesktop ? min(sectors.length, 6) : (isTablet ? min(sectors.length, 4) : gridSize);

    return Padding(
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isDesktop ? 16 : 12,
          mainAxisSpacing: isDesktop ? 16 : 12,
          childAspectRatio: isDesktop ? 1.2 : 1,
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
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SectorDetailScreen(sector: sector),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CyberpunkTheme.surfaceMedium,
                CyberpunkTheme.surfaceDark.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CyberpunkTheme.primaryNeon.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: CyberpunkTheme.primaryNeon.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 1,
              ),
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  _getSectorIcon(sector.type),
                  size: 80,
                  color: _getSectorTypeColor(sector.type).withOpacity(0.1),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _getSectorTypeColor(sector.type).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            _getSectorIcon(sector.type),
                            color: _getSectorTypeColor(sector.type),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sector.name,
                            style: const TextStyle(
                              color: CyberpunkTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      sector.type.toUpperCase(),
                      style: TextStyle(
                        color: _getSectorTypeColor(sector.type),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: sector.resourceLevel / 100,
                        backgroundColor: Colors.grey[800],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          sector.resourceLevel > 70
                              ? CyberpunkTheme.accentNeon
                              : (sector.resourceLevel > 30 ? CyberpunkTheme.warningNeon : CyberpunkTheme.errorNeon),
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, color: CyberpunkTheme.textSecondary, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '${sector.population}',
                              style: const TextStyle(color: CyberpunkTheme.textSecondary, fontSize: 11),
                            ),
                          ],
                        ),
                        Text(
                          '${sector.resourceLevel.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: _getSectorTypeColor(sector.type),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate(delay: (index * 50).ms).fadeIn(duration: 300.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  int _calculateGridSize(List<QuantumSector> sectors, bool isDesktop, bool isTablet) {
    final count = sectors.length;
    if (isDesktop) return min(count, 6);
    if (isTablet) return min(count, 4);
    return sqrt(count).round().clamp(2, 4);
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: CyberpunkTheme.warningNeon),
            SizedBox(width: 8),
            Text('RESET SYSTEM'),
          ],
        ),
        content: const Text(
          'This will reset all game progress. Are you sure you want to continue?',
          style: TextStyle(color: CyberpunkTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.refresh(gameStateNotifierProvider);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CyberpunkTheme.errorNeon,
            ),
            child: const Text('RESET'),
          ),
        ],
      ),
    );
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
}
