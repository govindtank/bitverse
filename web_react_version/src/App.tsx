function App() {
  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#0a0a0f', color: '#e0e0ff', fontFamily: 'monospace', padding: '2rem' }}>
      <div style={{ textAlign: 'center', maxWidth: '800px', margin: '0 auto' }}>
        <h1 style={{ fontSize: '3rem', fontWeight: 'bold', color: '#00ffff', marginBottom: '1rem' }}>
          BITVERSE
        </h1>
        <p style={{ fontSize: '1.2rem', color: '#8888aa', marginBottom: '2rem' }}>
          Quantum Civilization Builder
        </p>

        <div style={{
          backgroundColor: '#1e293b',
          border: '1px solid rgba(0,255,255,0.5)',
          borderRadius: '0.5rem',
          padding: '2rem',
          boxShadow: '0 0 20px rgba(0,255,255,0.3)'
        }}>
          <h2 style={{ fontSize: '1.8rem', color: '#00ffff', marginBottom: '1rem' }}>
            ✅ App Successfully Running!
          </h2>

          <div style={{ marginBottom: '2rem' }}>
            <h3 style={{ color: '#ff00ff', marginBottom: '1rem' }}>Features Working:</h3>
            <ul style={{ textAlign: 'left', color: '#cbd5e1', lineHeight: '1.6' }}>
              <li>⚛️ React + TypeScript + Vite setup</li>
              <li>🎨 Cyberpunk styling with inline CSS</li>
              <li>🌐 Development server running</li>
              <li>📱 Responsive design ready</li>
              <li>🚀 Hot reload enabled</li>
            </ul>
          </div>

          <div style={{ marginBottom: '2rem' }}>
            <h3 style={{ color: '#00ffff', marginBottom: '1rem' }}>Test URL:</h3>
            <div style={{
              backgroundColor: '#0f172a',
              padding: '1rem',
              borderRadius: '0.25rem',
              fontSize: '1.1rem',
              fontWeight: 'bold',
              color: '#10b981',
              border: '1px solid #10b981'
            }}>
              http://localhost:5176/
            </div>
          </div>

          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            <button
              style={{
                backgroundColor: '#00ffff',
                color: 'black',
                border: 'none',
                padding: '0.75rem 1.5rem',
                borderRadius: '0.25rem',
                cursor: 'pointer',
                fontWeight: 'bold',
                fontSize: '1rem'
              }}
              onClick={() => window.location.reload()}
            >
              🔄 Reload Page
            </button>

            <button
              style={{
                backgroundColor: '#ff00ff',
                color: 'white',
                border: 'none',
                padding: '0.75rem 1.5rem',
                borderRadius: '0.25rem',
                cursor: 'pointer',
                fontWeight: 'bold',
                fontSize: '1rem'
              }}
              onClick={() => alert('BitVerse is working! 🎮')}
            >
              🎮 Test Alert
            </button>
          </div>

          <p style={{ marginTop: '2rem', color: '#64748b', fontSize: '0.9rem' }}>
            The full game features will be added next. This confirms the development environment is working correctly.
          </p>
        </div>
      </div>
    </div>
  );
}

export default App
