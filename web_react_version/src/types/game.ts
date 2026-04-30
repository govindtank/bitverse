export interface QuantumSector {
  id: string;
  gridX: number;
  gridY: number;
  name: string;
  type: string;
  resourceLevel: number;
  population: number;
  buildings: string[];
  createdAt: string;
}

export interface Resource {
  id: string;
  type: ResourceType;
  value: number;
  maxCapacity: number;
  productionRate: number;
  consumptionRate: number;
}

export interface Building {
  id: string;
  name: string;
  type: BuildingType;
  level: number;
  resourceCost: number;
  resourceOutput: number;
  description: string;
}

export interface QuantumTimeline {
  id: string;
  name: string;
  sequenceNumber: number;
  isCurrent: boolean;
  createdAt: string;
  sectorIds: string[];
}

export interface GameConfig {
  id: string;
  gridSize: number;
  maxTimelineBranches: number;
  allowParallelPlay: boolean;
  autoSaveEnabled: boolean;
}

export interface GameState {
  timeline: QuantumTimeline | null;
  sectors: QuantumSector[];
  resources: Resource[];
  config: GameConfig;
  isInitialized: boolean;
}

export const ResourceTypes = {
  ENERGY: 'energy',
  DATA: 'data',
  MATTER: 'matter',
  QUANTUM: 'quantum',
  POPULATION: 'population',
} as const;

export const BuildingTypes = {
  RESIDENTIAL: 'residential',
  COMMERCIAL: 'commercial',
  INDUSTRIAL: 'industrial',
  TECH: 'tech',
  INFRASTRUCTURE: 'infrastructure',
} as const;

export type ResourceType = typeof ResourceTypes[keyof typeof ResourceTypes];
export type BuildingType = typeof BuildingTypes[keyof typeof BuildingTypes];

export const defaultConfig: GameConfig = {
  id: 'default',
  gridSize: 8,
  maxTimelineBranches: 5,
  allowParallelPlay: true,
  autoSaveEnabled: true,
};