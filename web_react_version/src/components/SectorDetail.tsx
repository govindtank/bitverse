import React, { useState } from 'react';
import { motion } from 'framer-motion';
import type { QuantumSector } from '../types/game';
import { useGame } from '../contexts/GameContext';
import { ArrowLeft, Building, Users, Zap, TrendingUp } from 'lucide-react';

interface SectorDetailProps {
  sector: QuantumSector;
  onBack: () => void;
}

export const SectorDetail: React.FC<SectorDetailProps> = ({ sector, onBack }) => {
  const { updateSector } = useGame();
  const [isUpgrading, setIsUpgrading] = useState(false);

  const handleUpgrade = async () => {
    setIsUpgrading(true);
    const updatedSector = {
      ...sector,
      resourceLevel: Math.min(100, sector.resourceLevel + 10),
      population: sector.population + 25,
    };
    await updateSector(updatedSector);
    setIsUpgrading(false);
  };

  const handleAddPopulation = async () => {
    const updatedSector = {
      ...sector,
      population: sector.population + 50,
    };
    await updateSector(updatedSector);
  };

  const handleBoostResources = async () => {
    const updatedSector = {
      ...sector,
      resourceLevel: Math.min(100, sector.resourceLevel + 15),
    };
    await updateSector(updatedSector);
  };

  const getSectorTypeColor = (type: string) => {
    switch (type) {
      case 'residential':
        return 'text-green-400 border-green-400';
      case 'commercial':
        return 'text-blue-400 border-blue-400';
      case 'industrial':
        return 'text-orange-400 border-orange-400';
      case 'tech':
        return 'text-cyan-400 border-cyan-400';
      case 'infrastructure':
        return 'text-gray-400 border-gray-400';
      default:
        return 'text-slate-100Secondary border-cyber-textSecondary';
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, x: 100 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -100 }}
      className="max-w-4xl mx-auto"
    >
      {/* Header */}
      <div className="flex items-center mb-6">
        <button
          onClick={onBack}
          className="flex items-center space-x-2 text-cyan-400 hover:text-cyan-400/80 transition-colors mr-4"
        >
          <ArrowLeft className="w-5 h-5" />
          <span>Back</span>
        </button>
        <div>
          <h1 className="text-3xl font-bold text-cyan-400">{sector.name}</h1>
          <p className="text-slate-100Secondary">Sector ({sector.gridX}, {sector.gridY})</p>
        </div>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        {/* Sector Info */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="cyber-card p-6"
        >
          <h2 className="text-xl font-bold text-cyan-400 mb-4 flex items-center">
            <Building className="w-5 h-5 mr-2" />
            Sector Information
          </h2>

          <div className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-slate-100Secondary">Type:</span>
              <span className={`px-3 py-1 rounded text-sm font-bold uppercase ${getSectorTypeColor(sector.type)}`}>
                {sector.type}
              </span>
            </div>

            <div className="flex justify-between items-center">
              <span className="text-slate-100Secondary">Population:</span>
              <div className="flex items-center space-x-2">
                <Users className="w-4 h-4 text-green-400" />
                <span className="font-bold text-slate-100">{sector.population}</span>
              </div>
            </div>

            <div>
              <div className="flex justify-between items-center mb-2">
                <span className="text-slate-100Secondary">Resource Level:</span>
                <span className="font-bold text-slate-100">{Math.floor(sector.resourceLevel)}%</span>
              </div>
              <div className="w-full h-3 bg-slate-900 rounded-full overflow-hidden">
                <motion.div
                  className="h-full bg-gradient-to-r from-cyber-primary to-cyber-accent"
                  initial={{ width: 0 }}
                  animate={{ width: `${sector.resourceLevel}%` }}
                  transition={{ duration: 0.5 }}
                />
              </div>
            </div>

            <div className="flex justify-between items-center">
              <span className="text-slate-100Secondary">Buildings:</span>
              <span className="font-bold text-slate-100">{sector.buildings.length}</span>
            </div>

            <div className="flex justify-between items-center">
              <span className="text-slate-100Secondary">Created:</span>
              <span className="text-sm text-slate-100Secondary">
                {new Date(sector.createdAt).toLocaleDateString()}
              </span>
            </div>
          </div>
        </motion.div>

        {/* Buildings */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="cyber-card p-6"
        >
          <h2 className="text-xl font-bold text-fuchsia-400 mb-4 flex items-center">
            <Building className="w-5 h-5 mr-2" />
            Buildings
          </h2>

          {sector.buildings.length === 0 ? (
            <div className="text-center py-8">
              <Building className="w-12 h-12 text-slate-100Secondary mx-auto mb-4" />
              <p className="text-slate-100Secondary">No buildings constructed yet</p>
              <p className="text-sm text-slate-100Secondary mt-2">
                Buildings will be added in future updates
              </p>
            </div>
          ) : (
            <div className="space-y-2">
              {sector.buildings.map((building, index) => (
                <div
                  key={index}
                  className="flex items-center space-x-3 p-3 bg-slate-900 rounded"
                >
                  <Building className="w-4 h-4 text-fuchsia-400" />
                  <span className="text-slate-100">{building}</span>
                </div>
              ))}
            </div>
          )}
        </motion.div>

        {/* Actions */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="md:col-span-2 cyber-card p-6"
        >
          <h2 className="text-xl font-bold text-green-400 mb-4 flex items-center">
            <TrendingUp className="w-5 h-5 mr-2" />
            Management Actions
          </h2>

          <div className="grid md:grid-cols-3 gap-4">
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleUpgrade}
              disabled={isUpgrading}
              className="cyber-button flex items-center justify-center space-x-2 disabled:opacity-50"
            >
              {isUpgrading ? (
                <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-black"></div>
              ) : (
                <TrendingUp className="w-4 h-4" />
              )}
              <span>{isUpgrading ? 'Upgrading...' : 'Upgrade Sector'}</span>
            </motion.button>

            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleAddPopulation}
              className="flex items-center justify-center space-x-2 py-3 px-4 bg-green-400 text-black font-bold rounded hover:bg-green-400/80 transition-all duration-200"
            >
              <Users className="w-4 h-4" />
              <span>Add Population</span>
            </motion.button>

            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleBoostResources}
              className="flex items-center justify-center space-x-2 py-3 px-4 bg-gradient-to-r from-cyber-primary to-cyber-secondary text-black font-bold rounded hover:from-cyber-primary/80 hover:to-cyber-secondary/80 transition-all duration-200"
            >
              <Zap className="w-4 h-4" />
              <span>Boost Resources</span>
            </motion.button>
          </div>
        </motion.div>
      </div>
    </motion.div>
  );
};