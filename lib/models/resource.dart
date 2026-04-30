/// Resource types available in BitVerse
enum ResourceType {
  energy,          // Power supply for systems
  data,            // Computational/data resources
  matter,          // Physical building materials
  quantum,         // Quantum computing power
  population,      // Citizens to populate sectors
}

/// Represents a resource with current value and type
class Resource {
  final String id;
  final ResourceType type;
  double value;              // Current amount (0 - 100% or absolute)
  int maxCapacity;           // Maximum capacity
  double productionRate;     // Units per time tick
  double consumptionRate;    // Units per time tick
  
  Resource({
    required this.id,
    required this.type,
    this.value = 50.0,
    this.maxCapacity = 100,
    this.productionRate = 0.0,
    this.consumptionRate = 0.0,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as String,
      type: ResourceType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ResourceType.energy,
      ),
      value: (json['value'] as num?)?.toDouble() ?? 50.0,
      maxCapacity: json['maxCapacity'] as int? ?? 100,
      productionRate: (json['productionRate'] as num?)?.toDouble() ?? 0.0,
      consumptionRate: (json['consumptionRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString().split('.').last,
        'value': value,
        'maxCapacity': maxCapacity,
        'productionRate': productionRate,
        'consumptionRate': consumptionRate,
      };

  @override
  String toString() => '${type.toString().split('.').last}: ${value.toStringAsFixed(1)}/$maxCapacity';
}
