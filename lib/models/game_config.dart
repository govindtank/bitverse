/// Configuration settings for the BitVerse simulation
class GameConfig {
  final String id;
  final int gridSize;          // Grid dimensions (e.g., 10x10)
  final int maxTimelineBranches;
  final bool allowParallelPlay;   // Enable parallel timeline play
  final bool autoSaveEnabled;     // Auto-save interval in seconds

  GameConfig({
    required this.id,
    this.gridSize = 8,
    this.maxTimelineBranches = 5,
    this.allowParallelPlay = true,
    this.autoSaveEnabled = true,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      id: json['id'] as String? ?? 'default',
      gridSize: json['gridSize'] as int? ?? 8,
      maxTimelineBranches: json['maxTimelineBranches'] as int? ?? 5,
      allowParallelPlay: json['allowParallelPlay'] == 1 || json['allowParallelPlay'] == true,
      autoSaveEnabled: json['autoSaveEnabled'] == 1 || json['autoSaveEnabled'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gridSize': gridSize,
        'maxTimelineBranches': maxTimelineBranches,
        'allowParallelPlay': allowParallelPlay ? 1 : 0,
        'autoSaveEnabled': autoSaveEnabled ? 1 : 0,
      };
}

/// Default game configuration
GameConfig defaultConfig = GameConfig(id: 'default');
