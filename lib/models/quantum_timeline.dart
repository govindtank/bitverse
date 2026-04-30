import 'package:uuid/uuid.dart';

/// Represents a quantum timeline - parallel reality branch
class QuantumTimeline {
  final String id;
  final String name;        // Timeline name (e.g., "Prime", "Alt-Alpha")
  final int sequenceNumber;     // Branch order
  final bool isCurrent;         // Whether this is the active timeline
  final DateTime createdAt;
  final List<String> sectorIds;   // Sectors in this timeline
  
  QuantumTimeline({
    required this.id,
    required this.name,
    required this.sequenceNumber,
    this.isCurrent = false,
    DateTime? createdAt,
    List<String>? sectorIds,
  }) : sectorIds = sectorIds ?? [],
       createdAt = createdAt ?? DateTime.now();

  factory QuantumTimeline.current() {
    return QuantumTimeline(
      id: const Uuid().v4(),
      name: 'Prime',
      sequenceNumber: 0,
      isCurrent: true,
    );
  }

  factory QuantumTimeline.fromJson(Map<String, dynamic> json) {
    return QuantumTimeline(
      id: json['id'] as String,
      name: json['name'] as String,
      sequenceNumber: json['sequenceNumber'] as int,
      isCurrent: json['isCurrent'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sectorIds: List<String>.from(json['sectorIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sequenceNumber': sequenceNumber,
        'isCurrent': isCurrent,
        'createdAt': createdAt.toIso8601String(),
        'sectorIds': sectorIds,
      };

  @override
  String toString() => 'QuantumTimeline($name, #$sequenceNumber)';
}
