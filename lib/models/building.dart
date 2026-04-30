/// Types of quantum buildings available for sector development
enum BuildingType {
  residential,      // Houses, apartments
  commercial,       // Shops, offices
  industrial,       // Factories, power plants
  tech,            // Quantum processors, research labs
  infrastructure,   // Roads, utilities
}

/// Represents a building in a quantum sector
class Building {
  final String id;
  final String name;        // Building name (e.g., "Neo Tower", "Quantum Core")
  final BuildingType type;
  int level;                 // Development level (1-10)
  double resourceCost;       // Resource cost to build
  int resourceOutput;        // Resources produced per tick
  String description;

  Building({
    required this.id,
    required this.name,
    required this.type,
    this.level = 1,
    this.resourceCost = 0.0,
    this.resourceOutput = 0,
    required this.description,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as String,
      name: json['name'] as String,
      type: BuildingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => BuildingType.residential,
      ),
      level: json['level'] as int? ?? 1,
      resourceCost: (json['resourceCost'] as num?)?.toDouble() ?? 0.0,
      resourceOutput: json['resourceOutput'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toString().split('.').last,
        'level': level,
        'resourceCost': resourceCost,
        'resourceOutput': resourceOutput,
        'description': description,
      };

  @override
  String toString() => '$name ($type) - Level $level';
}
