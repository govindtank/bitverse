import '../models/quantum_sector.dart';

/// Represents the current quantum state of a city/simulation
class QuantumState {
  final String id;
  final DateTime timestamp;   // When this state was recorded
  final Map<int, int> grid;   // Grid layout: key = y * width + x, value = sectorId or null
  final List<QuantumSector> sectors;  // All sectors in current state
  final double entropy;        // Quantum entanglement measure (0.0 - 1.0)
  final String stateName;      // Human-readable state description
  
  QuantumState({
    required this.id,
    required this.timestamp,
    required this.grid,
    required this.sectors,
    this.entropy = 0.5,
    this.stateName = 'Initialized',
  });

  factory QuantumState.fromJson(Map<String, dynamic> json) {
    return QuantumState(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      grid: Map<int, int>.from(json['grid'] ?? {}),
      sectors: (json['sectors'] as List<dynamic>?)
          ?.map((s) => QuantumSector.fromJson(s))
          .toList() ?? [],
      entropy: (json['entropy'] as num?)?.toDouble() ?? 0.5,
      stateName: json['stateName'] as String? ?? 'Initialized',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'grid': grid,
        'sectors': sectors.map((s) => s.toJson()).toList(),
        'entropy': entropy,
        'stateName': stateName,
      };

  @override
  String toString() => 'QuantumState($id) - $stateName';
}
