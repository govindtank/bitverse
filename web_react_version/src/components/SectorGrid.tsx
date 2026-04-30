import React from 'react';
import { motion } from 'framer-motion';
import type { QuantumSector } from '../types/game';
import { Building, Users } from 'lucide-react';

interface SectorGridProps {
  sectors: QuantumSector[];
  onSectorSelect: (sector: QuantumSector) => void;
}

export const SectorGrid: React.FC<SectorGridProps> = ({ sectors, onSectorSelect }) => {
  const getSectorTypeColor = (type: string) => {
    switch (type) {
      case 'residential':
        return 'border-green-400 bg-green-400/10';
      case 'commercial':
        return 'border-blue-400 bg-blue-400/10';
      case 'industrial':
        return 'border-orange-400 bg-orange-400/10';
      case 'tech':
        return 'border-cyan-400 bg-cyan-400/10';
      case 'infrastructure':
        return 'border-gray-400 bg-gray-400/10';
      default:
        return 'border-cyber-textSecondary bg-cyber-textSecondary/10';
    }
  };

  const getResourceColor = (level: number) => {
    if (level >= 70) return 'bg-green-400';
    if (level >= 40) return 'bg-yellow-400';
    return 'bg-red-400';
  };

  return (
    <div>
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center mb-8"
      >
        <h2 className="text-2xl font-bold text-cyan-400 mb-2">
          Quantum Civilization Grid
        </h2>
        <p className="text-slate-100Secondary">
          Tap sectors to manage your quantum civilization
        </p>
      </motion.div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.3 }}
        className="cyber-grid max-w-6xl mx-auto"
      >
        {sectors.map((sector, index) => (
          <motion.div
            key={sector.id}
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{
              delay: 0.05 * index,
              type: 'spring',
              stiffness: 100,
            }}
            whileHover={{
              scale: 1.05,
              boxShadow: '0 0 30px rgba(0, 255, 255, 0.5)',
            }}
            whileTap={{ scale: 0.95 }}
            onClick={() => onSectorSelect(sector)}
            className={`cyber-card p-4 cursor-pointer hover:border-cyan-400 transition-all duration-200 ${getSectorTypeColor(sector.type)}`}
          >
            <div className="text-center">
              <h3 className="font-bold text-slate-100 mb-2 text-sm">
                {sector.name}
              </h3>

              <div className="space-y-2">
                {/* Resource Level */}
                <div>
                  <div className="flex items-center justify-between text-xs text-slate-100Secondary mb-1">
                    <span>Resources</span>
                    <span>{Math.floor(sector.resourceLevel)}%</span>
                  </div>
                  <div className="w-full h-2 bg-slate-900 rounded-full overflow-hidden">
                    <div
                      className={`h-full ${getResourceColor(sector.resourceLevel)} transition-all duration-300`}
                      style={{ width: `${sector.resourceLevel}%` }}
                    />
                  </div>
                </div>

                {/* Population */}
                <div className="flex items-center justify-between text-xs">
                  <Users className="w-3 h-3 text-green-400" />
                  <span className="text-slate-100">{sector.population}</span>
                </div>

                {/* Buildings */}
                <div className="flex items-center justify-between text-xs">
                  <Building className="w-3 h-3 text-fuchsia-400" />
                  <span className="text-slate-100">{sector.buildings.length}</span>
                </div>

                {/* Sector Type */}
                <div className="mt-2">
                  <span className="text-xs uppercase font-bold text-slate-100Secondary px-2 py-1 bg-slate-900 rounded">
                    {sector.type}
                  </span>
                </div>
              </div>
            </div>
          </motion.div>
        ))}
      </motion.div>

      {sectors.length === 0 && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="text-center mt-12"
        >
          <div className="text-6xl mb-4">🌌</div>
          <p className="text-slate-100Secondary">
            Initializing quantum sectors...
          </p>
        </motion.div>
      )}
    </div>
  );
};