// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseHelperHash() => r'd9a91b257d3ed9a4f2d87bd829e17dc900678685';

/// See also [databaseHelper].
@ProviderFor(databaseHelper)
final databaseHelperProvider = AutoDisposeProvider<DatabaseHelper>.internal(
  databaseHelper,
  name: r'databaseHelperProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseHelperHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseHelperRef = AutoDisposeProviderRef<DatabaseHelper>;
String _$quantumEngineHash() => r'55c833abb334c5b906cfc4741a0bc1dcde72e733';

/// See also [quantumEngine].
@ProviderFor(quantumEngine)
final quantumEngineProvider = AutoDisposeFutureProvider<QuantumEngine>.internal(
  quantumEngine,
  name: r'quantumEngineProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quantumEngineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuantumEngineRef = AutoDisposeFutureProviderRef<QuantumEngine>;
String _$gameConfigHash() => r'940b83a856ff3ed98ecd1a67a15a4fa5d9ffefde';

/// See also [gameConfig].
@ProviderFor(gameConfig)
final gameConfigProvider = AutoDisposeFutureProvider<GameConfig>.internal(
  gameConfig,
  name: r'gameConfigProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameConfigRef = AutoDisposeFutureProviderRef<GameConfig>;
String _$currentTimelineHash() => r'f6c38cb32f3e512bf74616ca468707272d762325';

/// See also [currentTimeline].
@ProviderFor(currentTimeline)
final currentTimelineProvider =
    AutoDisposeFutureProvider<QuantumTimeline?>.internal(
  currentTimeline,
  name: r'currentTimelineProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentTimelineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentTimelineRef = AutoDisposeFutureProviderRef<QuantumTimeline?>;
String _$sectorsHash() => r'3f05496a6409ba2fba69c413bd8b2fb66c43d7a3';

/// See also [sectors].
@ProviderFor(sectors)
final sectorsProvider = AutoDisposeFutureProvider<List<QuantumSector>>.internal(
  sectors,
  name: r'sectorsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sectorsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SectorsRef = AutoDisposeFutureProviderRef<List<QuantumSector>>;
String _$resourcesHash() => r'2b7108d41c12134e8b15e4b4e18f20e43922bcc5';

/// See also [resources].
@ProviderFor(resources)
final resourcesProvider = AutoDisposeFutureProvider<List<Resource>>.internal(
  resources,
  name: r'resourcesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$resourcesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResourcesRef = AutoDisposeFutureProviderRef<List<Resource>>;
String _$allTimelinesHash() => r'9bbf5263f2c71df7a5d9e0c5d4bbe5ee72ffae68';

/// See also [allTimelines].
@ProviderFor(allTimelines)
final allTimelinesProvider =
    AutoDisposeFutureProvider<List<QuantumTimeline>>.internal(
  allTimelines,
  name: r'allTimelinesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTimelinesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTimelinesRef = AutoDisposeFutureProviderRef<List<QuantumTimeline>>;
String _$gameStateNotifierHash() => r'604a6857aaf1b8d8102dd9aec6f03cc69db9593f';

/// See also [GameStateNotifier].
@ProviderFor(GameStateNotifier)
final gameStateNotifierProvider =
    AutoDisposeAsyncNotifierProvider<GameStateNotifier, GameStateData>.internal(
  GameStateNotifier.new,
  name: r'gameStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameStateNotifier = AutoDisposeAsyncNotifier<GameStateData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
