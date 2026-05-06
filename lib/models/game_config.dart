/// Story chapters for narrative progression
enum StoryChapter {
  exodus,      // Humanity's escape from dying Earth
  foundation,  // Building first quantum gates
  expansion,   // Growing the quantum network
  ascension,   // Achieving quantum mastery
  dominion,    // Controlling multiple timelines
}

/// Game objectives with rewards and conditions
class GameObjective {
  final String id;
  final String title;
  final String description;
  final String storyContext;
  final Map<String, dynamic> conditions; // Resource thresholds, sector counts, etc.
  final Map<String, dynamic> rewards;    // Resources, unlocks, story progression
  final bool isCompleted;
  final bool isActive;

  GameObjective({
    required this.id,
    required this.title,
    required this.description,
    required this.storyContext,
    required this.conditions,
    required this.rewards,
    this.isCompleted = false,
    this.isActive = false,
  });

  factory GameObjective.fromJson(Map<String, dynamic> json) {
    return GameObjective(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      storyContext: json['storyContext'],
      conditions: json['conditions'],
      rewards: json['rewards'],
      isCompleted: json['isCompleted'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'storyContext': storyContext,
        'conditions': conditions,
        'rewards': rewards,
        'isCompleted': isCompleted,
        'isActive': isActive,
      };
}

/// Random events that affect gameplay
class GameEvent {
  final String id;
  final String title;
  final String description;
  final String storyFlavor;
  final Map<String, dynamic> effects; // Resource changes, sector modifications
  final List<String> choices;          // Player response options
  final Map<String, Map<String, dynamic>> choiceEffects; // Effects per choice
  final bool isActive;
  final DateTime? triggerTime;

  GameEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.storyFlavor,
    required this.effects,
    required this.choices,
    required this.choiceEffects,
    this.isActive = false,
    this.triggerTime,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      storyFlavor: json['storyFlavor'],
      effects: json['effects'],
      choices: json['choices'],
      choiceEffects: json['choiceEffects'],
      isActive: json['isActive'] ?? false,
      triggerTime: json['triggerTime'] != null ? DateTime.parse(json['triggerTime']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'storyFlavor': storyFlavor,
        'effects': effects,
        'choices': choices,
        'choiceEffects': choiceEffects,
        'isActive': isActive,
        'triggerTime': triggerTime?.toIso8601String(),
      };
}

/// Enhanced game configuration with story and gameplay elements
class GameConfig {
  final String id;
  final int gridSize;
  final int maxTimelineBranches;
  final bool allowParallelPlay;
  final bool autoSaveEnabled;
  final StoryChapter currentChapter;
  final List<GameObjective> objectives;
  final List<GameEvent> activeEvents;
  final int gameTurn;              // Current game turn/cycle
  final double storyProgression;   // 0.0 to 1.0 story completion
  final Map<String, bool> unlockedFeatures; // Buildings, tech, abilities unlocked

  GameConfig({
    required this.id,
    this.gridSize = 8,
    this.maxTimelineBranches = 5,
    this.allowParallelPlay = true,
    this.autoSaveEnabled = true,
    this.currentChapter = StoryChapter.exodus,
    List<GameObjective>? objectives,
    List<GameEvent>? activeEvents,
    this.gameTurn = 0,
    this.storyProgression = 0.0,
    Map<String, bool>? unlockedFeatures,
  }) :
    objectives = objectives ?? _getDefaultObjectives(),
    activeEvents = activeEvents ?? [],
    unlockedFeatures = unlockedFeatures ?? _getDefaultUnlocks();

  static List<GameObjective> _getDefaultObjectives() {
    return [
      GameObjective(
        id: 'first_gate',
        title: 'Build the First Gate',
        description: 'Construct your first Quantum Gate to begin humanity\'s exodus from Earth.',
        storyContext: 'Earth\'s final days approach. Your first gate will be humanity\'s lifeline to the quantum realms.',
        conditions: {'sectors': 1, 'population': 1000},
        rewards: {'unlock': 'quantum_gate', 'resources': {'quantum': 100}},
        isActive: true,
      ),
      GameObjective(
        id: 'population_boom',
        title: 'Gather the Survivors',
        description: 'Reach 10,000 population to establish a sustainable colony.',
        storyContext: 'More survivors emerge from Earth\'s ruins. They need shelter and hope.',
        conditions: {'population': 10000},
        rewards: {'unlock': 'residential_complex', 'resources': {'population': 2000}},
      ),
    ];
  }

  static Map<String, bool> _getDefaultUnlocks() {
    return {
      'basic_housing': true,
      'resource_scanner': true,
      'emergency_shelter': true,
    };
  }

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      id: json['id'] as String? ?? 'default',
      gridSize: json['gridSize'] as int? ?? 8,
      maxTimelineBranches: json['maxTimelineBranches'] as int? ?? 5,
      allowParallelPlay: json['allowParallelPlay'] == 1 || json['allowParallelPlay'] == true,
      autoSaveEnabled: json['autoSaveEnabled'] == 1 || json['autoSaveEnabled'] == true,
      currentChapter: StoryChapter.values[json['currentChapter'] as int? ?? 0],
      objectives: (json['objectives'] as List<dynamic>?)
          ?.map((o) => GameObjective.fromJson(o))
          .toList() ?? _getDefaultObjectives(),
      activeEvents: (json['activeEvents'] as List<dynamic>?)
          ?.map((e) => GameEvent.fromJson(e))
          .toList() ?? [],
      gameTurn: json['gameTurn'] as int? ?? 0,
      storyProgression: (json['storyProgression'] as num?)?.toDouble() ?? 0.0,
      unlockedFeatures: Map<String, bool>.from(json['unlockedFeatures'] ?? _getDefaultUnlocks()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gridSize': gridSize,
        'maxTimelineBranches': maxTimelineBranches,
        'allowParallelPlay': allowParallelPlay ? 1 : 0,
        'autoSaveEnabled': autoSaveEnabled ? 1 : 0,
        'currentChapter': currentChapter.index,
        'objectives': objectives.map((o) => o.toJson()).toList(),
        'activeEvents': activeEvents.map((e) => e.toJson()).toList(),
        'gameTurn': gameTurn,
        'storyProgression': storyProgression,
        'unlockedFeatures': unlockedFeatures,
      };

  GameConfig copyWith({
    String? id,
    int? gridSize,
    int? maxTimelineBranches,
    bool? allowParallelPlay,
    bool? autoSaveEnabled,
    StoryChapter? currentChapter,
    List<GameObjective>? objectives,
    List<GameEvent>? activeEvents,
    int? gameTurn,
    double? storyProgression,
    Map<String, bool>? unlockedFeatures,
  }) {
    return GameConfig(
      id: id ?? this.id,
      gridSize: gridSize ?? this.gridSize,
      maxTimelineBranches: maxTimelineBranches ?? this.maxTimelineBranches,
      allowParallelPlay: allowParallelPlay ?? this.allowParallelPlay,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      currentChapter: currentChapter ?? this.currentChapter,
      objectives: objectives ?? this.objectives,
      activeEvents: activeEvents ?? this.activeEvents,
      gameTurn: gameTurn ?? this.gameTurn,
      storyProgression: storyProgression ?? this.storyProgression,
      unlockedFeatures: unlockedFeatures ?? this.unlockedFeatures,
    );
  }
}

/// Default game configuration
GameConfig defaultConfig = GameConfig(id: 'default');
