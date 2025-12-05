# Swift/Apple Project Configuration

> **Base Configuration**: This configuration extends `~/.claude/CLAUDE.md`

## Project Context

| Setting | Value |
|---------|-------|
| Platform | macOS |
| Framework | SwiftUI with NSView integration |
| Language | Swift 6.2 |
| Architecture | MVVM pattern |
| Concurrency | Swift 6 strict concurrency |

## Key Project Documents

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture, patterns, and component relationships
- **[README.md](README.md)** - Project specifications, requirements, and getting started guide
- **Source Documentation** - Module-specific documentation:
  - [Sources/Managers/](Sources/Managers/) - Core business logic managers
  - [Sources/Views/](Sources/Views/) - SwiftUI view layer
  - [Sources/Parsers/](Sources/Parsers/) - File format parsers
  - [Sources/Extensions/](Sources/Extensions/) - Framework extensions

## Required Rules

These rules from `~/.claude/rules/` apply to this Swift/macOS project:

### Development Rules

| Rule | Description |
|------|-------------|
| `swift.md` | Swift best practices and modern patterns |
| `swift6-concurrency.md` | Swift 6 concurrency, actors, Sendable compliance |
| `swift-observation.md` | Observation framework patterns |
| `mvvm.md` | MVVM architecture patterns |
| `swiftformat.md` | Code formatting with SwiftFormat |

### Critical Rules

| Rule | Priority | Description |
|------|----------|-------------|
| `permissions-guide.md` | **CRITICAL** | macOS permission handling (Photos, File System) |
| `security-privacy.md` | High | Security and privacy best practices |

### Quality Rules

| Rule | Description |
|------|-------------|
| `testing-strategy.md` | Unit and UI testing approach |
| `code-review.md` | Code review checklist |

## Recommended Agents

For macOS development on this project, use these specialized agents:

### Primary Agent

- `macos-developer` - macOS-specific: AppKit, NSView integration, file system access, sandboxing

### Supporting Agents

| Agent | Use Case |
|-------|----------|
| `apple-developer` | Cross-platform Apple development guidance |
| `ui-designer` | SwiftUI component design and layout |
| `test-automator` | Test automation for managers and views |

## Apple Documentation

Reference documentation available in `~/.claude/docs/apple/`:
- SwiftUI integration patterns
- NSView bridging for ColorWheel and DropFolder
- Photos framework access
- File system security-scoped bookmarks

## Project Customization

### Bundle Identifier

```
com.igrsoft.colir
```

### Target Version

```
macOS 14.1+
```

### Build Configurations

```
Debug Build: Configurations/debug.xcconfig
  - Development optimizations
  - Debug symbols enabled

Release Build: Configurations/release.xcconfig
  - Production optimizations
  - Strip debug symbols
```

### Entitlements

```
Configurations/entitlement.entitlements
  - App Sandbox enabled
  - Photo Library access
  - Pictures folder (read-only)
  - User-selected files (read-write)
  - Outgoing network connections
```

### Project-Specific Patterns

```
Manager Pattern - Business logic orchestration
  - PicturesFolderManager: File system browsing
  - PhotoLibraryAccessManager: Photos app integration
  - FileAccessManager: Permission handling
  - IconManager: Icon processing
  - ExportIconManager: Export functionality
  - EmojisManager: Emoji catalog

ViewModel Pattern - State management
  - HomeViewModel: Main interface state
  - Protocol-based dependencies
  - @ObservableObject with @Published

Parser Pattern - File format handling
  - RSRCFileParser: Mac OS Classic resources
  - Graphite C++ library integration

Extension Pattern - Framework augmentation
  - NSImage extensions (16 files)
  - NSColor extensions
  - View extensions
```

### Third-Party Dependencies

| Package | Purpose |
|---------|---------|
| SwiftCommons | Common utilities |
| SystemSettingsAccess | System preferences |
| DominantColor | Color extraction |
| Throttler | Debouncing |
| StoreKitPlus | In-app purchases |
| swift-algorithms | Collections |
| Graphite (C++) | Resource parsing |
