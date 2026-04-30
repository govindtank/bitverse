import React from 'react';
import { motion } from 'framer-motion';
import type { Resource } from '../types/game';
import { ResourceTypes } from '../types/game';
import { Zap, Database, Package, Atom, Users } from 'lucide-react';

interface ResourceBarProps {
  resources: Resource[];
}

export const ResourceBar: React.FC<ResourceBarProps> = ({ resources }) => {
  const getResourceIcon = (type: string) => {
    switch (type) {
      case ResourceTypes.ENERGY:
        return <Zap className="w-4 h-4" />;
      case ResourceTypes.DATA:
        return <Database className="w-4 h-4" />;
      case ResourceTypes.MATTER:
        return <Package className="w-4 h-4" />;
      case ResourceTypes.QUANTUM:
        return <Atom className="w-4 h-4" />;
      case ResourceTypes.POPULATION:
        return <Users className="w-4 h-4" />;
    }
  };

  const getResourceColor = (type: string) => {
    switch (type) {
      case ResourceTypes.ENERGY:
        return 'text-yellow-400';
      case ResourceTypes.DATA:
        return 'text-blue-400';
      case ResourceTypes.MATTER:
        return 'text-orange-400';
      case ResourceTypes.QUANTUM:
        return 'text-fuchsia-400';
      case ResourceTypes.POPULATION:
        return 'text-green-400';
    }
  };

  return (
    <motion.div
      initial={{ y: -50, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.2 }}
      className="bg-slate-700 border-b border-cyan-400/30 p-4"
    >
      <div className="max-w-7xl mx-auto">
        <div className="flex flex-wrap justify-center gap-6">
          {resources.map((resource, index) => (
            <motion.div
              key={resource.id}
              initial={{ scale: 0, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ delay: 0.1 * index }}
              className="flex items-center space-x-3 bg-slate-800 px-4 py-2 rounded-lg border border-cyan-400/30"
            >
              <div className={getResourceColor(resource.type)}>
                {getResourceIcon(resource.type)}
              </div>
              <div className="text-center">
                <div className="text-lg font-bold text-slate-100">
                  {Math.floor(resource.value)}
                </div>
                <div className="text-xs text-slate-100Secondary uppercase">
                  {resource.type}
                </div>
              </div>
              <div className="w-16 h-2 bg-slate-900 rounded-full overflow-hidden">
                <motion.div
                  className="h-full bg-gradient-to-r from-cyber-primary to-cyber-accent"
                  initial={{ width: 0 }}
                  animate={{ width: `${(resource.value / resource.maxCapacity) * 100}%` }}
                  transition={{ duration: 0.5 }}
                />
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </motion.div>
  );
};