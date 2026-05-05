# BitVerse - Quantum Civilization Builder 🚀

<div align="center">

![BitVerse Banner](https://img.shields.io/badge/BitVerse-Quantum%20Civilization-00FFFF?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJ0d2l0dGVyIj48cGF0aCBkPSJNMTIgMkM2LjQ4IDIgMiA2LjQ4IDIgMTJzNC40OCAxMCAxMCAxMCAxMC00LjQ4IDEwLTEwLTQtNi4wMi02LjAyLTEweiIvPjxwYXRoIGQ9Ik05IDE1djFDOSAxNi4xIDguMSAyMSAyIDJxLTQuNDgtNC40OC03LTdINXYtMnYyaC0ydjJoLTJWNyBoIDJWNXYxLjkyYzIuOTMgMS4xOSA1IDQuMDYgNSA3LjQxIDAgMi4wOC0uOCAzLjk3LTIuMSA1LjM5eiIgc3Ryb2tlPSIjMDBGRkZGRiIvPjwvc3ZnPg==)

A cyberpunk-themed quantum civilization builder game built with Flutter.

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0.0-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Web Build](https://img.shields.io/badge/Web-Build%20Passing-00FFFF?style=flat-square)](https://github.com/govindtank/bitverse/actions)
[![Live Demo](https://img.shields.io/badge/Live-Demo-FF00FF?style=flat-square)](https://govindtank.github.io/bitverse/)

</div>

---

## 🎮 Game Overview

**BitVerse** is an immersive quantum civilization builder set in a cyberpunk future. Build and manage sectors across multiple timelines, gather resources, construct buildings, and watch your digital empire grow.

### Features

- 🏙️ **Sector Management** - Build and upgrade multiple districts (Residential, Commercial, Industrial, Tech, Infrastructure)
- ⚡ **Resource System** - Manage Energy, Data, Matter, Quantum, and Population resources
- 🌌 **Quantum Timelines** - Explore and progress through multiple parallel timelines
- 🎨 **Cyberpunk Aesthetic** - Stunning neon visuals with smooth animations and glowing effects
- 📱 **Cross-Platform** - Works seamlessly on Web, iOS, Android, and Desktop
- 💾 **Persistent Progress** - Save and load your game progress locally
- ♿ **Responsive Design** - Optimized for both mobile and desktop browsers

---

## 🛠️ Tech Stack

| Technology | Purpose | Version |
|------------|---------|---------|
| Flutter | UI Framework | 3.24.0 |
| Dart | Programming Language | 3.0.0+ |
| Riverpod | State Management | ^2.4.9 |
| sqflite | Local Database | ^2.3.3 |
| flutter_animate | Animations | ^4.3.0 |
| fl_chart | Data Visualization | ^0.65.0 |

---

## 📁 Project Structure

```
bitverse/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── screens/
│   │   ├── splash_screen.dart       # Animated splash screen
│   │   ├── home_screen.dart         # Main game screen
│   │   └── sector_detail_screen.dart # Sector management
│   ├── theme/
│   │   └── cyberpunk_theme.dart     # Custom cyberpunk theme
│   ├── providers/
│   │   └── game_providers.dart      # Riverpod state providers
│   ├── models/
│   │   ├── quantum_sector.dart      # Sector data model
│   │   ├── quantum_timeline.dart    # Timeline model
│   │   ├── resource.dart            # Resource model
│   │   ├── building.dart            # Building model
│   │   └── all_models.dart          # Model exports
│   ├── services/
│   │   └── quantum_engine.dart      # Game logic engine
│   └── database/
│       └── database_helper.dart     # SQLite/IndexedDB helper
├── web/
│   ├── index.html                   # Web entry point
│   └── manifest.json                # PWA manifest
├── assets/                          # Images and fonts
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/govindtank/bitverse.git
   cd bitverse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Web
   flutter run -d chrome
   
   # iOS Simulator
   flutter run -d iPhone
   
   # Android Emulator
   flutter run -d android
   ```

### Building for Web

```bash
flutter build web --release --base-href /bitverse/
```

The build output will be in `build/web/`.

---

## 🎨 UI/UX Features

### Cyberpunk Theme
- Dark background with neon accents (Cyan, Magenta, Green)
- Glowing borders and shadows
- Grid-based background patterns
- Monospace typography for headers

### Animations
- Splash screen with pulsing logo
- Smooth page transitions
- Staggered card animations
- Shimmer loading effects
- Hover effects on desktop

### Responsive Design
- Mobile-first approach
- Adaptive layouts for tablet/desktop
- Touch-friendly controls
- Keyboard navigation support

---

## 🌐 Live Demo

Visit the live demo at: **[https://govindtank.github.io/bitverse/](https://govindtank.github.io/bitverse/)**

---

## 🔄 CI/CD Pipeline

This project uses GitHub Actions for automated deployment:

- **On Push to `main`**: Runs tests and builds for web
- **On Release**: Deploys to GitHub Pages

### Workflow

1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Run analysis
5. Build web app
6. Deploy to GitHub Pages

---

## 📝 Gameplay Guide

### Resources
| Resource | Icon | Description |
|----------|------|-------------|
| Energy | ⚡ | Powers your civilization |
| Data | 📊 | Information and knowledge |
| Matter | 🏗️ | Physical resources |
| Quantum | ⚛️ | Rare quantum energy |
| Population | 👥 | Citizens and workers |

### Sector Types
- **Residential** - House your population
- **Commercial** - Generate income and data
- **Industrial** - Produce matter and energy
- **Tech** - Advance your civilization
- **Infrastructure** - Support other sectors

### Tips
- Keep resources balanced for optimal growth
- Upgrade sectors to increase resource production
- Build diverse sectors for synergies
- Check the timeline for special events

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Govind Tank** - [GitHub](https://github.com/govindtank) - govindtank600@gmail.com

---

<div align="center">

Made with ❤️ using Flutter

*"Building the future, one quantum at a time."*

</div>
