<picture>
  <source media="(prefers-color-scheme: light)" srcset="/.github/meta/dark.png">
  <source media="(prefers-color-scheme: dark)" srcset="/.github/meta/light.png">
  <img alt="Malpolys Game">
</picture>

## 📖 About

Malpolys is a game developed in Godot 4.4 featuring a polished splash screen system and modern UI design. Built as part of game development coursework, this project demonstrates professional game architecture patterns and smooth scene transitions.

## 🌟 Features

### Core Systems
- **Smooth Splash Screen**: Animated fade-in/fade-out transitions with customizable timing
- **Scene Management**: Efficient scene loading and transitions
- **Responsive UI**: Full HD (1920x1080) interface with proper scaling
- **Professional Presentation**: Custom splash screen with fade effects

### Technical Features
- **Modular Architecture**: Clean separation of scripts and scenes
- **Tween Animations**: Smooth property animations using Godot's tween system
- **Configurable Timing**: Easily adjustable fade and pause durations
- **Asset Organization**: Structured asset management system

## 📁 Project Structure

```
malpolys/
├── scenes/
│   └── misc/
│       ├── splash.tscn         # Splash screen scene
│       └── main_menu.tscn      # Main menu scene
├── scripts/
│   └── misc/
│       └── splash.gd           # Splash screen controller
├── assets/
│   └── misc/
│       ├── splash_image.png    # Background image
│       └── fade_splash.png     # Splash logo
└── project.godot               # Godot project configuration
```

## 🛠️ Development Notes

### Godot 4.4 Features Used
- **Modern GDScript**: Type hints and improved syntax
- **Tween System**: New tween API with method chaining
- **Scene Management**: Updated scene loading methods
- **Export Variables**: Easy designer customization

### Performance Optimizations
- **Texture Compression**: Platform-specific optimization
- **Scene Preloading**: PackedScene resources for faster loading
- **Memory Management**: Proper resource cleanup

## 🎓 Educational Context

This project demonstrates key game development concepts:

### Architecture Patterns
- **Scene-Script Separation**: Clean MVC-like architecture
- **Export Variables**: Designer-friendly configuration
- **Modular Design**: Reusable component structure

### Animation Techniques
- **Tween Sequences**: Chained animation programming
- **Alpha Blending**: Smooth visual transitions
- **Timing Control**: Precise animation coordination

### Godot Best Practices
- **Node Structure**: Proper scene hierarchy design
- **Script Organization**: Logical file and folder structure
- **Resource Management**: Efficient asset loading and cleanup

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
- [Scene Management in Godot](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_tree.html)
- [Tween Animation Guide](https://docs.godotengine.org/en/stable/classes/class_tween.html)
