import React from 'react';
import { motion } from 'framer-motion';
import { useGame } from '../contexts/GameContext';
import { ResourceBar } from './ResourceBar';
import { SectorGrid } from './SectorGrid';
import { SectorDetail } from './SectorDetail';
import type { QuantumSector } from '../types/game';

export const HomeScreen: React.FC = () => {
  const { gameState, loading, error, clearData } = useGame();
  const [selectedSector, setSelectedSector] = React.useState<QuantumSector | null>(null);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          className="text-center"
        >
          <div className="text-6xl mb-4">⚛️</div>
          <h1 className="text-3xl font-bold text-cyan-400 mb-2">
            BitVerse
          </h1>
          <p className="text-slate-100Secondary">
            Initializing quantum civilization...
          </p>
          <motion.div
            className="mt-4 w-32 h-2 bg-slate-800 rounded-full overflow-hidden"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.5 }}
          >
            <motion.div
              className="h-full bg-cyan-400"
              initial={{ x: '-100%' }}
              animate={{ x: '100%' }}
              transition={{
                duration: 2,
                repeat: Infinity,
                ease: 'linear'
              }}
            />
          </motion.div>
        </motion.div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center cyber-card p-8 max-w-md"
        >
          <div className="text-6xl mb-4">🚨</div>
          <h2 className="text-2xl font-bold text-red-400 mb-4">
            System Error
          </h2>
          <p className="text-slate-100Secondary mb-6">{error}</p>
          <div className="space-y-3">
            <button
              onClick={() => window.location.reload()}
              className="cyber-button w-full"
            >
              Restart System
            </button>
            <button
              onClick={clearData}
              className="w-full py-2 px-4 bg-yellow-400 text-black rounded hover:bg-yellow-400/80 transition-colors"
            >
              Clear Data & Reset
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  if (!gameState) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="text-6xl mb-4">🎮</div>
          <p className="text-slate-100Secondary">No game state found</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Header */}
      <motion.header
        initial={{ y: -100, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        className="bg-slate-800 border-b border-cyan-400/30 p-4"
      >
        <div className="max-w-7xl mx-auto flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold text-cyan-400 tracking-wider">
              BITVERSE
            </h1>
            <p className="text-slate-400 text-sm">
              Quantum Civilization Builder
            </p>
          </div>
          <div className="flex items-center space-x-4">
            {gameState.timeline && (
              <div className="text-right">
                <p className="text-fuchsia-400 font-semibold">
                  {gameState.timeline.name}
                </p>
                <p className="text-slate-100Secondary text-sm">
                  Sequence #{gameState.timeline.sequenceNumber}
                </p>
              </div>
            )}
            <button
              onClick={clearData}
              className="px-3 py-1 bg-yellow-400 text-black rounded hover:bg-yellow-400/80 transition-colors text-sm"
            >
              Reset
            </button>
          </div>
        </div>
      </motion.header>

      {/* Resource Bar */}
      <ResourceBar resources={gameState.resources} />

      {/* Main Content */}
      <main className="max-w-7xl mx-auto p-6">
        {!selectedSector ? (
          <SectorGrid
            sectors={gameState.sectors}
            onSectorSelect={setSelectedSector}
          />
        ) : (
          <SectorDetail
            sector={selectedSector}
            onBack={() => setSelectedSector(null)}
          />
        )}
      </main>
    </div>
  );
};