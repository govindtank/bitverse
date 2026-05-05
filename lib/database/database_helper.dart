import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/all_models.dart';

/// Database helper for BitVerse.
/// On native (Android/iOS/desktop): uses sqflite file-based SQLite.
/// On web: uses in-memory Maps (data is session-only, not persisted).
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // ── Native SQLite ──────────────────────────────────────────────────────────
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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bitverse.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS timelines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        sequenceNumber INTEGER NOT NULL,
        isCurrent INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        sectorIds TEXT DEFAULT '[]'
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sectors (
        id TEXT PRIMARY KEY,
        gridX INTEGER NOT NULL,
        gridY INTEGER NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        resourceLevel REAL DEFAULT 50.0,
        population INTEGER DEFAULT 100,
        buildings TEXT DEFAULT '[]',
        createdAt TEXT NOT NULL,
        metadata TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS resources (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        value REAL DEFAULT 50.0,
        maxCapacity INTEGER DEFAULT 100,
        productionRate REAL DEFAULT 0.0,
        consumptionRate REAL DEFAULT 0.0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS buildings (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        level INTEGER DEFAULT 1,
        resourceCost REAL DEFAULT 0.0,
        resourceOutput INTEGER DEFAULT 0,
        description TEXT DEFAULT ''
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quantum_states (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        entropy REAL DEFAULT 0.5,
        stateName TEXT DEFAULT 'Initialized'
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS game_config (
        id TEXT PRIMARY KEY,
        gridSize INTEGER DEFAULT 8,
        maxTimelineBranches INTEGER DEFAULT 5,
        allowParallelPlay INTEGER DEFAULT 1,
        autoSaveEnabled INTEGER DEFAULT 1
      )
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_sectors_xy ON sectors(gridX, gridY)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_timelines_current ON timelines(isCurrent)');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE sectors ADD COLUMN metadata TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('CREATE INDEX IF NOT EXISTS idx_sectors_xy ON sectors(gridX, gridY)');
    }
  }

  // ── Web in-memory store ────────────────────────────────────────────────────
  static final Map<String, List<Map<String, dynamic>>> _webStore = {
    'timelines': [],
    'sectors': [],
    'resources': [],
    'quantum_states': [],
    'game_config': [],
  };

  void _webInsert(String table, Map<String, dynamic> row) {
    _webStore[table]!.add(Map<String, dynamic>.from(row));
  }

  void _webUpdate(String table, String idKey, Map<String, dynamic> row) {
    final list = _webStore[table]!;
    final idx = list.indexWhere((r) => r[idKey] == row[idKey]);
    if (idx >= 0) list[idx] = Map<String, dynamic>.from(row);
  }

  void _webDelete(String table, String id) {
    _webStore[table]!.removeWhere((r) => r['id'] == id);
  }

  List<Map<String, dynamic>> _webQuery(String table) =>
      List<Map<String, dynamic>>.from(_webStore[table]!);

  // ── Timeline operations ────────────────────────────────────────────────────

  Future<void> insertTimeline(QuantumTimeline timeline) async {
    if (kIsWeb) {
      _webInsert('timelines', timeline.toJson());
      return;
    }
    final db = await database;
    await db.insert('timelines', timeline.toJson());
  }

  Future<QuantumTimeline?> getTimeline(String id) async {
    if (kIsWeb) {
      final row = _webQuery('timelines').where((r) => r['id'] == id).firstOrNull;
      return row != null ? QuantumTimeline.fromJson(row) : null;
    }
    final db = await database;
    final maps = await db.query('timelines', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? QuantumTimeline.fromJson(maps.first) : null;
  }

  Future<QuantumTimeline?> getCurrentTimeline() async {
    if (kIsWeb) {
      final row = _webQuery('timelines').where((r) => r['isCurrent'] == 1).firstOrNull;
      return row != null ? QuantumTimeline.fromJson(row) : null;
    }
    final db = await database;
    final maps = await db.query('timelines', where: 'isCurrent = ?', whereArgs: [1]);
    return maps.isNotEmpty ? QuantumTimeline.fromJson(maps.first) : null;
  }

  Future<List<QuantumTimeline>> getAllTimelines() async {
    if (kIsWeb) {
      return _webQuery('timelines').map(QuantumTimeline.fromJson).toList();
    }
    final db = await database;
    final maps = await db.query('timelines');
    return maps.map(QuantumTimeline.fromJson).toList();
  }

  // ── Sector operations ──────────────────────────────────────────────────────

  Future<void> insertSector(QuantumSector sector) async {
    if (kIsWeb) {
      _webInsert('sectors', sector.toJson());
      return;
    }
    final db = await database;
    await db.insert('sectors', sector.toJson());
  }

  Future<QuantumSector?> getSector(String id) async {
    if (kIsWeb) {
      final row = _webQuery('sectors').where((r) => r['id'] == id).firstOrNull;
      return row != null ? QuantumSector.fromJson(row) : null;
    }
    final db = await database;
    final maps = await db.query('sectors', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? QuantumSector.fromJson(maps.first) : null;
  }

  Future<List<QuantumSector>> getAllSectors() async {
    if (kIsWeb) {
      return _webQuery('sectors').map(QuantumSector.fromJson).toList();
    }
    final db = await database;
    final maps = await db.query('sectors');
    return maps.map(QuantumSector.fromJson).toList();
  }

  Future<List<QuantumSector>> getSectorsInGrid(int gridX, int gridY, int radius) async {
    if (kIsWeb) {
      return _webQuery('sectors').where((r) {
        final x = r['gridX'] as int;
        final y = r['gridY'] as int;
        return x >= gridX - radius && x <= gridX + radius &&
               y >= gridY - radius && y <= gridY + radius;
      }).map(QuantumSector.fromJson).toList();
    }
    final db = await database;
    final maps = await db.query(
      'sectors',
      where: 'gridX BETWEEN ? AND ? AND gridY BETWEEN ? AND ?',
      whereArgs: [gridX - radius, gridX + radius, gridY - radius, gridY + radius],
    );
    return maps.map(QuantumSector.fromJson).toList();
  }

  Future<void> updateSector(QuantumSector sector) async {
    if (kIsWeb) {
      _webUpdate('sectors', 'id', sector.toJson());
      return;
    }
    final db = await database;
    await db.update('sectors', sector.toJson(), where: 'id = ?', whereArgs: [sector.id]);
  }

  Future<void> deleteSector(String id) async {
    if (kIsWeb) {
      _webDelete('sectors', id);
      return;
    }
    final db = await database;
    await db.delete('sectors', where: 'id = ?', whereArgs: [id]);
  }

  // ── Resource operations ────────────────────────────────────────────────────

  Future<void> insertResource(Resource resource) async {
    if (kIsWeb) {
      _webInsert('resources', resource.toJson());
      return;
    }
    final db = await database;
    await db.insert('resources', resource.toJson());
  }

  Future<Resource?> getResource(String id) async {
    if (kIsWeb) {
      final row = _webQuery('resources').where((r) => r['id'] == id).firstOrNull;
      return row != null ? Resource.fromJson(row) : null;
    }
    final db = await database;
    final maps = await db.query('resources', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Resource.fromJson(maps.first) : null;
  }

  Future<List<Resource>> getAllResources() async {
    if (kIsWeb) {
      return _webQuery('resources').map(Resource.fromJson).toList();
    }
    final db = await database;
    final maps = await db.query('resources');
    return maps.map(Resource.fromJson).toList();
  }

  Future<void> updateResource(Resource resource) async {
    if (kIsWeb) {
      _webUpdate('resources', 'id', resource.toJson());
      return;
    }
    final db = await database;
    await db.update('resources', resource.toJson(), where: 'id = ?', whereArgs: [resource.id]);
  }

  // ── Building operations (stored inside sector's buildings list) ────────────

  Future<void> insertBuilding(String sectorId, String buildingData) async {
    if (kIsWeb) {
      final list = _webStore['sectors']!;
      final idx = list.indexWhere((r) => r['id'] == sectorId);
      if (idx >= 0) {
        final buildingsStr = list[idx]['buildings'] as String? ?? '[]';
        final current = List<String>.from(jsonDecode(buildingsStr));
        list[idx] = Map<String, dynamic>.from(list[idx])
          ..['buildings'] = jsonEncode([...current, buildingData]);
      }
      return;
    }
    final db = await database;
    final result = await db.query('sectors', where: 'id = ?', whereArgs: [sectorId]);
    if (result.isNotEmpty) {
      final buildingsStr = result.first['buildings'] as String? ?? '[]';
      final current = List<String>.from(jsonDecode(buildingsStr));
      await db.update(
        'sectors',
        {'buildings': jsonEncode([...current, buildingData])},
        where: 'id = ?',
        whereArgs: [sectorId],
      );
    }
  }

  // ── Quantum state operations ───────────────────────────────────────────────

  Future<void> insertQuantumState(QuantumState state) async {
    final row = {
      'id': state.id,
      'timestamp': state.timestamp.toIso8601String(),
      'entropy': state.entropy,
      'stateName': state.stateName,
    };
    if (kIsWeb) {
      _webInsert('quantum_states', row);
      return;
    }
    final db = await database;
    await db.insert('quantum_states', row);
  }

  Future<List<QuantumState>> getRecentStates(int limit) async {
    if (kIsWeb) {
      final rows = _webQuery('quantum_states')
        ..sort((a, b) => (b['timestamp'] as String).compareTo(a['timestamp'] as String));
      return rows.take(limit).map(QuantumState.fromJson).toList();
    }
    final db = await database;
    final maps = await db.query('quantum_states', orderBy: 'timestamp DESC', limit: limit);
    return maps.map(QuantumState.fromJson).toList();
  }

  // ── Game config operations ─────────────────────────────────────────────────

  Future<GameConfig> getGameConfig() async {
    if (kIsWeb) {
      final rows = _webQuery('game_config');
      return rows.isNotEmpty ? GameConfig.fromJson(rows.first) : defaultConfig;
    }
    final db = await database;
    final maps = await db.query('game_config');
    return maps.isNotEmpty ? GameConfig.fromJson(maps.first) : defaultConfig;
  }

  Future<void> setGameConfig(GameConfig config) async {
    if (kIsWeb) {
      final list = _webStore['game_config']!;
      final idx = list.indexWhere((r) => r['id'] == config.id);
      if (idx >= 0) {
        list[idx] = config.toJson();
      } else {
        list.add(config.toJson());
      }
      return;
    }
    final db = await database;
    await db.insert('game_config', config.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  Future<void> close() async {
    if (kIsWeb) {
      // Clear in-memory store on web
      for (final key in _webStore.keys) {
        _webStore[key]!.clear();
      }
      return;
    }
    if (_database != null) {
      await _database!.close();
      _database = null;
      _initialized = false;
    }
  }
}
