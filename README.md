# Colir

**Colir is a powerful icon customization utility for macOS.**

It allows users to personalize app icons by applying color overlays, photo backgrounds, emoji decorations, and visual effects. The app supports drag-and-drop workflow, integrates with the Photos app, and can extract icons from classic Mac OS resource files.

## Download

Available on the [Mac App Store](https://apps.apple.com/us/app/colir-folder-customizer/id6471902188)

## Features

- **Color Customization** - Apply any color with an interactive color wheel
- **Photo Integration** - Use photos from your library as icon backgrounds
- **Emoji Decorations** - Add emoji overlays with skin tone variants
- **Visual Effects** - Apply tints, gradients, and transparency effects
- **Drag &amp; Drop** - Simple file-based workflow
- **Undo/Redo** - Full history support for all operations

### Icon Sources

- **Applications** - Extract icons from .app bundles
- **Pictures Folder** - Browse your Pictures directory
- **Photos Library** - Access photos directly from Photos app
- **Classic Resources** - Parse Mac OS Classic .rsrc files
- **Web Resources** - Download icons from web sources

### Export Options

- **ICNS** - macOS icon format
- **PNG** - Standard image format
- **Multiple Sizes** - Export at various resolutions

### Additional Features

- **Real-time Preview** - See changes instantly
- **Style History** - Track and reapply previous customizations
- **Keyboard Shortcuts** - Efficient workflow with shortcuts
- **Dark Mode** - Native dark mode support
- **About and Support** - View version details, support links, and more Agnidia apps

## Technology Stack

- **Language**: Swift 6.3
- **UI Framework**: SwiftUI with NSView integration
- **Minimum Platform**: macOS 15.0+
- **Architecture**: MVVM pattern
- **Concurrency**: Swift 6 strict concurrency
- **Storage**: @AppStorage for preferences
- **In-App Purchases**: StoreKitPlus

## Requirements

- **macOS**: 15.0 or later
- **Hardware**: Any Mac running macOS 15.0+
- **Xcode**: 27 or later
- **Swift**: 6.3

## Architecture

Colir uses a modern MVVM architecture:

- **ViewModels**: State management and business logic coordination
- **Managers**: Domain-specific operations (Icon, Export, Photos, Files)
- **Parsers**: File format handling (RSRC resources)
- **Extensions**: Framework augmentation for images and colors

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed system architecture.

## Getting Started

### 1. Clone Repository

```bash
git clone <repository-url>
cd colir
```

### 2. Open in Xcode

```bash
open colir.xcodeproj
```

### 3. Build and Run

Select the **colir** scheme and press `Cmd+R` to build and run.

## Building

### Debug Build

```bash
xcodebuild -project colir.xcodeproj \
           -scheme colir \
           -configuration Debug \
           build
```

### Release Build

```bash
xcodebuild -project colir.xcodeproj \
           -scheme colir \
           -configuration Release \
           build
```

## Testing

### Run Unit Tests

```bash
xcodebuild test \
    -project colir.xcodeproj \
    -scheme colir \
    -destination 'platform=macOS'
```

### Run UI Tests

```bash
xcodebuild test \
    -project colir.xcodeproj \
    -scheme colir \
    -destination 'platform=macOS' \
    -only-testing:colirUITests
```

## Development

### Code Style

Project uses **SwiftFormat** for consistent code formatting:

```bash
swiftformat .
```

### AI Agent Configuration

This project includes AI development configuration:

- [AGENTS.md](AGENTS.md) - AI agent configuration for Swift/macOS development
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture documentation

### Build Configurations

| Config  | Purpose                        |
| ------- | ------------------------------ |
| Debug   | Development with debug symbols |
| Release | Production optimized           |

## Troubleshooting

### Photo Library Not Available

**Issue**: Cannot access photos from the app
**Solution**:

- Check photo library permissions in System Settings &gt; Privacy &amp; Security &gt; Photos
- Ensure Colir is granted access
- Restart the app after granting permissions

### Icons Not Loading

**Issue**: Dropped icons don't appear
**Solution**:

- Verify the file is a valid image or .app bundle
- Check file permissions
- For .rsrc files, ensure the file contains valid icon resources

### Export Fails

**Issue**: Cannot save exported icons
**Solution**:

- Verify write permissions for the destination folder
- Grant file access when prompted
- Try a different export location

### Color Wheel Not Responding

**Issue**: Color picker doesn't respond to input
**Solution**:

- Resize the window slightly to refresh the view
- Check if another app is capturing mouse events
- Restart the application

## Privacy &amp; Security

Colir prioritizes your privacy and security:

- **Local Processing**: All icon processing happens on your device
- **No Analytics**: No data is collected or sent to external services
- **Sandboxed**: App runs in macOS sandbox with minimal permissions
- **No Network Required**: Core features work completely offline
- **Photo Access**: Photos are accessed read-only, never modified

## Contributing

### Before Committing

1. **Format code**: Run `swiftformat .`
2. **Run tests**: Ensure all tests pass
3. **Update docs**: If adding features

## License

Copyright 2025 Agnidia. All rights reserved.

See [LICENSE](LICENSE) file for details.

## Contact

For issues or questions:

- Create an issue in this repository
- Contact: [support@agnidia.com](mailto:support@agnidia.com)

---

**Made with care by Agnidia**
