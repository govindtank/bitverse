# BitVerse - Quantum Civilization Builder (React Web Version)

A modern cyberpunk strategy game built with React, TypeScript, and Tailwind CSS.

## Features

- 🚀 **Modern Tech Stack**: React 18 + TypeScript + Vite + Tailwind CSS
- 🎨 **Cyberpunk Theme**: Neon colors and futuristic UI design
- 💾 **Persistent Storage**: IndexedDB for client-side data persistence
- ⚡ **Fast Performance**: Optimized with Vite and modern React patterns
- 📱 **Responsive Design**: Works on desktop and mobile devices
- 🎮 **Interactive Gameplay**: Build and manage quantum civilizations

## Game Features

- **Resource Management**: Track energy, data, matter, quantum power, and population
- **Sector Grid**: 8x8 quantum civilization grid
- **Sector Management**: Upgrade sectors, add population, boost resources
- **Building System**: Framework for future building construction
- **Timeline System**: Quantum timeline management (expandable)

## Tech Stack

- **Frontend**: React 18 with TypeScript
- **Styling**: Tailwind CSS with custom cyberpunk theme
- **Animations**: Framer Motion for smooth interactions
- **Icons**: Lucide React for consistent iconography
- **Database**: IndexedDB via idb library
- **Build Tool**: Vite for fast development and building

## Getting Started

### Prerequisites

- Node.js 18+ and npm

### Installation

1. **Clone and navigate to the project:**
   ```bash
   cd web_react_version
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start development server:**
   ```bash
   npm run dev
   ```

4. **Open your browser:**
   - Visit `http://localhost:5173`
   - The app will automatically reload when you make changes

### Building for Production

```bash
npm run build
```

The built files will be in the `dist/` directory.

## Project Structure

```
web_react_version/
├── public/                 # Static assets
│   ├── manifest.json      # PWA manifest
│   └── ...
├── src/
│   ├── components/        # React components
│   │   ├── HomeScreen.tsx
│   │   ├── ResourceBar.tsx
│   │   ├── SectorGrid.tsx
│   │   └── SectorDetail.tsx
│   ├── contexts/          # React contexts
│   │   └── GameContext.tsx
│   ├── services/          # Business logic
│   │   └── database.ts
│   ├── types/            # TypeScript types
│   │   └── game.ts
│   ├── App.tsx           # Main app component
│   ├── main.tsx          # App entry point
│   └── index.css         # Global styles
├── tailwind.config.js    # Tailwind configuration
├── vite.config.ts        # Vite configuration
└── package.json          # Dependencies
```

## Game Controls

- **Navigation**: Click sectors in the grid to view details
- **Actions**: Use buttons in sector details to upgrade, add population, or boost resources
- **Reset**: Use the reset button in the header to clear all data

## Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

### Code Style

- TypeScript for type safety
- ESLint for code quality
- Prettier for code formatting
- Tailwind CSS for styling

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Future Enhancements

- [ ] Building construction system
- [ ] Multiple timeline management
- [ ] Advanced resource trading
- [ ] Multiplayer features
- [ ] Achievement system
- [ ] PWA offline support
- [ ] Mobile app version