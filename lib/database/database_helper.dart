import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/all_models.dart';

/// Database helper for BitVerse - handles database operations
/// Uses IndexedDB on web, SQLite on mobile/desktop
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  bool _initialized = false;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (!_initialized) {
      await _initDB();
      _initialized = true;
    }

    return _database!;
  }

  Future<void> _initDB() async {
    if (kIsWeb) {
      // On web, use in-memory database
      _database = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: _createDB,
      );
    } else {
      // On native platforms, use file-based SQLite
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'bitverse.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    }
  }

  Future<void> _createDB(Database db, int oldVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS timelines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        sequence_number INTEGER NOT NULL,
        is_current INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        sector_ids TEXT DEFAULT '[]'
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sectors (
        id TEXT PRIMARY KEY,
        grid_x INTEGER NOT NULL,
        grid_y INTEGER NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        resource_level REAL DEFAULT 50.0,
        population INTEGER DEFAULT 100,
        buildings TEXT DEFAULT '[]',
        created_at TEXT NOT NULL,
        metadata TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS resources (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        value REAL DEFAULT 50.0,
        max_capacity INTEGER DEFAULT 100,
        production_rate REAL DEFAULT 0.0,
        consumption_rate REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS buildings (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        level INTEGER DEFAULT 1,
        resource_cost REAL DEFAULT 0.0,
        resource_output INTEGER DEFAULT 0,
        description TEXT DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS quantum_states (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        entropy REAL DEFAULT 0.5,
        state_name TEXT DEFAULT 'Initialized'
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS game_config (
        id TEXT PRIMARY KEY,
        grid_size INTEGER DEFAULT 8,
        max_timeline_branches INTEGER DEFAULT 5,
        allow_parallel_play INTEGER DEFAULT 1,
        auto_save_enabled INTEGER DEFAULT 1
      )
    ''');

    await db.execute('CREATE INDEX IF NOT EXISTS idx_sectors_xy ON sectors(grid_x, grid_y)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_timelines_current ON timelines(is_current)');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE sectors ADD COLUMN metadata TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('CREATE INDEX IF NOT EXISTS idx_sectors_xy ON sectors(grid_x, grid_y)');
    }
  }

  // Timeline operations
  Future<void> insertTimeline(QuantumTimeline timeline) async {
    final db = await database;
    await db.insert('timelines', timeline.toJson());
  }

  Future<QuantumTimeline?> getTimeline(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'timelines',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return QuantumTimeline.fromJson(maps.first);
    }
    return null;
  }

  Future<QuantumTimeline?> getCurrentTimeline() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'timelines',
      where: 'is_current = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return QuantumTimeline.fromJson(maps.first);
    }
    return null;
  }

  Future<List<QuantumTimeline>> getAllTimelines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('timelines');
    return maps.map((json) => QuantumTimeline.fromJson(json)).toList();
  }

  // Sector operations
  Future<void> insertSector(QuantumSector sector) async {
    final db = await database;
    await db.insert('sectors', sector.toJson());
  }

  Future<QuantumSector?> getSector(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sectors',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return QuantumSector.fromJson(maps.first);
    }
    return null;
  }

  Future<List<QuantumSector>> getAllSectors() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sectors');
    return maps.map((json) => QuantumSector.fromJson(json)).toList();
  }

  Future<List<QuantumSector>> getSectorsInGrid(int gridX, int gridY, int radius) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sectors',
      where: 'grid_x BETWEEN ? AND ? AND grid_y BETWEEN ? AND ?',
      whereArgs: [gridX - radius, gridX + radius, gridY - radius, gridY + radius],
    );
    return maps.map((json) => QuantumSector.fromJson(json)).toList();
  }

  Future<void> updateSector(QuantumSector sector) async {
    final db = await database;
    await db.update(
      'sectors',
      sector.toJson(),
      where: 'id = ?',
      whereArgs: [sector.id],
    );
  }

  Future<void> deleteSector(String id) async {
    final db = await database;
    await db.delete('sectors', where: 'id = ?', whereArgs: [id]);
  }

  // Resource operations
  Future<void> insertResource(Resource resource) async {
    final db = await database;
    await db.insert('resources', resource.toJson());
  }

  Future<Resource?> getResource(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'resources',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Resource.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Resource>> getAllResources() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('resources');
    return maps.map((json) => Resource.fromJson(json)).toList();
  }

  Future<void> updateResource(Resource resource) async {
    final db = await database;
    await db.update(
      'resources',
      resource.toJson(),
      where: 'id = ?',
      whereArgs: [resource.id],
    );
  }

  // Building operations (per sector)
  Future<void> insertBuilding(String sectorId, String buildingData) async {
    final db = await database;
    final result = await db.query('sectors', where: 'id = ?', whereArgs: [sectorId]);
    if (result.isNotEmpty) {
      final buildingsStr = result.first['buildings'] as String? ?? '[]';
      final currentBuildings = List<String>.from(jsonDecode(buildingsStr));
      final updatedBuildings = [...currentBuildings, buildingData];
      await db.update(
        'sectors',
        {'buildings': jsonEncode(updatedBuildings)},
        where: 'id = ?',
        whereArgs: [sectorId],
      );
    }
  }

  // Quantum state operations
  Future<void> insertQuantumState(QuantumState state) async {
    final db = await database;
    await db.insert('quantum_states', {
      'id': state.id,
      'timestamp': state.timestamp.toIso8601String(),
      'entropy': state.entropy,
      'state_name': state.stateName,
    });
  }

  Future<List<QuantumState>> getRecentStates(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'quantum_states',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return maps.map((json) => QuantumState.fromJson(json)).toList();
  }

  // Game config operations
  Future<GameConfig> getGameConfig() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('game_config');
    if (maps.isNotEmpty) {
      return GameConfig.fromJson(maps.first);
    }
    return defaultConfig;
  }

  Future<void> setGameConfig(GameConfig config) async {
    final db = await database;
    await db.insert(
      'game_config',
      config.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      _initialized = false;
    }
  }
}
