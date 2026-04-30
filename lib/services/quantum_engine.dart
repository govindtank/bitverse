import 'dart:math';
import '../models/all_models.dart';
import '../database/database_helper.dart';

/// Core quantum simulation engine for BitVerse
class QuantumEngine {
  final DatabaseHelper _db = DatabaseHelper();
  bool _isRunning = false;
  
  /// Initialize the quantum simulation engine
  Future<void> initialize() async {
    await _db.close();
    await _db.database; // Reopen database
    _isRunning = true;
  }

  /// Create or get current timeline
  Future<QuantumTimeline> getCurrentOrNewTimeline() async {
    final current = await _db.getCurrentTimeline();
    if (current != null) return current;
    
    // Create new default timeline
    final timeline = QuantumTimeline.current();
    await _db.insertTimeline(timeline);
    return timeline;
  }

  /// Initialize grid with empty sectors
  Future<List<QuantumSector>> initializeGrid(int gridSize, int seed) async {
    final List<QuantumSector> sectors = [];
    
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        final sectorId = 'sector_${seed}_${x}_$y';
        final randomType = _getRandomSectorType();
        
        final sector = QuantumSector(
          id: sectorId,
          gridX: x,
          gridY: y,
          name: _generateSectorName(x, y),
          type: randomType,
          resourceLevel: 50.0,
          population: 100 + (x * y) % 200,
        );
        
        sectors.add(sector);
        
        // Insert each sector into database
        await _db.insertSector(sector);
      }
    }
    
    return sectors;
  }

  /// Get random sector type for initialization
  String _getRandomSectorType() {
    const types = ['residential', 'commercial', 'industrial', 'tech', 'infrastructure'];
    return types[DateTime.now().millisecond % 5];
  }

  /// Generate a unique sector name based on coordinates
  String _generateSectorName(int x, int y) {
    final zones = ['Neon', 'Quantum', 'Cyber', 'Solar', 'Plasma'];
    final names = ['Hub', 'Park', 'District', 'Zone', 'Spire', 'Core', 'Gate', 'Bay'];
    
    return '${zones[x % zones.length]} ${names[y % names.length]}';
  }

  /// Simulate one quantum tick (game tick)
  Future<void> tick(double deltaTime) async {
    if (!_isRunning) return;

    // Get all sectors
    final sectors = await _db.getAllSectors();
    
    for (final sector in sectors) {
      // Resource generation/consumption
      final resources = await _db.getAllResources();
      
      for (final resource in resources) {
        final deltaTimeSeconds = deltaTime / 1000;
        
        // Update production
        if (resource.productionRate > 0) {
          final produced = resource.productionRate * deltaTimeSeconds;
          final updatedSector = sector.copyWith(
            resourceLevel: min(100.0, sector.resourceLevel + produced),
          );
          
          await _db.updateSector(updatedSector);
        }
        
        // Update consumption
        if (resource.consumptionRate > 0) {
          final consumed = resource.consumptionRate * deltaTimeSeconds;
          final updatedSector = sector.copyWith(
            resourceLevel: max(0.0, sector.resourceLevel - consumed),
          );
          
          await _db.updateSector(updatedSector);
        }
      }
    }
  }

  /// Close and cleanup engine
  Future<void> shutdown() async {
    _isRunning = false;
    await _db.close();
  }
}
