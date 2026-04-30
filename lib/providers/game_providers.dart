import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/all_models.dart';
import '../services/quantum_engine.dart';
import '../database/database_helper.dart';

part 'game_providers.g.dart';

// Singleton database provider
@riverpod
DatabaseHelper databaseHelper(Ref ref) {
  return DatabaseHelper();
}

// Quantum engine provider
@riverpod
Future<QuantumEngine> quantumEngine(Ref ref) async {
  final engine = QuantumEngine();
  await engine.initialize();
  return engine;
}

// Game config provider
@riverpod
Future<GameConfig> gameConfig(Ref ref) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getGameConfig();
}

// Current timeline provider
@riverpod
Future<QuantumTimeline?> currentTimeline(Ref ref) async {
  final engine = await ref.watch(quantumEngineProvider.future);
  return await engine.getCurrentOrNewTimeline();
}

// Sectors provider
@riverpod
Future<List<QuantumSector>> sectors(Ref ref) async {
  final db = ref.watch(databaseHelperProvider);
  final sectors = await db.getAllSectors();

  // If no sectors exist, initialize grid
  if (sectors.isEmpty) {
    final engine = await ref.watch(quantumEngineProvider.future);
    final config = await ref.watch(gameConfigProvider.future);
    return await engine.initializeGrid(config.gridSize, DateTime.now().millisecondsSinceEpoch);
  }

  return sectors;
}

// Resources provider
@riverpod
Future<List<Resource>> resources(Ref ref) async {
  final db = ref.watch(databaseHelperProvider);
  final resources = await db.getAllResources();

  // If no resources exist, create default resources
  if (resources.isEmpty) {
    final defaultResources = [
      Resource(id: 'energy', type: ResourceType.energy, value: 50.0),
      Resource(id: 'data', type: ResourceType.data, value: 50.0),
      Resource(id: 'matter', type: ResourceType.matter, value: 50.0),
      Resource(id: 'quantum', type: ResourceType.quantum, value: 50.0),
      Resource(id: 'population', type: ResourceType.population, value: 100.0),
    ];

    for (final resource in defaultResources) {
      await db.insertResource(resource);
    }

    return defaultResources;
  }

  return resources;
}

// All timelines provider
@riverpod
Future<List<QuantumTimeline>> allTimelines(Ref ref) async {
  final db = ref.watch(databaseHelperProvider);
  return await db.getAllTimelines();
}

// Game state notifier
@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  Future<GameStateData> build() async {
    try {
      final timeline = await ref.watch(currentTimelineProvider.future);
      final sectors = await ref.watch(sectorsProvider.future);
      final resources = await ref.watch(resourcesProvider.future);
      final config = await ref.watch(gameConfigProvider.future);

      return GameStateData(
        timeline: timeline,
        sectors: sectors,
        resources: resources,
        config: config,
        isInitialized: true,
      );
    } catch (e) {
      // Return a default state if initialization fails
      return GameStateData(
        sectors: [],
        resources: [
          Resource(id: 'energy', type: ResourceType.energy, value: 50.0),
          Resource(id: 'data', type: ResourceType.data, value: 50.0),
          Resource(id: 'matter', type: ResourceType.matter, value: 50.0),
          Resource(id: 'quantum', type: ResourceType.quantum, value: 50.0),
          Resource(id: 'population', type: ResourceType.population, value: 100.0),
        ],
        config: defaultConfig,
        isInitialized: false,
      );
    }
  }

  Future<void> refreshSectors() async {
    try {
      final db = ref.read(databaseHelperProvider);
      final sectors = await db.getAllSectors();
      final currentState = await future;
      state = AsyncValue.data(currentState.copyWith(sectors: sectors));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshResources() async {
    try {
      final db = ref.read(databaseHelperProvider);
      final resources = await db.getAllResources();
      final currentState = await future;
      state = AsyncValue.data(currentState.copyWith(resources: resources));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateSector(QuantumSector sector) async {
    try {
      final db = ref.read(databaseHelperProvider);
      await db.updateSector(sector);
      await refreshSectors();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addBuilding(String sectorId, Building building) async {
    try {
      final db = ref.read(databaseHelperProvider);
      await db.insertBuilding(sectorId, building.toJson().toString());
      await refreshSectors();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

class GameStateData {
  final QuantumTimeline? timeline;
  final List<QuantumSector> sectors;
  final List<Resource> resources;
  final GameConfig config;
  final bool isInitialized;

  GameStateData({
    this.timeline,
    required this.sectors,
    required this.resources,
    required this.config,
    this.isInitialized = false,
  });

  GameStateData copyWith({
    QuantumTimeline? timeline,
    List<QuantumSector>? sectors,
    List<Resource>? resources,
    GameConfig? config,
    bool? isInitialized,
  }) {
    return GameStateData(
      timeline: timeline ?? this.timeline,
      sectors: sectors ?? this.sectors,
      resources: resources ?? this.resources,
      config: config ?? this.config,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
