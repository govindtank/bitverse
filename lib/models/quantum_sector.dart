import 'dart:convert';

/// A sector represents a district within a quantum city across timelines
class QuantumSector {
  final String id;
  final int gridX;          // X coordinate in the quantum grid
  final int gridY;          // Y coordinate in the quantum grid
  final String name;        // Sector name (e.g., "Neon District", "Quantum Park")
  final String type;        // Sector type: residential, commercial, industrial, etc.
  final double resourceLevel;  // Resource level (0.0 - 100.0)
  final int population;     // Current population
  final List<String> buildings;  // Buildings in this sector
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  QuantumSector({
    required this.id,
    required this.gridX,
    required this.gridY,
    required this.name,
    required this.type,
    this.resourceLevel = 50.0,
    this.population = 100,
    List<String>? buildings,
    DateTime? createdAt,
    this.metadata,
  }) : buildings = buildings ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'gridX': gridX,
        'gridY': gridY,
        'name': name,
        'type': type,
        'resourceLevel': resourceLevel,
        'population': population,
        'buildings': jsonEncode(buildings),
        'createdAt': createdAt.toIso8601String(),
        'metadata': metadata != null ? jsonEncode(metadata) : null,
      };

  factory QuantumSector.fromJson(Map<String, dynamic> json) {
    return QuantumSector(
      id: json['id'] as String,
      gridX: json['gridX'] as int,
      gridY: json['gridY'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      resourceLevel: (json['resourceLevel'] as num?)?.toDouble() ?? 50.0,
      population: json['population'] as int? ?? 100,
      buildings: List<String>.from(
        json['buildings'] is String
            ? jsonDecode(json['buildings'] as String)
            : json['buildings'] ?? [],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] == null
          ? null
          : json['metadata'] is String
              ? Map<String, dynamic>.from(jsonDecode(json['metadata'] as String))
              : Map<String, dynamic>.from(json['metadata'] as Map),
    );
  }

  QuantumSector copyWith({
    String? id,
    int? gridX,
    int? gridY,
    String? name,
    String? type,
    double? resourceLevel,
    int? population,
    List<String>? buildings,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return QuantumSector(
      id: id ?? this.id,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
      name: name ?? this.name,
      type: type ?? this.type,
      resourceLevel: resourceLevel ?? this.resourceLevel,
      population: population ?? this.population,
      buildings: buildings ?? this.buildings,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() => 'QuantumSector(id: $id, ($gridX,$gridY), $name, $type, ${resourceLevel.toStringAsFixed(0)})';
}
