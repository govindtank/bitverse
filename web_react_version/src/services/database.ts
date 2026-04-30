import { openDB } from 'idb';
import type { DBSchema, IDBPDatabase } from 'idb';
import type { QuantumSector, Resource, Building, QuantumTimeline, GameConfig } from '../types/game';
import { ResourceTypes } from '../types/game';

interface BitVerseDB extends DBSchema {
  timelines: {
    key: string;
    value: QuantumTimeline;
  };
  sectors: {
    key: string;
    value: QuantumSector;
    indexes: { 'by-grid': [number, number] };
  };
  resources: {
    key: string;
    value: Resource;
  };
  buildings: {
    key: string;
    value: Building;
  };
  config: {
    key: string;
    value: GameConfig;
  };
}

class DatabaseService {
  private db: IDBPDatabase<BitVerseDB> | null = null;

  async initialize() {
    if (this.db) return this.db;

    this.db = await openDB<BitVerseDB>('bitverse-db', 1, {
      upgrade(db) {
        // Timelines store
        db.createObjectStore('timelines', { keyPath: 'id' });

        // Sectors store with grid index
        const sectorsStore = db.createObjectStore('sectors', { keyPath: 'id' });
        sectorsStore.createIndex('by-grid', ['gridX', 'gridY']);

        // Other stores
        db.createObjectStore('resources', { keyPath: 'id' });
        db.createObjectStore('buildings', { keyPath: 'id' });
        db.createObjectStore('config', { keyPath: 'id' });
      },
    });

    return this.db;
  }

  async getGameConfig(): Promise<GameConfig> {
    const db = await this.initialize();
    const config = await db.get('config', 'default');
    return config || {
      id: 'default',
      gridSize: 8,
      maxTimelineBranches: 5,
      allowParallelPlay: true,
      autoSaveEnabled: true,
    };
  }

  async setGameConfig(config: GameConfig): Promise<void> {
    const db = await this.initialize();
    await db.put('config', config);
  }

  async getCurrentTimeline(): Promise<QuantumTimeline | null> {
    const db = await this.initialize();
    const timelines = await db.getAll('timelines');
    return timelines.find(t => t.isCurrent) || null;
  }

  async createTimeline(name: string): Promise<QuantumTimeline> {
    const db = await this.initialize();
    const timeline: QuantumTimeline = {
      id: `timeline_${Date.now()}`,
      name,
      sequenceNumber: 0,
      isCurrent: true,
      createdAt: new Date().toISOString(),
      sectorIds: [],
    };
    await db.put('timelines', timeline);
    return timeline;
  }

  async getAllSectors(): Promise<QuantumSector[]> {
    const db = await this.initialize();
    return await db.getAll('sectors');
  }

  async initializeGrid(gridSize: number): Promise<QuantumSector[]> {
    const db = await this.initialize();
    const sectors: QuantumSector[] = [];

    for (let x = 0; x < gridSize; x++) {
      for (let y = 0; y < gridSize; y++) {
        const sector: QuantumSector = {
          id: `sector_${x}_${y}`,
          gridX: x,
          gridY: y,
          name: this.generateSectorName(x, y),
          type: this.getRandomSectorType(),
          resourceLevel: 50,
          population: 100 + Math.floor(Math.random() * 200),
          buildings: [],
          createdAt: new Date().toISOString(),
        };
        sectors.push(sector);
        await db.put('sectors', sector);
      }
    }

    return sectors;
  }

  async getAllResources(): Promise<Resource[]> {
    const db = await this.initialize();
    const resources = await db.getAll('resources');

    if (resources.length === 0) {
      // Initialize default resources
      const defaultResources: Resource[] = [
        { id: 'energy', type: ResourceTypes.ENERGY, value: 50, maxCapacity: 100, productionRate: 0, consumptionRate: 0 },
        { id: 'data', type: ResourceTypes.DATA, value: 50, maxCapacity: 100, productionRate: 0, consumptionRate: 0 },
        { id: 'matter', type: ResourceTypes.MATTER, value: 50, maxCapacity: 100, productionRate: 0, consumptionRate: 0 },
        { id: 'quantum', type: ResourceTypes.QUANTUM, value: 50, maxCapacity: 100, productionRate: 0, consumptionRate: 0 },
        { id: 'population', type: ResourceTypes.POPULATION, value: 100, maxCapacity: 1000, productionRate: 0, consumptionRate: 0 },
      ];

      for (const resource of defaultResources) {
        await db.put('resources', resource);
      }
      return defaultResources;
    }

    return resources;
  }

  async updateSector(sector: QuantumSector): Promise<void> {
    const db = await this.initialize();
    await db.put('sectors', sector);
  }

  async updateResource(resource: Resource): Promise<void> {
    const db = await this.initialize();
    await db.put('resources', resource);
  }

  private generateSectorName(x: number, y: number): string {
    const zones = ['Neon', 'Quantum', 'Cyber', 'Solar', 'Plasma'];
    const names = ['Hub', 'Park', 'District', 'Zone', 'Spire', 'Core', 'Gate', 'Bay'];
    return `${zones[x % zones.length]} ${names[y % names.length]}`;
  }

  private getRandomSectorType(): string {
    const types = ['residential', 'commercial', 'industrial', 'tech', 'infrastructure'];
    return types[Math.floor(Math.random() * types.length)];
  }

  async clearAllData(): Promise<void> {
    const db = await this.initialize();
    await db.clear('timelines');
    await db.clear('sectors');
    await db.clear('resources');
    await db.clear('buildings');
    await db.clear('config');
  }
}

export const databaseService = new DatabaseService();