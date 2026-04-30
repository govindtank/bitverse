import React, { createContext, useContext, useEffect, useState, type ReactNode } from 'react';
import type { GameState, QuantumSector, Resource } from '../types/game';
import { databaseService } from '../services/database';

interface GameContextType {
  gameState: GameState | null;
  loading: boolean;
  error: string | null;
  refreshGameState: () => Promise<void>;
  updateSector: (sector: QuantumSector) => Promise<void>;
  updateResource: (resource: Resource) => Promise<void>;
  initializeGame: () => Promise<void>;
  clearData: () => Promise<void>;
}

const GameContext = createContext<GameContextType | undefined>(undefined);

export const useGame = () => {
  const context = useContext(GameContext);
  if (!context) {
    throw new Error('useGame must be used within a GameProvider');
  }
  return context;
};

interface GameProviderProps {
  children: ReactNode;
}

export const GameProvider: React.FC<GameProviderProps> = ({ children }) => {
  const [gameState, setGameState] = useState<GameState | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const initializeGame = async () => {
    try {
      setLoading(true);
      setError(null);

      // Get or create timeline
      let timeline = await databaseService.getCurrentTimeline();
      if (!timeline) {
        timeline = await databaseService.createTimeline('Prime');
      }

      // Get config
      const config = await databaseService.getGameConfig();

      // Get sectors (initialize if empty)
      let sectors = await databaseService.getAllSectors();
      if (sectors.length === 0) {
        sectors = await databaseService.initializeGrid(config.gridSize);
      }

      // Get resources
      const resources = await databaseService.getAllResources();

      const newGameState: GameState = {
        timeline,
        sectors,
        resources,
        config,
        isInitialized: true,
      };

      setGameState(newGameState);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to initialize game');
    } finally {
      setLoading(false);
    }
  };

  const refreshGameState = async () => {
    if (!gameState) return;

    try {
      const [timeline, sectors, resources, config] = await Promise.all([
        databaseService.getCurrentTimeline(),
        databaseService.getAllSectors(),
        databaseService.getAllResources(),
        databaseService.getGameConfig(),
      ]);

      setGameState({
        timeline: timeline || gameState.timeline,
        sectors,
        resources,
        config,
        isInitialized: true,
      });
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to refresh game state');
    }
  };

  const updateSector = async (sector: QuantumSector) => {
    try {
      await databaseService.updateSector(sector);
      await refreshGameState();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update sector');
    }
  };

  const updateResource = async (resource: Resource) => {
    try {
      await databaseService.updateResource(resource);
      await refreshGameState();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to update resource');
    }
  };

  const clearData = async () => {
    try {
      await databaseService.clearAllData();
      setGameState(null);
      await initializeGame();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to clear data');
    }
  };

  useEffect(() => {
    initializeGame();
  }, []);

  const value: GameContextType = {
    gameState,
    loading,
    error,
    refreshGameState,
    updateSector,
    updateResource,
    initializeGame,
    clearData,
  };

  return (
    <GameContext.Provider value={value}>
      {children}
    </GameContext.Provider>
  );
};