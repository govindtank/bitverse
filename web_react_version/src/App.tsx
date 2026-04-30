import { GameProvider } from './contexts/GameContext';
import { HomeScreen } from './components/HomeScreen';
import './App.css';

function App() {
  return (
    <GameProvider>
      <div className="min-h-screen bg-slate-900 text-slate-100">
        <HomeScreen />
      </div>
    </GameProvider>
  );
}

export default App
