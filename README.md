<picture>
  <source media="(prefers-color-scheme: light)" srcset="/.github/meta/dark.png">
  <source media="(prefers-color-scheme: dark)" srcset="/.github/meta/light.png">
  <img alt="Malpolys Game">
</picture>

## 📖 About

Malpolys is a unique tower defense game developed in Godot 4.4 that combines mathematical functions with strategic gameplay. Players place towers that modify enemy attributes using mathematical operations like addition, multiplication, and modulo. Built as part of game development coursework, this project demonstrates advanced game mechanics and procedural level generation.

🎮 **[Play Malpolys on itch.io](https://kejuwafel.itch.io/malpolys)**

## 🌟 Features

### Core Gameplay
- **Mathematical Tower Defense**: Towers apply mathematical functions to enemy stats
- **Dynamic Enemy Stats**: Health, shield, and speed calculated using mathematical functions (linear, quadratic, cubic, exponential)
- **Tower Types**: Addition, Multiplication, and Modulo towers with positive/negative effects
- **Procedural Level Generation**: Infinite expandable isometric grid with pathfinding
- **Wave-Based Progression**: Increasingly challenging waves with 4 enemy types

### Game Mechanics
- **Tower Upgrading**: 3-level upgrade system for each tower type
- **Target Selection**: Choose between Health, Shield, or Speed modifications
- **Neighbor System**: Towers can chain effects with adjacent towers
- **Economic System**: Earn money by defeating enemies, spend on towers and upgrades
- **Lives System**: Lose lives when enemies reach their goal

### Technical Features
- **Isometric Grid System**: Custom coordinate conversion and tile mapping
- **Dijkstra's Pathfinding**: Dynamic shortest path generation for expanding levels
- **Tween Animations**: Smooth UI transitions and effects
- **Modular Architecture**: Clean separation of game systems
- **Real-time Strategy Controls**: Camera panning, zooming, and tower placement

## 📁 Project Structure

```
malpolys/
├── scenes/
│   ├── enemies/              # Enemy variants (lins, quads, cubes, exes)
│   ├── towers/               # Tower types (add, mul, mod)
│   ├── level/                # Main game level
│   └── misc/                 # UI and menu scenes
├── scripts/
│   ├── enemies/              # Enemy behavior and mathematical functions
│   ├── towers/               # Tower mechanics and effect application
│   ├── level/                # Level generation and tile management
│   └── misc/                 # UI controllers and game management
├── assets/                   # Game sprites and audio
└── project.godot             # Godot project configuration
```

## 🎮 Game Mechanics

### Tower Types
- **Addition Towers**: Subtract values from enemy stats (1-3 based on level)
- **Multiplication Towers**: Divide enemy stats by factors (÷2, ÷3, ÷4)
- **Modulo Towers**: Apply modulo operations with random ranges

### Enemy Types
- **Lins**: Linear function enemies (f(x) = x)
- **Quads**: Quadratic function enemies (f(x) = x²)
- **Cubes**: Cubic function enemies (f(x) = x³)
- **Exes**: Exponential function enemies (f(x) = 2^x)

### Strategic Elements
- **Positive vs Negative Effects**: Choose whether towers help or hinder enemies
- **Tower Positioning**: Strategic placement affects neighbor bonuses
- **Economic Management**: Balance spending on new towers vs upgrades
- **Level Expansion**: Unlock new areas as the game progresses

## 🛠️ Development Notes

### Godot 4.4 Features Used
- **Isometric TileMapLayer**: Custom tile-based level generation
- **Dijkstra's Algorithm**: Dynamic shortest path calculation
- **Signal System**: Event-driven enemy and tower interactions
- **PackedScene System**: Modular enemy and tower instantiation

### Advanced Systems
- **Procedural Generation**: Dynamic level expansion with terrain connectivity
- **Function Composition**: Mathematical function chaining between towers
- **Real-time Pathfinding**: Routes recalculate as levels expand using Dijkstra's algorithm
- **Performance Optimization**: Efficient enemy spawning and cleanup

## 🎓 Educational Context

This project demonstrates advanced game development concepts:

### Mathematical Integration
- **Function-Based Gameplay**: Real mathematical concepts as core mechanics
- **Dynamic Calculations**: Runtime function composition and evaluation
- **Strategic Mathematics**: Players must understand function behavior

### Advanced Algorithms
- **Dijkstra's Pathfinding**: Shortest path calculation with guaranteed optimal routes
- **Procedural Generation**: Rule-based level creation with connectivity
- **State Management**: Complex game state with multiple interacting systems

### Game Architecture
- **Component System**: Modular tower and enemy design
- **Event-Driven Design**: Signal-based communication between systems
- **Data-Driven Configuration**: Export variables for easy balancing

## ⚖️ License

This repository is licensed under the [GNU General Public License v3.0](LICENSE).

With this license, you have the freedom to:
- Use, study, and run the software for any purpose
- Modify the software and adapt it to your needs
- Distribute copies of the original software
- Distribute copies of your modified versions

However, if you distribute this software (modified or unmodified), you must:
- Provide the source code under the same GPL-3.0 license
- Include copyright notices and license information
- Make your modifications available under GPL-3.0

## 📚 References

- [Godot Engine Documentation](https://docs.godotengine.org/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [TileMap Documentation](https://docs.godotengine.org/en/stable/classes/class_tilemap.html)
- [Dijkstra's Algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)
- [Tower Defense Game Design](https://gamedevelopment.tutsplus.com/tutorials/introduction-to-tower-defense--gamedev-14530)